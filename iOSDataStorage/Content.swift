//
//  Content.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 05/11/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct Content {
    let kind: String
    let trackName: String
    let artistName: String
    let collectionName: String?
    var artworkImage: UIImage? = nil
    let country: String
    let primaryGenreName: String
    let date: Date
    var imageURL: URL? = nil
    
    init(contentCD: ContentCD) {
        guard let kind = contentCD.kind,
            let trackName = contentCD.trackName,
            let artistName = contentCD.artistName,
            let country = contentCD.country,
            let primaryGenreName = contentCD.genreName,
            let date = contentCD.date as? Date else {
                fatalError()
        }
        self.kind = kind
        self.trackName = trackName
        self.artistName = artistName
        self.collectionName = artistName
        if let imageData = contentCD.artworkImage as? Data {
            self.artworkImage = UIImage(data: imageData)
        } else {
            self.artworkImage = nil
        }
        self.country = country
        self.primaryGenreName = primaryGenreName
        self.date = date
    }
    
    init(contentRealm: ContentRealm) {
        self.kind = contentRealm.kind
        self.trackName = contentRealm.trackName
        self.artistName = contentRealm.artistName
        self.collectionName = contentRealm.collectionName
        if let imageData = contentRealm.artworkImage as? Data {
            self.artworkImage = UIImage(data: imageData)
        } else {
            self.artworkImage = nil
        }
        
        self.country = contentRealm.country
        self.primaryGenreName = contentRealm.primaryGenreName
        self.date = contentRealm.date
    }
    
    init?(json: JSON) {
        guard let kind = json["kind"].string else {
            return nil
        }
        self.kind = kind
        
        guard let trackName = json["trackName"].string else {
            return nil
        }
        self.trackName = trackName
        
        guard let artistName = json["artistName"].string else {
            return nil
        }
        self.artistName = artistName
    
        
        self.collectionName = json["collectionName"].string
        
        let artworkImageString = json["artworkUrl60"].string ?? ""
        
        self.imageURL = URL(string: artworkImageString)
        
        guard let country = json["country"].string else {
            return nil
        }
        self.country = country
        
        guard let primaryGenreName = json["primaryGenreName"].string else {
            return nil
        }
        self.primaryGenreName = primaryGenreName
        self.date = Date()
    }
    
    init?(properties: [String: Any]?) {
        guard let kind = properties?["kind"] as? String else {
            return nil
        }
        self.kind = kind
        
        guard let trackName = properties?["trackName"] as? String else {
            return nil
        }
        self.trackName = trackName
        
        guard let artistName = properties?["artistName"] as? String else {
            return nil
        }
        self.artistName = artistName
        
        self.collectionName = properties?["collectionName"] as? String
        
        guard let country = properties?["country"] as? String else {
            return nil
        }
        self.country = country
        
        guard let primaryGenreName = properties?["primaryGenreName"] as? String else {
            return nil
        }
        self.primaryGenreName = primaryGenreName
        guard let dateString = properties?["date"] as? String else {
            return nil
        }
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        self.date = date
        self.artworkImage = nil
    }
    
}

let dateFormatter = DateFormatter()
