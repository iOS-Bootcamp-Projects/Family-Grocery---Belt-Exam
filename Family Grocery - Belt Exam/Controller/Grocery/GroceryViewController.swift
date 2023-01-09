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
    
    
    @IBOutlet weak var griceriesTable: UITableView!
    var userID = String()
    var groceries = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
    
    
    
    func addNewItem(itemName:String){
        
        let groceryID = UUID()
        let dbRef : DatabaseReference!
            dbRef = Database.database().reference().child("Grocery").child("\(groceryID)")
            dbRef.setValue(["id":"\(groceryID)","name":itemName,"creatorEmail":" Created By \(Auth.auth().currentUser!.email!)"])
    }
    
    func editItem(itemName:String,itemID:String){
        
        let dbRef : DatabaseReference!
            dbRef = Database.database().reference().child("Grocery").child("\(itemID)")
            dbRef.updateChildValues(["name":itemName,"creatorEmail":"Modified by \(Auth.auth().currentUser!.email!)"])
    }
    
    func observeGrocery(){
        
        let dbRef : DatabaseReference!
        dbRef = Database.database().reference().child("Grocery")

        dbRef.observe(.value) { snapShot , err in
            
                if let groceries = snapShot.value as? NSDictionary {
                    self.groceries.removeAll()
    
                    DispatchQueue.main.async {
                        self.groceries.removeAll()
                        for grocery in groceries {
                            self.groceries.append(grocery.value as! NSDictionary)
                        }
                        
                        self.griceriesTable.reloadData()
                       
                    }
            }
        }
        
    }
}
extension GroceryViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return groceries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = griceriesTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroceriesTableCell
        cell.itemCreator.text = groceries[indexPath.row]["creatorEmail"] as? String
        cell.itemName.text = groceries[indexPath.row]["name"] as? String
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let buyItAction = UIContextualAction(style: .destructive, title: "Buy it") { action, view, completionHandler in
            
            var dbRef: DatabaseReference!
            dbRef = Database.database().reference().child("Grocery").child("\(self.groceries[indexPath.row]["id"] as! String)")
            dbRef.removeValue(){err,ref in
                if err != nil {
                    print("error")
                } else {
                    self.groceries.removeAll()
                    self.observeGrocery()
                }
            }
            
            completionHandler(true)
        }
        
        buyItAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [buyItAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Edit Item", message: "Please enter the name of the item", preferredStyle: .alert)

            alert.addTextField { groceryNameField in
                groceryNameField.placeholder = "bread,banana, etc"
                groceryNameField.text = self.groceries[indexPath.row]["name"] as? String
                
                
            }
        
            alert.addAction(UIAlertAction(title: "Add", style: .default,handler: { handler in
                let nameTextField = alert.textFields![0] as UITextField
    
                if let itemName = nameTextField.text {
                    if itemName != ""{
                        self.editItem(itemName: itemName, itemID: self.groceries[indexPath.row]["id"] as! String)
                    }
                }
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        
    }
    
    
}
