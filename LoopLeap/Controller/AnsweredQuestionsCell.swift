//
//  AnsweredQuestionsCell.swift
//  LoopLeap
//
//  Created by IOS3 on 04/01/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class AnsweredQuestionsCell: UITableViewCell
{
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var cellImageView: UIImageView!


    @IBOutlet weak var answeredQuestionsTextView: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var activityIndicator:
    UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        editBtn.layer.cornerRadius = 15
//        editBtn.clipsToBounds = true
//
//        deleteBtn.layer.cornerRadius = 15
//        deleteBtn.clipsToBounds = true
//
//      editBtn.setBorderWithWidth(width:1 , color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
//         deleteBtn.setBorderWithWidth(width:1 , color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        
       

        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIView {

    func setBorderWithWidth(width:CGFloat , color :UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
