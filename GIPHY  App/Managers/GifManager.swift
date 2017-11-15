//
//  GifManager.swift
//  GIPHY  App
//
//  Created by Sergey Leskov on 7/17/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class GifManager {
    
    static func getGifByID(id: String) -> Gif? {
        
        if  id == "" { return nil }
        
        let request = NSFetchRequest<Gif>(entityName: Gif.type)
        let predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        request.predicate = predicate
        
        let resultsArray = (try? CoreDataManager.shared.viewContext.fetch(request))
        
        return resultsArray?.first ?? nil
    }
    
    
    static func getFromAPI(completion: @escaping () -> Void) {
        NetworkManager.getFromAPI() { result in
            switch result {
            case .success(let resultDict):
//                let moc = CoreDataManager.shared.newBackgroundContext
//                moc.performAndWait{
                    for  element in resultDict {
                        guard
                            let id = element["id"] as? String
                            else {
                                print("error - no id")
                                continue
                        }
                        
                        
                        if let _ = getGifByID(id: id )  {
                            //update
                            
                        } else {
                            // New
                            
                            
                            guard let _ = Gif(dictionary: element as NSDictionary, moc: CoreDataManager.shared.viewContext)   else {
                                print("Error: Could not create a new Gif from API.")
                                continue
                            }
                            
                        } //else
                        
                    } //for  element in popularDict
                    
                    CoreDataManager.shared.saveContext()
                    completion()
                //}
                
            case .failure(_):
                completion()
            }
        }
    }
    
    
    
    static func getGifDataSmall(gif: Gif, completion: @escaping (_ dataGif: Data) -> Void)  {
        
        if let fotoGif = gif.dataGifSmall  {
             completion(fotoGif)
        } else {
            if let path = gif.pathSmall,
                let url = URL(string: path)
            {
                NetworkManager.getDataFromUrl(url: url) { (data, response, error)  in
                    guard let data = data,
                        error == nil else { return }
                    
                    DispatchQueue.main.async() { () -> Void in
                        
                        gif.dataGifSmall = data
                        CoreDataManager.shared.saveContext()
                        
                        completion(data)
                    }
                    
                }
            }
        }
        
    } //func getDataGif
    
    
    
    static func getGifDataOriginal(gif: Gif?, completion: @escaping (_ dataGif: Data) -> Void)  {

        guard let gif = gif else {
            completion(Data())
            return
        }
        
        if let fotoGif = gif.dataGifOriginal
        {
            completion(fotoGif)
        } else {
            if let path = gif.pathOriginal,
                let url = URL(string: path)
            {
                NetworkManager.getDataFromUrl(url: url) { (data, response, error)  in
                    guard let data = data,
                        error == nil else { return }
                    
                    DispatchQueue.main.async() { () -> Void in
                        
                        gif.dataGifOriginal = data
                        CoreDataManager.shared.saveContext()
                        
                        completion(data)
                    }
                    
                }
            }
        }
        
    } //func getDataGif

    
    
}
