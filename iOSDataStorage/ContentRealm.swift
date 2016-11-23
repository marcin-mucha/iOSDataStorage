//
//  ContentRealm.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 23/11/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import Foundation
import RealmSwift


class ContentRealm: Object {
    dynamic var kind: String = ""
    dynamic var trackName: String = ""
    dynamic var artistName: String = ""
    dynamic var collectionName: String?
    dynamic var artworkImage: NSData?
    dynamic var country: String = ""
    dynamic var primaryGenreName: String = ""
    dynamic var date: Date = Date()
}
