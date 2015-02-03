//
//  DetailViewController.swift
//  EveryDoCoreData
//
//  Created by Michael Reining on 2/3/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDetailsLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!



    var task: Task!
    
    
    func configureView() {
        taskNameLabel.text = task.taskName
        taskDetailsLabel.text = task.taskDetail
        taskPriorityLabel.text = setPriorityLabel(task)
    }

    func setPriorityLabel(task: Task) -> String {
        switch task.taskPriority {
        case 0:
            return "⭐️"
        case 1:
            return "⭐️⭐️"
        case 2:
            return "⭐️⭐️⭐️"
        default:
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

