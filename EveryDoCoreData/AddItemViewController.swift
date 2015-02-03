//
//  AddItemViewController.swift
//  EveryDoCoreData
//
//  Created by Michael Reining on 2/3/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    @IBOutlet weak var taskNameTextField: UITextField!
    
    override func viewWillDisappear(animated: Bool) {
        // Get reference to app delegate and use it to get managedObjectContext
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        
        
    }
}
