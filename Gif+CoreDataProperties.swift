//
//  Gif+CoreDataProperties.swift
//  GIPHY  App
//
//  Created by Sergey Leskov on 7/16/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension Gif {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gif> {
        return NSFetchRequest<Gif>(entityName: "Gif")
    }

    @NSManaged public var name: String?

}
