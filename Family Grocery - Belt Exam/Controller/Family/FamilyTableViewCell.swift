//
//  FamilyTableViewCell.swift
//  Family Grocery - Belt Exam
//
//  Created by Aamer Essa on 09/01/2023.
//

import UIKit

class FamilyTableViewCell: UITableViewCell {

    //MARK: Connections
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
