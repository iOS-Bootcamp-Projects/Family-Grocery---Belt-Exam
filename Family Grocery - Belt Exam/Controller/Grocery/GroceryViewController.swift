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
        print(userID)
        griceriesTable.delegate = self
        griceriesTable.dataSource = self
        
      observeGrocery()
    }
    
    @objc func handleSaveBtn(){
        print("AAA")
    }

    
    // MARK: - Action 
   
    @IBAction func showAddNewItemForm(_ sender: UIBarButtonItem) {
                let alert = UIAlertController(title: "Add New Item", message: "Please enter the name of the item", preferredStyle: .alert)
        
                alert.addTextField { sportNameField in
                    sportNameField.placeholder = "bread,banana, etc" }
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
        
        let dbRef : DatabaseReference!
        dbRef = Database.database().reference().child("Grocery").child("\(UUID())")
        dbRef.setValue(["name":itemName,"creatorEmail":Auth.auth().currentUser!.email])
        
        
    }
    
    func observeGrocery(){
        
        let dbRef : DatabaseReference!
        dbRef = Database.database().reference().child("Grocery")
        dbRef.observe(.childAdded) { snapShot ,err in
            
            if let grocery = snapShot.value as? NSDictionary {
                self.groceries.append(grocery)
                print(self.groceries)
                self.griceriesTable.reloadData()
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
        cell.itemName.text = groceries[indexPath.row]["name"] as? String
        cell.itemCreator.text = "Created by \(groceries[indexPath.row]["creatorEmail"] as! String)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let buyItAction = UIContextualAction(style: .destructive, title: "Buy it") { action, view, completionHandler in
            print("delete ")
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { action, view, completionHandler in
           print("edit")

            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        buyItAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [buyItAction,editAction])
    }
    
    
}
