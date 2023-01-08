//
//  SingUpViewController.swift
//  Family Grocery - Belt Exam
//
//  Created by Aamer Essa on 08/01/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore 
class SingUpViewController: UIViewController {

    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var confirmPasswordTextFiled: UITextField!
    
    @IBOutlet weak var singupBtn: UIButton!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var fullNameTextFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessage.isHidden = true
        singupBtn.layer.cornerRadius = 15
        singupBtn.backgroundColor = .white
        
        
        // Do any additional setup after loading the view.
    }
    

  
    // MARK: - Navigation

   
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func singUp(_ sender: Any) {
        errorMessage.isHidden = true
        if passwordTextFiled.text != confirmPasswordTextFiled.text {
            errorMessage.text = "⚠ Password Not Match"
            errorMessage.isHidden = false
        } else {
            
            Auth.auth().createUser(withEmail: emailTextFiled.text!, password: passwordTextFiled.text!){ resualt, err in
                
                if err != nil {
                    self.errorMessage.text = "⚠ \(err!.localizedDescription)"
                    self.errorMessage.isHidden = false
                } else {
                    
                    // add user information to the database
                    
                    let dbRef: DatabaseReference!
                    dbRef = Database.database().reference()
                    
                    dbRef.child("Users").child("\(resualt!.user.uid)").setValue(["fullName":self.fullNameTextFiled.text!,"email":self.emailTextFiled.text!,"password":self.passwordTextFiled.text!])
                    
                  // send Notification
                    self.sendNotification()
                    self.dismiss(animated: true)
                    
                }
            }
            // signup
        }
             
    }
    
    // MARK: - Notification
       
       
       func sendNotification(){
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) {  authorized, error in
               if authorized {
                   DispatchQueue.main.async {
                       self.generateNotification(name: self.fullNameTextFiled.text!)
                   }
                       
               }
           } // end of UNUserNotificationCenter
       } // end of sendNotification()
       
       func generateNotification(name:String){
           
           let notificationContent = UNMutableNotificationContent()
           notificationContent.title = "Welcome to Messenger"
           notificationContent.body = "Dear \(name) thank you to join us "
           notificationContent.sound = .default
           
           let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval:TimeInterval(1) , repeats: false)
           
           let request = UNNotificationRequest(identifier: "test", content: notificationContent, trigger: notificationTrigger)
           UNUserNotificationCenter.current().add(request)
           
       } // end of generateNotification
}
