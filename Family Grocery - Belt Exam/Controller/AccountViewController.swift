//
//  AccountViewController.swift
//  Family Grocery - Belt Exam
//
//  Created by Aamer Essa on 08/01/2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import FacebookLogin
import GoogleSignIn 
class AccountViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var confirmPasswordTextFiled: UITextField!
    @IBOutlet weak var editAccountBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var selectPhoto: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    var userID = String()
    var user = [NSDictionary]()
    var screenMode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
        editAccountBtn.layer.cornerRadius = 15
        cancelBtn.layer.cornerRadius = 15
        normalMode()

    }
    

    
    
    
    
    func getUserInfo() {
        
        let dbRef : DatabaseReference!
        dbRef = Database.database().reference().child("Users").child("\(userID)")
        dbRef.observe(.value) { userInfo , err  in
            
            if let user = userInfo.value as? NSDictionary {
                self.nameTextFiled.text = user["fullName"] as? String
                self.emailTextFiled.text = user["email"] as? String
                self.passwordTextFiled.text = user["password"] as? String
                
                let storageRef = Storage.storage().reference().child("\(user["profileImage"] as! String)")
                          storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                              
                              if error == nil {
                                  self.profileImageView.image = UIImage(data: data!)
                                 
                              }
                          }
                
            }
        }
        
    }
    
    
    // MARK: - Customize
    
    func editMode(){
        
        confirmPasswordTextFiled.isHidden = false
        cancelBtn.isHidden = false
        selectPhoto.isHidden = false
        editAccountBtn.setTitle("Save", for: .normal)
        editAccountBtn.backgroundColor = .green
        nameTextFiled.isUserInteractionEnabled = true
        emailTextFiled.isUserInteractionEnabled = true
        passwordTextFiled.isUserInteractionEnabled = true
        screenMode = 1
        
    }
    
    func normalMode() {
        confirmPasswordTextFiled.isHidden = true
        nameTextFiled.isUserInteractionEnabled = false
        emailTextFiled.isUserInteractionEnabled = false
        passwordTextFiled.isUserInteractionEnabled = false
        errorMessage.isHidden = true
        confirmPasswordTextFiled.text = ""
        cancelBtn.isHidden = true
        selectPhoto.isHidden = true
        editAccountBtn.setTitle("Edit Account", for: .normal)
        editAccountBtn.backgroundColor = .link
        
    }
    
    // MARK: - Action
    
    @IBAction func logout(_ sender: Any) {
        
        let loginManager = LoginManager()
        
        // singout from facebook account
        let firebaseAuth = Auth.auth()
        
        // singout from google account
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        
        do{
            
            try firebaseAuth.signOut()
            loginManager.logOut()
            GIDSignIn.sharedInstance.signOut()
            
            // remove the user from online
            var dbRef : DatabaseReference!
                dbRef = Database.database().reference().child("Online").child("\(userID)")
                dbRef.removeValue()
            
            //go to login screen
            let storBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storBoard.instantiateViewController(withIdentifier: "LoginView")
            loginView.modalPresentationStyle = .fullScreen
            present(loginView, animated: true)
            
            
        } catch{
            print("error")
        }
    }// logout
    
    @IBAction func editAccount(_ sender: Any) {
        
        if screenMode == 0 {
            editMode()
        } else {
            errorMessage.isHidden = true
            if passwordTextFiled.text != confirmPasswordTextFiled.text {
                errorMessage.text = "⚠ Passowrd Not Match"
                errorMessage.isHidden = false
            } else {
                
                Auth.auth().currentUser?.updateEmail(to: self.emailTextFiled.text!,completion: { err in
                    if err != nil {
                        self.errorMessage.isHidden = false
                        self.errorMessage.text = "⚠ \(err!.localizedDescription)"
                    } else {
                        Auth.auth().currentUser?.updatePassword(to: self.passwordTextFiled.text!,completion: { err in
                            if err != nil {
                                self.errorMessage.isHidden = false
                                self.errorMessage.text = "⚠ \(err!.localizedDescription)"
                            } else {
                                
                                var dbRef : DatabaseReference!
                                dbRef = Database.database().reference().child("Users").child("\(self.userID)")
                                dbRef.updateChildValues(["fullName":self.nameTextFiled.text!,"email":self.emailTextFiled.text!,"password":self.passwordTextFiled.text!])
                                
                                let alert = UIAlertController(title: "Success", message: "you need to log in again \n By clicking on 'Ok' the system will logout you automatically ", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel){ handler in
                                    self.logout(self)
                                })
                                self.present(alert, animated: true)
                                
                                
                            }
                        })
                    }
                })
                
            }
            
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        screenMode = 0
       normalMode()
    }
}
