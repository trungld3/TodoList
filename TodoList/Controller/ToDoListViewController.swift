//
//  ViewController.swift
//  TodoList
//
//  Created by TrungLD on 4/22/20.
//  Copyright © 2020 TrungLD. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    
    
    var itemArray =  [Item]()
    let dataFilePatch = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePatch)
       
        let newItem = Item()
       
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem1 = Item()
               newItem1.title = "Find Mike1"
               itemArray.append(newItem1)
        
        let newItem2 = Item()
               newItem2.title = "Find Mike2"
               itemArray.append(newItem2)
        
        let newItem3 = Item()
               newItem3.title = "Find Mike3"
               itemArray.append(newItem3)
        
       
        
        
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }
    // MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("cellForRowAt indexPath called")
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
       
        return cell
     }
    
    // MARK -TableView Delegates Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
//        if   tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//              tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
      self.saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func btnPressAdd(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           // what will happen once the user click the add item on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
          //  self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
          
        }
       
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK - Model Manpulations Methods
    func saveItem (){
        let encoder1 = PropertyListEncoder()
          do {
              let data  = try encoder1.encode(itemArray)
              try data.write(to: dataFilePatch!)
          }
          catch {
          print("error: \(error)")
          }
        
          
        
          self.tableView.reloadData()
    }
}

