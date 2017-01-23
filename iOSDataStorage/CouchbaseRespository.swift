//
//  CouchbaseRespository.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 23/01/17.
//  Copyright © 2017 Marcin Mucha. All rights reserved.
//

import Foundation

let dbManager = CBLManager.sharedInstance()

class CouchbaseRepository: ContentRepository {
    
    let dataStorageName = "Couchbase Lite"
    lazy var contents: [Content] = {
        let query = self.database?.createAllDocumentsQuery()
        do {
            guard let results: CBLQueryEnumerator = try query?.run() else {
                return []
            }
            return (UInt(0)..<results.count).flatMap {
                let document = results.row(at: $0).document
                let properties = document?.properties
                return Content(properties: properties)
            }
        } catch {
            print("*** Error runing query")
        }
        return []
    }()
    
    var documents: [CBLDocument] {
        let query = self.database?.createAllDocumentsQuery()
        do {
            guard let results: CBLQueryEnumerator = try query?.run() else {
                return []
            }
            return (UInt(0)..<results.count).flatMap {
                return results.row(at: $0).document
            }
        } catch {
            print("*** Error runing query")
            return []
        }

    }

    var database: CBLDatabase!
    init() {
        configureDatabase()
    }
    func save(contents: [Content]) {
        for content in contents {
            let properties = [
                "kind": content.kind,
                "trackName": content.trackName,
                "artistName": content.artistName,
                "colletionName": content.collectionName,
                "country": content.country,
                "primaryGenreName": content.primaryGenreName,
                "date": dateFormatter.string(from: content.date)
            ]
            let document = database.createDocument()
            do {
                try document.putProperties(properties)
            } catch {
                print("*** Error puting properties")
            }
            addPhotoAttachment(document: document, image: content.artworkImage)
        }
    }
    
    func deleteAll() {
        database.delet
    }
    
    
    func configureDatabase() {
        do {
            database = try dbManager.databaseNamed("my-database")
        } catch {
            print("*** COUCHBASE: DATABASE NOT EXSISTING")
        }
    }
    
    func addPhotoAttachment(document: CBLDocument?, image: UIImage?) {
        guard let image = image, let document = document else {
            return
        }
        let newRev = document.currentRevision?.createRevision()
        let imageData = UIImageJPEGRepresentation(image, 0.75)
        newRev?.setAttachmentNamed("photo", withContentType: "image/jpeg", content: imageData)
        do {
            try newRev?.save()
        } catch {
            print("*** Photo save error")
        }
    }
}
