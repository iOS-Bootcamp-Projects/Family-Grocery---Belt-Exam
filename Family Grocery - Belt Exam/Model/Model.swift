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

struct User:Codable {
    var id:String
    var name:String
    var email: String 
    var password:String
    var profileImage: String 
}



