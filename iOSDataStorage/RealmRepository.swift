//
//  RealmRepository.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 22/11/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import Foundation
import RealmSwift

class RealmRepository: ContentRepository {
    var contents: [Content] {
        let start = DispatchTime.now()
        let realm = try! Realm()
        let contentsRealm = realm.objects(ContentRealm.self)
        let mappedContents: [Content] = contentsRealm.map {
            Content(contentRealm: $0)
        }
        let end = DispatchTime.now()
        let diff = end.uptimeNanoseconds - start.uptimeNanoseconds
        let miliSeconds = diff / 1000000
        print("*** Odczyt zakończony: \(miliSeconds)***")
        if mappedContents.count > 0 {
            saveOperationDetails(duration: Int(miliSeconds), recordNumber: mappedContents.count, operation: OperationType.Read, storage: StorageType.Realm)
            
        }
        return mappedContents
    }
    let dataStorageName = "Realm"
    func save(contents: [Content], completion: @escaping ()->()) {
        DispatchQueue(label: "Realm").async {
            print("*** Rozpoczęto zapisywanie ***")
            
            autoreleasepool {
                let start = DispatchTime.now()
                let realm = try! Realm()
                realm.beginWrite()
                for content in contents {
                    let contentObj = ContentRealm()
                    contentObj.kind = content.kind
                    contentObj.trackName = content.trackName
                    contentObj.artistName = content.artistName
                    contentObj.collectionName = content.collectionName
                    if let image = content.artworkImage {
                        contentObj.artworkImage = UIImagePNGRepresentation(image) as NSData?
                    } else {
                        contentObj.artworkImage = nil
                    }
                    contentObj.country = content.country
                    contentObj.primaryGenreName = content.primaryGenreName
                    contentObj.date = content.date
                    realm.add(contentObj)
                }
                try! realm.commitWrite()
                let end = DispatchTime.now()
                let diff = end.uptimeNanoseconds - start.uptimeNanoseconds
                let miliSeconds = diff / 1000000
                print("*** Zapis zakończony: \(miliSeconds) ms ***")
                print("*** Zapis zakończony: \(miliSeconds)***")
                if contents.count > 0 {
                    self.saveOperationDetails(duration: Int(miliSeconds), recordNumber: contents.count, operation: OperationType.Write, storage: StorageType.Realm)
                    
                }
                completion()
            }
            
        }
    }
    
    func deleteAll(completion: @escaping ()->()) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.delete(realm.objects(ContentRealm.self))
        try! realm.commitWrite()
        completion()
    }
}
