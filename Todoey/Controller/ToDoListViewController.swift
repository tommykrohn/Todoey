//
//  ViewController.swift
//  Todoey
//
//  Created by Tommy Krohn on 22.06.2018.
//  Copyright © 2018 Tommy Krohn. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try!Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 0
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        if let item = todoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
            
            //Ternary operator ==>
            //value = conition ? valueiftrue : valueiffalse
            cell .accessoryType = item.done ? .checkmark : .none
        }
        else {
            
            cell.textLabel?.text = "No items added"
        }
        
        return cell
        
    }
    
    
    //MARK: - TABLEVIEW DELEGATE METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            } catch {
                print("Error updating item")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our IUAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    
                    currentCategory.items.append(newItem)
                }

                } catch {
                    print("Error saring new items")
                }
            
                self.loadItems()
            }
            
            
        }
        
        alert.addAction(alertAction)
        
        // completion block skjer nå tekstfeltet blir laget
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New Item"
        
            textField = alertTextfield
        }
        
        present(alert, animated: true, completion: nil)
        
    }

    //MARK: - CORE DATA HANDLING
    

    
    func loadItems() { // = Item:Fetchrequest er default verdi. hent alt når ingen parametre er gitt

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        

        self.tableView.reloadData()
    }
    
    
}

//MARK: - SEARCHBAR METHODS

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    // når bruker krysser ut teksten
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

    
    
    
    


