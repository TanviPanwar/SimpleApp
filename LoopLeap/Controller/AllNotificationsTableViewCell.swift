//
//  AllNotificationsTableViewCell.swift
//  LoopLeap
//
//  Created by IOS3 on 01/01/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class AllNotificationsTableViewCell: UITableViewCell
{
     @IBOutlet weak var cellView: UIView!
     @IBOutlet weak var notificationImageView: UIImageView!
     @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var dateLabel: UILabel!


    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        
        cellView.setBorder(width: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRaidus: 4)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
