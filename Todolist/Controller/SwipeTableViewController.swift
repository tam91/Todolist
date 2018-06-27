//
//  SwipeTableViewController.swift
//  Todolist
//
//  Created by Ka ka Tam on 27/06/2018.
//  Copyright © 2018 Ka ka Tam. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
//            
            self.updateModel(at: indexPath)
            print("delete cell")
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "DeleteIcon")
        
        return [deleteAction]
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }

}
