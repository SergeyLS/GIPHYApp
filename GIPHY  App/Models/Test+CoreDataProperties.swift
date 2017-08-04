//
//  Test+CoreDataProperties.swift
//  GIPHYApp
//
//  Created by Sergey Leskov on 7/17/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension Test {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Test> {
        return NSFetchRequest<Test>(entityName: "TestEnt")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
