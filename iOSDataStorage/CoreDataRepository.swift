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
    lazy var contents: [Content] = {
        let contentsCD = self.fetch()
        return contentsCD.map {
            Content(contentCD: $0)
        }
    }()
    let dataStorageName = "Core Data"
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    func save(contents: [Content]) {
        print("*** Rozpoczęto zapisywanie ***")
        let start = DispatchTime.now()
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
        let end = DispatchTime.now()
        let diff = end.uptimeNanoseconds - start.uptimeNanoseconds
        print("*** Zapis zakończony: \(diff)***")

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
