//
//  ViewController.swift
//  Todoey
//
//  Created by Tommy Krohn on 22.06.2018.
//  Copyright © 2018 Tommy Krohn. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mikey", "Buy eggos","Destroy deogorgons"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our IUAlert
            
            self.itemArray.append(textField.text!) // kan trygt force unwrap her siden et tekstfelt aldri vil være NIL, men tom string
            
            self.tableView.reloadData()
        }
        
        alert.addAction(alertAction)
        
        // completion block skjer nå tekstfeltet blir laget
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New Item"
        
            textField = alertTextfield
        }
        
        
        present(alert, animated: true, completion: nil)
        
            
    }

    
    
    
}

