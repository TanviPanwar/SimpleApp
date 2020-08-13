//
//  KeyHolderTableViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 12/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class KeyHolderTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var keyHolderImgView: UIImageView!
    @IBOutlet weak var keyholderNameLabel: UILabel!
    @IBOutlet weak var keyHolderMailLabel: UILabel!
    @IBOutlet weak var keyHolderLocationLabel: UILabel!
    @IBOutlet weak var keyHolderCallLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    public var onEditButtonTapped : (() ->Void)? = nil
    public var onCloseButtonTapped : (() ->Void)? = nil

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
       cellView.layer.borderWidth = 1
       cellView.layer.masksToBounds = false
       cellView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
       cellView.layer.cornerRadius = 2
       cellView.clipsToBounds = true
        
        keyHolderImgView.layer.borderWidth = 1
        keyHolderImgView.layer.masksToBounds = false
        keyHolderImgView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        keyHolderImgView.layer.cornerRadius = keyHolderImgView.frame.height/2 
        keyHolderImgView.clipsToBounds = true
        
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        
        onEditButtonTapped!()
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        
        onCloseButtonTapped!()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
