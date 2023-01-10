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
import FacebookLogin
import FirebaseDatabase
import FirebaseStorage
class ViewController: UIViewController {

  
    @IBOutlet weak var facebookLoginBtn: FBLoginButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var singUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginBtn.layer.cornerRadius = 15
        
        singUpBtn.layer.cornerRadius = 15
        errorMessage.isHidden = true
       
        
        if let token = AccessToken.current,
           !token.isExpired {
            
            loginFromFacebook(token: token)
        } else {
            facebookLoginBtn.delegate = self
        }
        
    }
    
    
    func loginFromFacebook(token: AccessToken) {
       
            let token = token.tokenString
            let request = FacebookLogin.GraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture"], tokenString: token, version: nil, httpMethod: .get)
            
        // get data from facebook
            request.start { connection, result, err in
                if let userInfo = result as? NSDictionary {
                    
                    // store the image profile in the storage
                    
                    if let profileImage = userInfo["picture"] as? NSDictionary {
                        
                        if let imageData = profileImage["data"] as? NSDictionary {
                            
                            if let  imageURL = URL(string: imageData["url"] as! String) {
                                
                                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                                    
                                    // upload image to storage
                                    DispatchQueue.main.async {
                                        
                                        let path = "profileImages/fb\(userInfo["id"] as! String).png"
                                        let storageRef : StorageReference!
                                        storageRef = Storage.storage().reference().child(path)
                                        storageRef.putData(data!)
                                        
                                    }
                                }.resume()
                                
                            } // end of imageURL
                            
                        } // end of imageData
                    } // end of profileImage
                    
                    // save user info to the user
                    let dbRef : DatabaseReference!
                    dbRef = Database.database().reference().child("Users").child(userInfo["id"] as! String)
                    dbRef.setValue(["fullName":userInfo["name"],"email":userInfo["email"],"passsword":"","profileImage":"profileImages/fb\(userInfo["id"] as! String).png"])
                    
                    // add the user into online chiled
                    let databaseRef: DatabaseReference!
                    databaseRef = Database.database().reference()
                    databaseRef.child("Online").child("\(userInfo["id"] as! String)").setValue(userInfo["email"] as! String)
                    
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let homeView = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! TabBarViewController
                    //pass usserId to screens
                    
                    let groceryView = homeView.viewControllers![0] as! GroceryViewController
                    let familyView = homeView.viewControllers![1] as! FamilyViewController
                    let accountView = homeView.viewControllers![2] as! AccountViewController
                    groceryView.userID = "\(userInfo["id"] as! String)"
                    groceryView.userEmail = "\(userInfo["email"] as! String)"
                    familyView.userID = "\(userInfo["id"] as! String)"
                    accountView.userID = "\(userInfo["id"] as! String)"
                    homeView.modalPresentationStyle = .fullScreen
                    self.present(homeView, animated: true)
                    
                } // resulat
                
        } // request Start
        
    }  //loginFromFacebook
    

    //Mark: Action
    
    @IBAction func singUp(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signUpView = storyBoard.instantiateViewController(withIdentifier: "SingUpView")
        signUpView.modalPresentationStyle = .fullScreen
        present(signUpView, animated: true)
    } // singup
    

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
                
                //pass id to screens
                
                let groceryView = homeView.viewControllers![0] as! GroceryViewController
                let familyView = homeView.viewControllers![1] as! FamilyViewController
                let accountView = homeView.viewControllers![2] as! AccountViewController
                
                groceryView.userID = authorized!.user.uid
                groceryView.userEmail = authorized!.user.email!
                familyView.userID = authorized!.user.uid
                accountView.userID = authorized!.user.uid
                
                homeView.modalPresentationStyle = .fullScreen
                self.present(homeView, animated: true)
                
            }
            
        }
    }//login
}

extension ViewController: LoginButtonDelegate{
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        let token = result?.token
        loginFromFacebook(token: token!)

    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout")
    }
    
    
}
