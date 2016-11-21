//
//  NSManagedObjectContext+.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 12/11/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func safeSave() {
        do {
            try self.save()
        } catch {
            fatalCoreData(error: error)
        }
        
    }
}
