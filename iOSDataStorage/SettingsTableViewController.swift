//
//  TableViewController.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 28/01/17.
//  Copyright © 2017 Marcin Mucha. All rights reserved.
//

import UIKit
let notificationName = Notification.Name("storage")
class SettingsTableViewController: UITableViewController {

    var storages = [StorageType.CoreData, StorageType.Realm, StorageType.Couchbase]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in 0..<3 {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! StorageCell
            cell.accessoryType = .none
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? StorageCell else {
            return
        }
        UserDefaults.standard.set(storages[indexPath.row].rawValue, forKey: "storage")
        notify(storageType: storages[indexPath.row])
        cell.accessoryType = .checkmark
        
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorageCell", for: indexPath) as? StorageCell else {
            return UITableViewCell()
        }
        let storageName = storages[indexPath.row].rawValue
        guard let storageNameFromUserDefaults = UserDefaults.standard.string(forKey: "storage") else {
            return UITableViewCell()
        }
        if storageName == storageNameFromUserDefaults {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.storageNameLabel.text = storageName
        return cell
    }
 
    fileprivate func notify(storageType: StorageType) {
        var repository: ContentRepository
            switch storageType {
            case .CoreData:
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedObjectContext = appDelegate.managedObjectContext
                repository = CoreDataRepository(managedObjectContext: managedObjectContext)
            case .Realm:
                repository = RealmRepository()
            case .Couchbase:
                repository = CouchbaseRepository()
            default:
                return
        }
        NotificationCenter.default.post(name: notificationName, object: self, userInfo: ["storage": repository])
    }
}
