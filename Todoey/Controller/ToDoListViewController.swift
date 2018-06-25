//
//  ViewController.swift
//  Todoey
//
//  Created by Tommy Krohn on 22.06.2018.
//  Copyright © 2018 Tommy Krohn. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let CONTEXT = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        //value = conition ? valueiftrue : valueiffalse
        cell .accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    
    //MARK: - TABLEVIEW DELEGATE METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        CONTEXT.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
  
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our IUAlert
            
            
            let newItem = Item(context: self.CONTEXT)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
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
    
    func saveItems() {
     
        do {
            try CONTEXT.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
        
    }
    
    /// Loading data with NSFetshRequest and updating tableView. with Predicate
    ///
    /// - Parameters:
    ///     - request: Item.fetchrequest(). Can be nil, default value ALL
    ///     - predicate: NSPredicate (optional). Default Nil
    ///
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { // = Item:Fetchrequest er default verdi. hent alt når ingen parametre er gitt
        
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = predicate
        }
        
        do {
            itemArray = try CONTEXT.fetch(request)
        } catch  {
            
        }

        self.tableView.reloadData()
    }
    
    
}

//MARK: - SEARCHBAR METHODS

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // forventer array av sortdescripor, men siden det kun er 1 så settes denne i []
        
        loadItems(with: request, predicate: predicate)
        
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
    
    
    
    
    


