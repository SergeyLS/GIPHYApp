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
    
    class func entity(dictionary: NSDictionary, context: NSManagedObjectContext) -> Gif? {
        guard let name = dictionary["name"] as? String
            else {
                return nil
        }
        let resultEntity = Gif(context: context)
        
        resultEntity.name = name
        
        print("add \(type): " + name)
        
        return resultEntity;
    }

    
}
