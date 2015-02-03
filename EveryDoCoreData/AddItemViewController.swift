//
//  AddItemViewController.swift
//  EveryDoCoreData
//
//  Created by Michael Reining on 2/3/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var users = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDetailsTextField: UITextField!
    @IBOutlet weak var taskprioritySegmentedControl: UISegmentedControl!
    
    // Add new users to Core data
    @IBAction func addUserButtonPressed(sender: AnyObject) {
        // Get reference to app delegate and use it to get managedObjectContext
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: context!)
        let newUser = User(entity: entityDescription!, insertIntoManagedObjectContext: context)
        
        var alert = UIAlertController(title: "Add user", message: "Please add a user name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as UITextField
            newUser.userName = textField.text
            var error: NSError?
            
            context?.save(&error)
            self.tableView.reloadData()
            if let err = error {
                println(err.localizedFailureReason)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
            
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "User")
        var error: NSError?
        let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        if let results = fetchResults {
            users = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    // Save new task to CoreData
    
    override func viewWillDisappear(animated: Bool) {
        // Get reference to app delegate and use it to get managedObjectContext
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: context!)
        let task = Task(entity: entityDescription!, insertIntoManagedObjectContext: context)
        
        task.taskName = taskNameTextField.text
        task.taskDetail = taskDetailsTextField.text
        task.taskPriority = taskprioritySegmentedControl.selectedSegmentIndex

        var error: NSError?
        
        context?.save(&error)
        
        if let err = error {
            println(err.localizedFailureReason)
        } else {
            taskNameTextField.text = ""
        }
    }

    //MARK: table view data source methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as UITableViewCell
        let user = users[indexPath.row]
        let userName = user.valueForKey("userName") as String
        cell.textLabel?.text = userName
        return cell
    }

    
}
