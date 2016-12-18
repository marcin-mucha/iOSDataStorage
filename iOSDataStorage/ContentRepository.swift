//
//  ContentRepository.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 06/11/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import Foundation

protocol ContentRepository {
    var contents: [Content] { get set }
    var dataStorageName: String { get }
    func save(contents: [Content])
    //func fetch() -> [Content]
    //func delete(contents: [Content])
    //func find(query: String) -> [Content]
}


