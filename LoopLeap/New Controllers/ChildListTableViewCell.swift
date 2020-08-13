//
//  ChildListTableViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 14/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class ChildListTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var releaseBtn: UIButton!
    @IBOutlet weak var impersonateBtn: UIButton!
    
    public var onEditButtonTapped : (() ->Void)? = nil
    public var onCloseButtonTapped : (() ->Void)? = nil
    public var onReleaseButtonTapped : (() ->Void)? = nil
    public var onImpersonateButtonTapped : (() ->Void)? = nil

    
  
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
         cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
         releaseBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: releaseBtn.frame.height/2)
         impersonateBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: impersonateBtn.frame.height/2)
         profileImg.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: profileImg.frame.size.height/2)
        
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        
        onEditButtonTapped!()
        
    }
    
    
    @IBAction func closeBtnAction(_ sender: Any) {
        
        onCloseButtonTapped!()
    }
    
    
    @IBAction func releaseBtnAction(_ sender: Any) {
        
        onReleaseButtonTapped!()
    }
    
    @IBAction func impersonateBtnAction(_ sender: Any) {
        
        onImpersonateButtonTapped!()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
