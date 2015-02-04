//
//  AddItemViewController.swift
//  EveryDoCoreData
//
//  Created by Michael Reining on 2/3/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var users = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDetailsTextField: UITextField!
    @IBOutlet weak var taskprioritySegmentedControl: UISegmentedControl!
    var selectedUser: User?
    var lastSelectedIndexPath: NSIndexPath?
    
    //MARK: Add user AlertAction
    @IBAction func addUserButtonPressed(sender: AnyObject) {
        var alert = UIAlertController(title: "Add user", message: "Please add a user name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) -> Void in
            let entityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: self.context!)
            let contact = User(entity: entityDescription!, insertIntoManagedObjectContext: self.context)

            let textField = alert.textFields![0] as UITextField
            contact.userName = textField.text
            let managedObjectContext = contact.managedObjectContext!
            
            // save `NSManagedObjectContext`
            var e: NSError?
            if !managedObjectContext.save(&e) {
                println("finish error: \(e!.localizedDescription)")
                abort()
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
    
    //MARK: ViewController Functions
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
        if taskNameTextField.text != "" {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let context = appDelegate.managedObjectContext
            let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: context!)
            let task = Task(entity: entityDescription!, insertIntoManagedObjectContext: context)
            task.taskName = taskNameTextField.text
            task.taskDetail = taskDetailsTextField.text
            task.taskPriority = taskprioritySegmentedControl.selectedSegmentIndex
            if selectedUser != nil {
                task.userRel = selectedUser!
            } else {
                task.userRel = nil
            }

            var error: NSError?
            
            context?.save(&error)
            
            if let err = error {
                println(err.localizedFailureReason)
            } else {
                taskNameTextField.text = ""
            }
        }
    }

    //MARK: Table view data source
    
    // ask the `NSFetchedResultsController` for the section
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int {
            let info = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
            return info.numberOfObjects
    }
    
    // create and configure each `UITableViewCell`
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as UITableViewCell
            self.configureCell(cell, atIndexPath: indexPath)
            cell.accessoryType = (lastSelectedIndexPath?.row == indexPath.row) ? .Checkmark : .None
            return cell
    }
    
    /* helper method to configure a `UITableViewCell`
    ask `NSFetchedResultsController` for the model */
    func configureCell(cell: UITableViewCell,
        atIndexPath indexPath: NSIndexPath) {
            let user = self.fetchedResultsController.objectAtIndexPath(indexPath) as User
            cell.textLabel?.text = user.userName
            
    }
    
    //MARK: Table View Swipe to Delete
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as User)
            
            var error: NSError? = nil
            if !context.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.fetchedResultsController.objectAtIndexPath(indexPath) as User
        selectedUser = nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.fetchedResultsController.objectAtIndexPath(indexPath) as User
        selectedUser = user
        if indexPath.row != lastSelectedIndexPath?.row {
            if let lastSelectedIndexPath = lastSelectedIndexPath {
                let oldCell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath)
                oldCell?.accessoryType = .None
            }
            
            let newCell = tableView.cellForRowAtIndexPath(indexPath)
            newCell?.accessoryType = .Checkmark
            
            lastSelectedIndexPath = indexPath
        }
        
    }
    
    //MARK: NSFetchResultsControllerDelegate
    
    /* `NSFetchedResultsController`
    lazily initialized
    fetches the displayed domain model */
    var fetchedResultsController: NSFetchedResultsController {
        // return if already initialized
        if self._fetchedResultsController != nil {
            return self._fetchedResultsController!
        }
        let managedObjectContext = self.context!
        
        /* `NSFetchRequest` config
        fetch all `Item`s
        order them alphabetically by name
        at least one sort order _is_ required */
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "userName", ascending: true)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        
        /* NSFetchedResultsController initialization
        a `nil` `sectionNameKeyPath` generates a single section */
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        self._fetchedResultsController = aFetchedResultsController
        
        // perform initial model fetch
        var e: NSError?
        if !self._fetchedResultsController!.performFetch(&e) {
            println("fetch error: \(e!.localizedDescription)")
            abort();
        }
        
        return self._fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController?
    
    //MARK: fetched results controller delegate
    
    /* called first
    begins update to `UITableView`
    ensures all updates are animated simultaneously */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    /* called:
    - when a new model is created
    - when an existing model is updated
    - when an existing model is deleted */
    func controller(controller: NSFetchedResultsController,
        didChangeObject object: AnyObject,
        atIndexPath indexPath: NSIndexPath,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath) {
            switch type {
            case .Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Update:
                let cell = self.tableView.cellForRowAtIndexPath(indexPath)
                self.configureCell(cell!, atIndexPath: indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }
    
    /* called last
    tells `UITableView` updates are complete */
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    

}
