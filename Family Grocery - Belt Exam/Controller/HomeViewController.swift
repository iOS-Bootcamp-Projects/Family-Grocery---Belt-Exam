//
//  HomeViewController.swift
//  Family Grocery - Belt Exam
//
//  Created by Aamer Essa on 08/01/2023.
//

import UIKit



 
    

class HomeViewController: UIViewController {
 
    
 
        
    

    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var familyButton: UIButton!
    @IBOutlet weak var groceryButton: UIButton!
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
    

  
    // MARK: - Navigation

  
    @IBAction func onClickTabBarBtn(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let groceryView = storyBoard.instantiateViewController(withIdentifier: "GroceryView") as! GroceryViewController
            containerView.addSubview(groceryView.view)
//            groceryView.didMove(toParent: self)
            
            
            groceryButton.setImage(UIImage(named: "groceryColor"), for: .normal)
            familyButton.setImage(UIImage(named: "family"), for: .normal)
            accountButton.setImage(UIImage(named: "account"), for: .normal)
            
            
        } else if sender.tag == 1 {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let familyView = storyBoard.instantiateViewController(withIdentifier: "FamilyView") as! FamilyViewController
            containerView.addSubview(familyView.view)
            familyView.didMove(toParent: self)
            
            familyButton.setImage(UIImage(named: "familyColor"), for: .normal)
            groceryButton.setImage(UIImage(named: "grocery"), for: .normal)
            accountButton.setImage(UIImage(named: "account"), for: .normal)
            
            
//            let dotView = UIView()
//
//            let btnSize = sender.frame.size
//               let dotSize = 20
//                dotView.backgroundColor = .red //Just change colors
//               dotView.layer.cornerRadius = CGFloat(dotSize/2)
//               dotView.layer.frame = CGRect(x: Int(btnSize.width)-dotSize/2 , y:
//               0, width: dotSize, height: dotSize)
//            let yourLabel = UILabel(frame: CGRectMake(100, 100, 100, 100))
//            yourLabel.textColor = UIColor.white
//               yourLabel.backgroundColor = UIColor.red
//               yourLabel.text = "12"
//            dotView.addSubview(yourLabel)
//
//               sender.addSubview(dotView)
            
            
        } else if sender.tag == 2 {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let familyView = storyBoard.instantiateViewController(withIdentifier: "AccountView") as! AccountViewController
            containerView.addSubview(familyView.view)
            familyView.didMove(toParent: self)
            
            accountButton.setImage(UIImage(named: "accountColor"), for: .normal)
            groceryButton.setImage(UIImage(named: "grocery"), for: .normal)
            familyButton.setImage(UIImage(named: "family"), for: .normal)
            
        }
        
    }
}
