//
//  PersistanceOperation.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 26/01/17.
//  Copyright © 2017 Marcin Mucha. All rights reserved.
//

import Foundation
import RealmSwift

enum OperationType: String {
    case Read = "Odczyt"
    case Write = "Zapis"
    case Unspecfied = ""
}

enum StorageType: String {
    case CoreData = "Core Data"
    case Realm = "Realm"
    case Couchbase = "Couchbase Lite"
    case Unspecified = ""
}

class PersistanceOperation: Object {
    dynamic var duration: Int = 0
    dynamic var recordNumber: Int = 0
    dynamic var operation = OperationType.Unspecfied.rawValue
    var operationType: OperationType {
        get {
            return OperationType(rawValue: operation)!
        }
        set {
            operation = newValue.rawValue
        }
    }
    dynamic var storage = StorageType.Unspecified.rawValue
    var storageType: StorageType {
        get {
            return StorageType(rawValue: storage)!
        }
        set {
            storage = newValue.rawValue
        }
    }
    class func contruct(duration: Int, recordNumber: Int, operation: String, storage: String) -> PersistanceOperation {
        let persistanceOperation = PersistanceOperation()
        persistanceOperation.duration = duration
        persistanceOperation.recordNumber = recordNumber
        persistanceOperation.operation = operation
        persistanceOperation.storage = storage
        return persistanceOperation
    }
}
