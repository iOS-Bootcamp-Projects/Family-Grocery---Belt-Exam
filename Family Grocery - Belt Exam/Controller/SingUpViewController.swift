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
import FirebaseStorage
class SingUpViewController: UIViewController,  UIImagePickerControllerDelegate & UINavigationControllerDelegate  {

    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var confirmPasswordTextFiled: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var singupBtn: UIButton!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var fullNameTextFiled: UITextField!
    
    var selectedProfileImage = Data()
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
            
            
            // saveImage into sorage
            
            let path = "profileImages/\(UUID().uuidString).png"
            let storageRef : StorageReference!
              storageRef = Storage.storage().reference().child(path)
            
            storageRef.putData(self.selectedProfileImage){ data , err in
                
                if err != nil {
                    self.errorMessage.text = "\(err!.localizedDescription)"
                    self.errorMessage.isHidden = false
                } else {
                    
                    // cretr new User into database
                    
                    Auth.auth().createUser(withEmail: self.emailTextFiled.text!, password: self.passwordTextFiled.text!){ resualt, err in
                        
                        if err != nil {
                            self.errorMessage.text = "⚠ \(err!.localizedDescription)"
                            self.errorMessage.isHidden = false
                        } else {
                            
                            // add user information to the database
                            
                            let dbRef: DatabaseReference!
                            dbRef = Database.database().reference()
                            
                            dbRef.child("Users").child("\(resualt!.user.uid)").setValue(["fullName":self.fullNameTextFiled.text!,"email":self.emailTextFiled.text!,"password":self.passwordTextFiled.text!,"profileImage":"\(path)"])
                            
                          // send Notification
                            self.sendNotification()
                            self.dismiss(animated: true)
                            
                        }
                    }
                    
                }
            }
            
        }
             
    }// signup
    
    
    @IBAction func SelectImage(_ sender: UIButton) {
        getImage()
    }
    
    //MARK: Get Image Setup
       
       private func getImage(){
           
           let photoPicker = UIImagePickerController()
               photoPicker.sourceType = .photoLibrary
               photoPicker.allowsEditing = true
               photoPicker.delegate = self
           present(photoPicker, animated: true)
           
       } //getImage()
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
               if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
                   
                   profileImageView.image = image
                   selectedProfileImage = image.pngData()!
                   print(image.pngData())

                   }
                   picker.dismiss(animated: true)
           
               } //imagePickerController
    
    
    
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
