//
//  UpdateProfileMarriageTableViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 08/04/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class UpdateProfileMarriageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var marriageDateTextField: UITextField!
    @IBOutlet weak var marriedToTextField: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        marriedToTextField.textFieldWithLeftView(width: 35, icon: UIImage())
        marriageDateTextField.textFieldWithLeftView(width: 35, icon: UIImage())

        
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
