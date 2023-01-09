//
//  FamilyViewController.swift
//  Family Grocery - Belt Exam
//
//  Created by Aamer Essa on 08/01/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class FamilyViewController: UIViewController {

    @IBOutlet weak var familOnlineTabel: UITableView!
    var users = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()

        familOnlineTabel.dataSource = self
        familOnlineTabel.delegate = self
        observeOnlineUsers()
    }
    
    func observeOnlineUsers(){
        
        var dbRef : DatabaseReference!
        dbRef = Database.database().reference().child("Online")
        dbRef.observe(.childAdded) { snapshot in
            
            if snapshot.key != Auth.auth().currentUser?.uid {
                if snapshot.value is String {
                    
                    var usersDbRef : DatabaseReference!
                    usersDbRef = Database.database().reference().child("Users").child("\(snapshot.key)")
                    usersDbRef.observe(.value) { userInfo in
                        
                        if let user = userInfo.value as? NSDictionary {
                            self.users.append(user)
                            self.familOnlineTabel.reloadData()
                        }
                        
                        
                    }
                }
            }
            
        }
    }

   

}

extension FamilyViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = familOnlineTabel.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FamilyTableViewCell
        cell.userName.text = users[indexPath.row]["fullName"] as? String
        cell.userEmail.text = users[indexPath.row]["email"] as? String
        return cell
    }
    
    
}
