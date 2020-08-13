//
//  SearchByProfileNameTableViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 12/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class SearchByProfileNameTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var uploadDateLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var moveBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    public var onDownloadButtonTapped : (() ->Void)? = nil
    public var onMoveButtonTapped : (() ->Void)? = nil
    public var onEditButtonTapped : (() ->Void)? = nil
    public var onCloseButtonTapped : (() ->Void)? = nil
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        cellView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            , cornerRaidus: 2)
        
       
        
    }
    
    @IBAction func downloadBtnAction(_ sender: Any) {
        
        onDownloadButtonTapped!()
        
    }
    
    @IBAction func moveBtnAction(_ sender: Any) {
        
        onMoveButtonTapped!()
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
