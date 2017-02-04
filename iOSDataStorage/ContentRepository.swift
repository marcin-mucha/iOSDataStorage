//
//  ContentRepository.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 06/11/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import Foundation
import RealmSwift

protocol ContentRepository {
    var contents: [Content] { get }
    var dataStorageName: String { get }
    func save(contents: [Content])
    func deleteAll()
    func saveOperationDetails(duration: Int, recordNumber: Int,
                              operation: OperationType, storage: StorageType)

}

extension ContentRepository {
    func saveOperationDetails(duration: Int, recordNumber: Int, operation: OperationType, storage: StorageType) {
        let operation = PersistanceOperation.contruct(duration: duration, recordNumber: recordNumber, operation: operation.rawValue, storage: storage.rawValue)
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(operation)
        try! realm.commitWrite()
    }
}

