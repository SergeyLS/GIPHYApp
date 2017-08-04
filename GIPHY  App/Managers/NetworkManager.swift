//
//  NetworkManager.swift
//  Omelette
//
//  Created by Sergey Leskov on 3/23/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error?)
}

class NetworkManager {
    
    static func getFromAPI(completion: @escaping (Result<[[String : AnyObject]]>) -> Void) {
        
        let url = APIConfig.searchURL()
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                completion(Result.failure(error!))
            }
        
            
            guard let data = data else {
                print("Error: [NetworkManager] - getFromAPI, data = nil")
                return completion(Result.failure(error))}
             guard let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                print("Error: [NetworkManager] - getFromAPI, dataDictionary = nil")
                return completion(Result.failure(error))}
            guard let rezultAPI = dataDictionary?["data"] as? [[String : AnyObject]] else {
                print("Error: [NetworkManager] - getFromAPI, dataDictionary = rezultAPI")
                return completion(Result.failure(error))}
            
            
            completion(Result.success(rezultAPI))
            
            
        }
        task.resume()
        
    }
    
    
    static func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
}
