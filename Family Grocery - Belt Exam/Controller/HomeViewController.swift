//
//  HomeViewController.swift
//  Family Grocery - Belt Exam
//
//  Created by Aamer Essa on 08/01/2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tabBarButton: UIView!
    @IBOutlet weak var containerView: UIView!
    var userID = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarButton.layer.cornerRadius = 20
        tabBarButton.clipsToBounds = true
        let groceryView = storyboard!.instantiateViewController(withIdentifier: "GroceryView") as! GroceryViewController
        groceryView.userID = userID
        containerView.addSubview(groceryView.view)
        groceryView.didMove(toParent: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onClickTabBarBtn(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let groceryView = storyBoard.instantiateViewController(withIdentifier: "GroceryView") as! GroceryViewController
            containerView.addSubview(groceryView.view)
            groceryView.didMove(toParent: self)
            
            
            
        } else if sender.tag == 1 {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let familyView = storyBoard.instantiateViewController(withIdentifier: "FamilyView") as! FamilyViewController
            containerView.addSubview(familyView.view)
            familyView.didMove(toParent: self)
            
        }
    }
}
