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
import FirebaseStorage

class FamilyViewController: UIViewController {
    
    //MARK: Connections
    @IBOutlet weak var familOnlineTabel: UITableView!
    
    //MARK: Vars
    var users = [NSDictionary]()
    var userID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        familOnlineTabel.dataSource = self
        familOnlineTabel.delegate = self
        observeOnlineUsers()
    }
    
    func observeOnlineUsers(){
        
        var dbRef : DatabaseReference!
            dbRef = Database.database().reference().child("Online")
            dbRef.observe(.value) { snapshot , err in
                
            self.users.removeAll()
            if let usersOnline = snapshot.value as? NSDictionary {
                
                for user in usersOnline {
                    
                    if self.userID != user.key as? String  {
                        
                        var usersDbRef : DatabaseReference!
                        usersDbRef = Database.database().reference().child("Users").child("\(user.key)")
                        usersDbRef.observe(.value) { userInfo in
                            
                            if let user = userInfo.value as? NSDictionary {
                                DispatchQueue.main.async {
                                    self.users.append(user)
                                    self.familOnlineTabel.reloadData()
                                }
                            } // end of user
                        }// end of observe
                    
                    } else if self.users.count == 0 {

                        self.familOnlineTabel.reloadData()
                    }// end of else
                } //  end of for
            } else{
                self.familOnlineTabel.reloadData()
            }
        } // end of dbRef observe
    }
}

extension FamilyViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = familOnlineTabel.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FamilyTableViewCell
        
        //get image fot Storage
        
        let storageRef = Storage.storage().reference().child("\(users[indexPath.row]["profileImage"] as! String)")
            storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                      
                      if error == nil {
                          DispatchQueue.main.async {
                              cell.profileImageView.image = UIImage(data: data!)
                          }
                      }
                  }
        cell.userName.text = users[indexPath.row]["fullName"] as? String
        cell.userEmail.text = users[indexPath.row]["email"] as? String
        return cell
    }
}
