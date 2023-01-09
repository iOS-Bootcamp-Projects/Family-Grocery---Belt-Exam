//
//  FamilyTableViewCell.swift
//  Family Grocery - Belt Exam
//
//  Created by Aamer Essa on 09/01/2023.
//

import UIKit

class FamilyTableViewCell: UITableViewCell {

   
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
