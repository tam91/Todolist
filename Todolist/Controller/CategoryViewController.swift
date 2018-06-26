//
//  CategoryViewController.swift
//  Todolist
//
//  Created by Ka ka Tam on 26/06/2018.
//  Copyright © 2018 Ka ka Tam. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var categoryArray : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
//        print(Realm.Configuration.defaultConfiguration.fileURL)

    }

    //MARK: tabele view datasource method in order to display categories
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    //MARK: table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            //print(categoryArray[indexPath.row].name!)
        }
    }
    
    
    //MARK: data manipulation methods in order to use CRUD
    func save(_ category: Category){
        do {
            try realm.write {
                 realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func load() {
        
        categoryArray = realm.objects(Category.self)

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
                
                let category = Category()
                category.name = textField.text!
             
                self.save(category)
            }
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
