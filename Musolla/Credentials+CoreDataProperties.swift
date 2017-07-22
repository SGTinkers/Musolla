//
//  Credentials+CoreDataProperties.swift
//  Musolla
//
//  Created by Muhd Mirza on 22/7/17.
//  Copyright © 2017 msociety. All rights reserved.
//

import Foundation
import CoreData


extension Credentials {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Credentials> {
        return NSFetchRequest<Credentials>(entityName: "Credentials")
    }

    @NSManaged public var accessToken: String?

}
