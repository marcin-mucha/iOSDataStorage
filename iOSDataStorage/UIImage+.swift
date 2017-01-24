//
//  UIImage+.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 24/01/17.
//  Copyright © 2017 Marcin Mucha. All rights reserved.
//

import Foundation
//
//extension UIImage {
//    func downloadedFrom(url: URL) {
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { () -> Void in
//                self = image
//            }
//            }.resume()
//    }
//    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloadedFrom(url: url)
//    }
//}
