//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Tommy Krohn on 25.06.2018.
//  Copyright © 2018 Tommy Krohn. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm() //ikke feil å kjøre try! her siden den er kjørt en gang før i appdelegate
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
        
        loadCategories()
    }


    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = categoryTextField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addAction(alertAction)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            categoryTextField = alertTextField
        }
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TAbleview datasorce methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 // Nil Coalescing Operator. om en optional verdi er nil så returner 1
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet..."

        return cell
        
        
    }
    
    //MARK: - Data manipulation methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    
    override func updateModell(at indexpath: IndexPath) {
       
        super.updateModell(at: indexpath)  // for å se at super.updateModell i CategoryViewcontroller overrider denne
        
        if let categoryForDeletion = self.categories?[indexpath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting Category")
            }
        }
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
       //tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" { // om flere views fra samme
            let destinationVC = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    
    
}




