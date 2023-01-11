//
//  GroceryViewController.swift
//  Family Grocery - Belt Exam
//
//  Created by Aamer Essa on 08/01/2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

class GroceryViewController: UIViewController {
    
    //MARK: Connections
    @IBOutlet weak var addItemBtn: UIBarButtonItem!
    @IBOutlet weak var griceriesTable: UITableView!
    
    //MARK: Vars
    var userID = String()
    var groceries = [NSDictionary]()
    var userEmail = String()
    var completedGroceries = [NSDictionary]()
    var groceriesType = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        griceriesTable.delegate = self
        griceriesTable.dataSource = self
        
        observeGrocery()
    }
    
    
    
    // MARK: - Action
    
    @IBAction func showAddNewItemForm(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: "Please enter the name of the item", preferredStyle: .alert)
            alert.addTextField { itemNameField in
            itemNameField.placeholder = "bread,banana, etc" }
        
            alert.addAction(UIAlertAction(title: "Add", style: .default,handler: { handler in
                
            let nameTextField = alert.textFields![0] as UITextField
            
            if let itemName = nameTextField.text {
                if itemName != ""{
                    self.addNewItem(itemName: itemName)
                }
            }
        }))
        
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        
    }// showAddNewItemForm()
    
    @IBAction func groceriesType(_ sender: UISegmentedControl) {
        
        groceriesType = sender.selectedSegmentIndex
        griceriesTable.reloadData()
        
        if sender.selectedSegmentIndex == 1 {
            addItemBtn.isHidden = true
        } else {
            addItemBtn.isHidden = false
        }
    } // groceriesType
    
    // MARK: - functionality
    
    func addNewItem(itemName:String){
        
        let groceryID = UUID()
        let dbRef : DatabaseReference!
            dbRef = Database.database().reference().child("Grocery").child("\(groceryID)")
            dbRef.setValue(["id":"\(groceryID)","name":itemName,"creatorEmail":" Created By \(userEmail)","completed":false])
    }
    
    func editItem(itemName:String,itemID:String){
        
        let dbRef : DatabaseReference!
            dbRef = Database.database().reference().child("Grocery").child("\(itemID)")
            dbRef.updateChildValues(["name":itemName,"creatorEmail":"Modified by \(userEmail)"])
    }
    
    func observeGrocery(){
        
        let dbRef : DatabaseReference!
            dbRef = Database.database().reference().child("Grocery")
            dbRef.observe(.value) { snapShot , err in
           
                self.groceries.removeAll()
                self.completedGroceries.removeAll()
                    if let groceries = snapShot.value as? NSDictionary {
                        for grocery in groceries {
                                let item = grocery.value as! NSDictionary
                                if item["completed"] as! Bool {
                                self.completedGroceries.append(item)
                                } else {
                                    self.groceries.append(item)
                                }
                            }
                        self.griceriesTable.reloadData()
                    } else{
                        self.griceriesTable.reloadData()
                    }
                }
            }
    }

extension GroceryViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if groceriesType == 0 {
            return groceries.count
            
        } else {
            return completedGroceries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = griceriesTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroceriesTableCell
        
        if groceriesType == 0 {
        
            cell.itemCreator.text = groceries[indexPath.row]["creatorEmail"] as? String
            cell.itemName.text = groceries[indexPath.row]["name"] as? String
            
        } else {
            
            cell.itemCreator.text = completedGroceries[indexPath.row]["creatorEmail"] as? String
            cell.itemName.text = completedGroceries[indexPath.row]["name"] as? String
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // MARK: Delete item
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            
            // delete from database
            let childID = self.groceriesType == 0 ? self.groceries[indexPath.row]["id"] as! String : self.completedGroceries[indexPath.row]["id"] as! String
            var dbRef: DatabaseReference!
                dbRef = Database.database().reference().child("Grocery").child("\(childID)")
                dbRef.removeValue(){err,ref in
                    if err != nil {
                    print("error")
                    } else {
                        self.observeGrocery()
                    }
                }
            
                completionHandler(true)
            }
        
        // MARK: Update item
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { action, view, completionHandler in
            
            // show the alert

            let alert = UIAlertController(title: "Edit Item", message: "Please enter the name of the item", preferredStyle: .alert)

                alert.addTextField { groceryNameField in
                    groceryNameField.placeholder = "bread,banana, etc"
                    groceryNameField.text = self.groceries[indexPath.row]["name"] as? String
                }

                alert.addAction(UIAlertAction(title: "Add", style: .default,handler: { handler in
                    // edit item
                    let nameTextField = alert.textFields![0] as UITextField
        
                    if let itemName = nameTextField.text {
                        if itemName != ""{
                            self.editItem(itemName: itemName, itemID: self.groceries[indexPath.row]["id"] as! String)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            
                completionHandler(true)
        }
        
        // MARK: Customize the buttons
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .blue
        
        if groceriesType == 0 {
            return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        } else {
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // make the item complete
        if groceriesType == 0 {
            let itemID = groceries[indexPath.row]["id"] as! String
            
            let dbRef : DatabaseReference!
                dbRef = Database.database().reference().child("Grocery").child("\(itemID)")
                dbRef.updateChildValues(["completed":true,"creatorEmail":" Completed by \(userEmail)"])
        }
    }
}
