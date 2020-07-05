//
//  SwipeTableViewController.swift
//  Punjab
//
//  Created by PARMJIT SINGH KHATTRA on 5/7/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UIViewController, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    

    var cell : UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.updateModel(at: indexPath)

            
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "trash-circle")

            return [deleteAction]
        }
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            //options.transitionStyle = .border
            return options
        }
    func updateModel(at indexPath: IndexPath){
        
    }
        
    }
