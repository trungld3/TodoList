//
//  ViewController.swift
//  TodoList
//
//  Created by TrungLD on 4/22/20.
//  Copyright © 2020 TrungLD. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController{
    
    
    
    var itemArray =  [Item]()
     
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
   
     let context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    
    
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
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
   
        
      saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func btnPressAdd(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           // what will happen once the user click the add item on our UIAlert
           
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItem()
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
      
          do {
           try context.save()
          }
          catch {
            print("trung dep trai \(error)")
          }
        
        self.tableView.reloadData()
    }
    func loadItems ( with request : NSFetchRequest<Item> = Item.fetchRequest()) {
      
        do {
           itemArray =  try context.fetch(request)
        
        } catch {
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
}
    
}
// MARK - searchbar methods
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let  request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
         request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
      
       
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
