//
//  APIClient.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 03/11/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import Foundation
import SwiftyJSON

enum APIClientError: Error {
    case wrongURL
    case dataTaskError
    case responseError
    case httpStatusError
    case deserializeJSONError
    case mappingError
}

class APIClient {
    let session: URLSession
    let baseURL: URL?
    
    init(withSession session: URLSession = URLSession(configuration: URLSessionConfiguration.default), basePath: String = "https://itunes.apple.com/" ) {
        self.session = session
        self.baseURL = URL(string: basePath)
    }
    
    func getContent(for query: String, limit: Int, completion: @escaping ([Content]?, Error?) -> ()) {
        guard let url = URL(string: "search?term=\(query)&limit=\(limit)", relativeTo: baseURL) else {
            completion(nil, APIClientError.wrongURL)
            return
        }
        session.dataTask(with: url) {
            [weak self] data, response, error in
            if error != nil {
                completion(nil, APIClientError.dataTaskError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, APIClientError.responseError)
                return
            }
            
            if httpResponse.statusCode == 200 {
                guard let contents = self?.mapToContents(data: data) else {
                    completion(nil, APIClientError.mappingError)
                    return
                }
                completion(contents, nil)
            } else {
                completion(nil, APIClientError.httpStatusError)
            }
        }.resume()
     
        
        
    }
    
    private func deserializeJSON(from data: Data?) -> JSON? {
        guard let data = data else {
            return nil
        }
        do {
            let nsJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return JSON(nsJson)
        } catch {
            return nil
        }
    }
    
    private func mapToContents(data: Data?) -> [Content]? {
        guard let data = data else {
            return nil
        }
        var contents = [Content]()
        guard let json = self.deserializeJSON(from: data) else {
            return nil
        }
        guard let jsonContentArray = json["results"].array else {
            return nil
        }
        for contentJSON in jsonContentArray {
            guard let content = Content(json: contentJSON) else {
                return nil
            }
            contents.append(content)
        }
        return contents

    }
    
    func downloadPhotoFrom(url: URL, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    completion(nil)
                    return
            }
            completion(image)
            return
            }.resume()
    }

    
}
