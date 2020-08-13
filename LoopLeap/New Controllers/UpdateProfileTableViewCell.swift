//
//  UpdateProfileTableViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 05/04/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class UpdateProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellTextField: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellTextField.textFieldWithLeftView(width: 35, icon: UIImage())

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
