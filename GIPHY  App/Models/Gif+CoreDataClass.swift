//
//  Gif+CoreDataClass.swift
//  GIPHY  App
//
//  Created by Sergey Leskov on 7/16/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData

public class Gif: NSManagedObject {

    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Gif"
    
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    convenience init?(dictionary: NSDictionary){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Gif.type, in: CoreDataManager.shared.viewContext) else {
            fatalError("Could not initialize \(Gif.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: CoreDataManager.shared.viewContext)
        
        guard let id = dictionary["id"] as? String,
              let type = dictionary["type"] as? String
              else {
                return nil
        }
        
        
        self.id = id
        self.type = type
        
        //name 
         if  let slug = dictionary["slug"] as? String {
            var newString = slug.replacingOccurrences(of: "-"+id, with: "", options: .literal, range: nil)
            newString = newString.replacingOccurrences(of: "-", with: ", ", options: .literal, range: nil)
            self.name = newString
        } else {
            print("Error: [Gif] - pathSmall ")
        }
        
        
        //small
        if  let images = dictionary["images"] as? [String : Any],
            let fixed_height_small = images["fixed_height_small"] as? [String : Any],
            let urlString = fixed_height_small["url"] as? String {
            
            self.pathSmall = urlString
            
        } else {
            print("Error: [Gif] - pathSmall ")
        }
        
        //original
        if  let images = dictionary["images"] as? [String : Any],
            let original = images["original"] as? [String : Any],
            let urlString = original["url"] as? String {
            
            self.pathOriginal = urlString
            
        } else {
            print("Error: [Gif] - pathOriginal ")
        }

        
        print("add \(Gif.type): " + id)
    }

    
}
