//
//  ListViewCell.swift
//  LoopLeap
//
//  Created by IOS3 on 13/09/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    @IBOutlet weak var fileNameLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var fileSizeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
