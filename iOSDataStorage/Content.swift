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
    let artworkImage: UIImage?
    let country: String
    let primaryGenreName: String
    
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
        
        guard let artworkImageString = json["artworkUrl60"].string else {
            return nil
        }
        
        self.artworkImage = UIImage(contentsOfFile: artworkImageString)
        
        guard let country = json["country"].string else {
            return nil
        }
        self.country = country
        
        guard let primaryGenreName = json["primaryGenreName"].string else {
            return nil
        }
        self.primaryGenreName = primaryGenreName
    }
}
