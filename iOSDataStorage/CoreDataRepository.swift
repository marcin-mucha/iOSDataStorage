//
//  CoreDataRepository.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 12/11/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//
import CoreData
import Foundation
import UIKit

class CoreDataRepository : ContentRepository {
    var managedObjectContext: NSManagedObjectContext
    let contentsFetch = NSFetchRequest<ContentCD>(entityName: "ContentCD")
    lazy var contents: [ContentCD] = {
        return self.fetch()
    }()
    
//    lazy var fetchedResultsController: NSFetchedResultsController<ContentCD> = {
//        let fetchRequest = NSFetchRequest<ContentCD>()
//        let entity = NSEntityDescription.entity(forEntityName: "ContentCD", in: self.managedObjectContext)
//        fetchRequest.entity = entity
//        let sortDescriptor1 = NSSortDescriptor(key: "artistName", ascending: true)
//        let sortDescriptor2 = NSSortDescriptor(key: "trackName", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
//        fetchRequest.fetchBatchSize = 20
//        let fetchedResultsController = NSFetchedResultsController<ContentCD>(
//            fetchRequest: fetchRequest,
//            managedObjectContext: self.managedObjectContext,
//            sectionNameKeyPath: nil,
//            cacheName: "Contents")
//       // fetchedResultsController.delegate = self
//        return fetchedResultsController
//    }()
//    
//    deinit {
//        fetchedResultsController.delegate = nil
//    }
    

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    func save(contents: [Content]) {
        print("*** Rozpoczęto zapisywanie ***")
        for content in contents {
            let contentCD = NSEntityDescription.insertNewObject(forEntityName: "ContentCD", into: managedObjectContext) as! ContentCD
            contentCD.artistName = content.artistName
            if let image = content.artworkImage {
                contentCD.artworkImage = UIImagePNGRepresentation(image) as NSData?
            } else {
                contentCD.artworkImage = nil
            }
            contentCD.collectionName = content.collectionName
            contentCD.country = content.country
            contentCD.date = content.date as NSDate
            contentCD.genreName = content.primaryGenreName
            contentCD.kind = content.kind
            contentCD.trackName = content.trackName
            managedObjectContext.safeSave()

        }
        print("*** Zapisano ***")
    }
    
    func fetch() -> [ContentCD] {
        do {
            let fetched = try managedObjectContext.fetch(contentsFetch)
            return fetched
        } catch {
            fatalError("Błąd odczytu z Core Data")
        }
    }
    
}
