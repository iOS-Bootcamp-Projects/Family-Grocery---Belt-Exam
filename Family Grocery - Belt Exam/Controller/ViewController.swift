//
//  ViewController.swift
//  Family Grocery - Belt Exam
//
//  Created by Aamer Essa on 08/01/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
class ViewController: UIViewController {

    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var singUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.backgroundColor = .white
        loginBtn.layer.cornerRadius = 15
        singUpBtn.backgroundColor = .white
        singUpBtn.layer.cornerRadius = 15
        errorMessage.isHidden = true
    }

    //Mark: Navigation
    
    @IBAction func singUp(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signUpView = storyBoard.instantiateViewController(withIdentifier: "SingUpView")
        signUpView.modalPresentationStyle = .fullScreen
        present(signUpView, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        
        errorMessage.isHidden = true
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextFiled.text!){ authorized, err in
            
            if err != nil {
                self.errorMessage.isHidden = false
                self.errorMessage.text = "⚠ \(err!.localizedDescription)"

            } else {
                
                // add the user into online chiled
                let databaseRef: DatabaseReference!
                databaseRef = Database.database().reference()
                databaseRef.child("Online").child("\(authorized!.user.uid)").setValue(authorized!.user.email)
                
                // navigate to home
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let homeView = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! TabBarViewController
                let groceryView = homeView.viewControllers![0] as! GroceryViewController
                groceryView.userID = authorized!.user.uid
                homeView.modalPresentationStyle = .fullScreen
                self.present(homeView, animated: true)
                
            }
            
        }
    
        //login
        
    }
    
}

