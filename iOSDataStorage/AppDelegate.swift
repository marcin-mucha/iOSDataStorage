//
//  AppDelegate.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 25/10/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import UIKit
import CoreData

let MyManagedObjectContextSaveDidFailNotification = "MyManagedObjectContextSaveDidFailNotification"
func fatalCoreData(error: Error) {
    print("***Fatal error: \(error)")
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: MyManagedObjectContextSaveDidFailNotification), object: nil)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        guard let modelURL = Bundle.main.url(forResource: "ContentCD", withExtension: "momd") else {
            fatalError("Could not find data model in app bundle")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing model from: \(modelURL)")
        }
        let urls = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0]
        let storeURL = documentsDirectory.appendingPathComponent("ContentCD.sqlite")
        do {
            let coordinator = NSPersistentStoreCoordinator(
                managedObjectModel: model)
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil, at: storeURL, options: nil)
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            return context
        } catch {
            fatalError("Error adding persistent store at \(storeURL): \(error)")
        }
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let tabBarController = window!.rootViewController as! UITabBarController
        let repository = determineStorageType()
        //let repository = CoreDataRepository(managedObjectContext: managedObjectContext)
        //let repository = RealmRepository()
        //let repository = CouchbaseRepository()
        if let tabBarViewControllers = tabBarController.viewControllers {
            let nc0 = tabBarViewControllers[0] as! UINavigationController
            let homeViewController = nc0.viewControllers[0] as! HomeViewController
            homeViewController.repository = repository
            let nc = tabBarViewControllers[1] as! UINavigationController
            let contentTableViewController = nc.viewControllers[0] as! ContentTableViewController
            contentTableViewController.repository = repository
        }
        listenForFatalCoreDataNotifications()
        return true

    }
    
    func determineStorageType() -> ContentRepository {
        let defaults = UserDefaults.standard
        var repository: ContentRepository
        if let storageType = defaults.string(forKey: "storage") {
            switch storageType {
            case StorageType.CoreData.rawValue:
                repository = CoreDataRepository(managedObjectContext: managedObjectContext)
            case StorageType.Realm.rawValue:
                repository = RealmRepository()
            case StorageType.Couchbase.rawValue:
                repository = CouchbaseRepository()
            default:
                defaults.set(StorageType.CoreData.rawValue, forKey: "storage")
                repository = CoreDataRepository(managedObjectContext: managedObjectContext)
            }
        } else {
            defaults.set(StorageType.CoreData.rawValue, forKey: "storage")
            repository = CoreDataRepository(managedObjectContext: managedObjectContext)
        }
        return repository
    }
    
    func listenForFatalCoreDataNotifications() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: MyManagedObjectContextSaveDidFailNotification), object: nil, queue: OperationQueue.main, using: {
            notification in
            let alert = UIAlertController(title: "Interal Error", message: "Pojawił się błąd krytyczny i aplikacja musi zostać zakończona", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) {
                _ in
                let exception = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Fatal Core Data Error", userInfo: nil)
                exception.raise()
            }
            alert.addAction(action)
            self.viewControllerForShowingAlert().present(alert, animated: true, completion: nil)
        })
    }
    
    func viewControllerForShowingAlert() -> UIViewController {
        let rootViewController = self.window!.rootViewController!
        if let presentedViewController = rootViewController.presentedViewController {
            return presentedViewController
        } else {
            return rootViewController
        }
    }
}

