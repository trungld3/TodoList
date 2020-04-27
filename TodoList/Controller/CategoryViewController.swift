//
//  CategoryViewController.swift
//  TodoList
//
//  Created by TrungLD on 4/25/20.
//  Copyright © 2020 TrungLD. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm  = try! Realm()

    var categories : Results<Category>?
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
   loadCategories()
      
    }



    
    
    @IBAction func IBActionfunc_senderUIBarButtonItemaddBtnPressed(_ sender: UIBarButtonItem) {
        
    }
    //MARK - tableview DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
       cell.textLabel?.text  = categories?[indexPath.row].name ?? "No Categories added yet"
        return cell
    }
    
     //MARK - TableView Delegates Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionationVC = segue.destination as! ToDoListViewController
        
        if let indexPatch = tableView.indexPathForSelectedRow {
            destionationVC.selectedCategory  = categories?[indexPatch.row]
        }
    }
    //MARK - TableView Delegates Methods
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        categories[indexPath.row].done != categories[indexPath.row].done
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    //MARK - Data Muniputions Methods
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("error save category\(error)")
        }
        tableView.reloadData()
    }
    func  loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK - Add new Categories
    @IBAction func AddBtnPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
         
            let newCategory = Category()
            
            newCategory.name  = textField.text!
            
            
          
            self.save(category : newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = " Add a new Categories"
            
        }
        present(alert, animated: true, completion: nil)
    }
    
}
