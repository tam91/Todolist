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
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    var categories : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        load()
        //print(Realm.Configuration.defaultConfiguration.fileURL)

    }

    //MARK: tabele view datasource method in order to display categories
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    //MARK: table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
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
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }

    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error saving delete action \(error)")
            }
        }
    }
    //MARK: add new category
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert =  UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        let addAction = UIAlertAction(title: "Add category", style: .default) { (action) in
//            print(textField.text!)
            if textField.text! != "" {
                
                let category = Category()
                category.name = textField.text!
             
                self.save(category)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (action) in
              
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}


