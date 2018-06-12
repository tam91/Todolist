//
//  ViewController.swift
//  Todolist
//
//  Created by Ka ka Tam on 12/06/2018.
//  Copyright © 2018 Ka ka Tam. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["unit testen", "code review" , "deploy"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
       
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert =  UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if textField.text != nil {
                self.itemArray.append(textField.text!)
                self.tableView.reloadData()
            }
           
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
    
}

