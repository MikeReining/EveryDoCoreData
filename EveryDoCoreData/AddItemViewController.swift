//
//  AddItemViewController.swift
//  EveryDoCoreData
//
//  Created by Michael Reining on 2/3/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController {
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext

    
    @IBOutlet weak var taskNameTextField: UITextField!
    
    override func viewDidLoad() {

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        // Get reference to app delegate and use it to get managedObjectContext
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: context!)
        let task = Task(entity: entityDescription!, insertIntoManagedObjectContext: context)
        
        task.taskName = taskNameTextField.text

        var error: NSError?
        
        context?.save(&error)
        
        if let err = error {
            println(err.localizedFailureReason)
        } else {
            taskNameTextField.text = ""
        }
        
    }
}
