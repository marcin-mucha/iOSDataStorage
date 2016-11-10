//
//  ContentCD+CoreDataProperties.swift
//  
//
//  Created by Marcin Mucha on 10/11/16.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ContentCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContentCD> {
        return NSFetchRequest<ContentCD>(entityName: "ContentCD");
    }

    @NSManaged public var kind: String?
    @NSManaged public var trackName: String?
    @NSManaged public var artistName: String?
    @NSManaged public var collectionName: String?
    @NSManaged public var artworkImage: NSData?
    @NSManaged public var country: String?
    @NSManaged public var genreName: String?
    @NSManaged public var date: NSDate?

}
