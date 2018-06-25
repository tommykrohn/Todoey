//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Tommy Krohn on 25.06.2018.
//  Copyright © 2018 Tommy Krohn. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let CONTEXT = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }


    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.CONTEXT)
            newCategory.name = categoryTextField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
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
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
        
        cell.textLabel?.text = categoryArray[indexPath.row].name

        return cell
        
        
    }
    
    //MARK: - Data manipulation methods
    
    func saveCategories() {
        do {
            try CONTEXT.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try CONTEXT.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
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
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
