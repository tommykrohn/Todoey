//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Tommy Krohn on 27.06.2018.
//  Copyright © 2018 Tommy Krohn. All rights reserved.
//

import UIKit
import SwipeCellKit

/// Superclass of UITableViewController for Swipable TableViewCell
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    //TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        
        cell.delegate = self
        

        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModell(at: indexPath) // når denne kalles her, men er ovveridet i childViewcontroller så kjøres den der herfra
            

            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete_icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func updateModell(at indexpath: IndexPath) {
        // Update our datamodell
        
        print("delete row")
    }
    
    
}





