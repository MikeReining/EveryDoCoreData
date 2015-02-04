//
//  Task.swift
//  EveryDoCoreData
//
//  Created by Michael Reining on 2/3/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {

    @NSManaged var taskName: String
    @NSManaged var taskDetail: String
    @NSManaged var taskPriority: NSNumber
    @NSManaged var dueDate: NSDate
    @NSManaged var userRel: User

}
