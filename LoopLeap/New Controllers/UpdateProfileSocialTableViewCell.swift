//
//  UpdateProfileSocialTableViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 08/04/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class UpdateProfileSocialTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var instagramView: UIView!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var snapchatView: UIView!
    @IBOutlet weak var snapchatTextField: UITextField!
    @IBOutlet weak var twitterView: UIView!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var linkedinkView: UIView!
    @IBOutlet weak var linkedinTextField: UITextField!
    @IBOutlet weak var aboutMeView: UIView!
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
