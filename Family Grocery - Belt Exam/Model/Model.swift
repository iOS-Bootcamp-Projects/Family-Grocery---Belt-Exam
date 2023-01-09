//
//  userModel.swift
//  Family Grocery - Belt Exam
//
//  Created by Aamer Essa on 08/01/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

struct Grocery:Codable {
    var id:String
    var name:String
    var creatorEmail:String 
}


//class GroceryModel: ObservableObject {
//    
////    var dbRef:DatabaseReference!
//    var dbRef = Database.database().reference().child("Grocery")
//    
//    
//    func buyIt(itemID:String,completionHandler:@escaping(_ err:Error?,ref:DatabaseReference?)) {
//        
//        dbRef.child("\(itemID)").removeValue() {completionHandler}
//    }
//    
//}
