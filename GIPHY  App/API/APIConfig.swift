//
//  APIConfig.swift
//  GIPHY  App
//
//  Created by Sergey Leskov on 7/16/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation


class APIConfig {
    
    static var keyAPI = "e7c05f500af04f58ab41b68f3c4fe430"
    
    static var hostPath = "http://api.giphy.com"
    
    static var searchPath = "/v1/gifs/search?q=funny+cat"
    
    
    static func searchURL() -> URL {
        
        let keyAPI = "&api_key=".appending(APIConfig.keyAPI)
        return URL(string: hostPath.appending(searchPath).appending(keyAPI))!
    }

}
