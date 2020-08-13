//
//  PaymentHistoryTableViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 20/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class PaymentHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellSubView: UIView!
    @IBOutlet weak var cellPlanTypeLabel: UILabel!
    @IBOutlet weak var cellPlanPurchaseLabel: UILabel!
    @IBOutlet weak var cellExpiresOnLabel: UILabel!
    @IBOutlet weak var cellPriceLabel: UILabel!
    @IBOutlet weak var cellStorageLabel: UILabel!
    @IBOutlet weak var statusOnLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellSubView.setBorder(width: 1, color: #colorLiteral(red: 0.830683291, green: 0.830683291, blue: 0.830683291, alpha: 1), cornerRaidus: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
