//
//  ViewController.swift
//  Todolist
//
//  Created by Ka ka Tam on 12/06/2018.
//  Copyright © 2018 Ka ka Tam. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //searchBar.delegate = self

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] { //first check whether the item is not nil
            do {
                try realm.write{
                    item.done = !item.done
                    //realm.delete(item)
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert =  UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        let addAction = UIAlertAction(title: "Add item", style: .default) { (action) in
            if textField.text != nil {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let item = Item()
                            item.title = textField.text!
                            item.dateCreated = Date()
                            currentCategory.items.append(item)
                        }
                    } catch {
                        print("Error saving context \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (action) in
            
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
}

// MARK: Search Bar methods
extension TodoListViewController :  UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

