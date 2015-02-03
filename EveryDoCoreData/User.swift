//
//  User.swift
//  EveryDoCoreData
//
//  Created by Michael Reining on 2/3/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var userName: String
    @NSManaged var userTask: NSSet

}
