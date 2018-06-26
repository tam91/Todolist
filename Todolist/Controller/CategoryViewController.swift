//
//  CategoryViewController.swift
//  Todolist
//
//  Created by Ka ka Tam on 26/06/2018.
//  Copyright © 2018 Ka ka Tam. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    //MARK: tabele view datasource method in order to display categories
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    //MARK: table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            print(categoryArray[indexPath.row].name!)
        }
    }
    
    
    //MARK: data manipulation methods in order to use CRUD
    func saveCategories(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        // fetch items
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }

    //MARK: add new category
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert =  UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            if textField.text != nil {
                
                let category = Category(context: self.context)
                category.name = textField.text!
                self.categoryArray.append(category)
                self.saveCategories()
            }
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
