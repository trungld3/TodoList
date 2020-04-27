//
//  ViewController.swift
//  TodoList
//
//  Created by TrungLD on 4/22/20.
//  Copyright © 2020 TrungLD. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController{
    
    
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
        // Do any additional setup after loading the view.
        //        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
    }
    // MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        print("cellForRowAt indexPath called")
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if  let item = todoItems?[indexPath.row] {
            
            
            cell.textLabel?.text = item.title
                    cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
               cell.textLabel?.text  = "No items added"
        }
        return cell
    }
    
    // MARK -TableView Delegates Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if let item = todoItems?[indexPath.row] {
           do {  try realm.write{
                item.done = !item.done
            }
            } catch {
                print("error update check \(error)")
            }
        }
        tableView.reloadData()
       
        tableView.deselectRow(at: indexPath, animated: true)
       //core data
        // print(itemArray[indexPath.row])
               //        context.delete(itemArray[indexPath.row])
               //        itemArray.remove(at: indexPath.row)
               //       todoItems[indexPath.row].done = !todoItems[indexPath.row].done
               //      saveItem()
    }
    
    @IBAction func btnPressAdd(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user click the add item on our UIAlert
            
            if let currentCategoy  = self.selectedCategory {
                do {
                    try self.realm.write {
                             let newItem = Item()
                              newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                              currentCategoy.items.append(newItem)
                          }
                } catch {
                     print("error save btnAdded \(error)")
                }
            }
         self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
 
        
    }
    
    // MARK - Model Manpulations Methods
    
    func loadItems () {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    func save(todoItems : Item) {
        do {
            try realm.write {
                realm.add(todoItems)
            }
        } catch {
            print ("save todoList error \(error)")
        }
        tableView.reloadData()
    }
    
    }
     // MARK - searchbar methods
    extension ToDoListViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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
