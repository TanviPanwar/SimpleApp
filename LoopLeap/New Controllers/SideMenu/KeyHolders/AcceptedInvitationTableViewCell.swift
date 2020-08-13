//
//  AcceptedInvitationTableViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 04/04/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class AcceptedInvitationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var keyHolderImgView: UIImageView!
    @IBOutlet weak var keyholderNameLabel: UILabel!
    @IBOutlet weak var keyHolderMailLabel: UILabel!
    @IBOutlet weak var keyHolderLocationLabel: UILabel!
    @IBOutlet weak var keyHolderCallLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var requestAccessBtn: UIButton!
    @IBOutlet weak var viewQuesBtn: UIButton!
    @IBOutlet weak var sharedDirectoriesBtn: UIButton!
    
    public var onEditButtonTapped : (() ->Void)? = nil
    public var onCloseButtonTapped : (() ->Void)? = nil
    public var onRequestAccessButtonTapped : (() ->Void)? = nil
    public var onViewQuesButtonTapped : (() ->Void)? = nil
    public var onsharedDirButtonTapped : (() ->Void)? = nil
    
    
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
        
        requestAccessBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: requestAccessBtn.frame.size.height/2)
        
        sharedDirectoriesBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: sharedDirectoriesBtn.frame.size.height/2)
        
         viewQuesBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: viewQuesBtn.frame.size.height/2)
        
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        
        onEditButtonTapped!()
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        
        onCloseButtonTapped!()
    }
    
    
    @IBAction func requestAccessBtnAction(_ sender: Any) {
        
        onRequestAccessButtonTapped!()
    }
    
    @IBAction func viewQuesBtnAction(_ sender: Any) {
        
        onViewQuesButtonTapped!()
    }
    
    @IBAction func sharedDirBtnAction(_ sender: Any) {
        
        onsharedDirButtonTapped!()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
