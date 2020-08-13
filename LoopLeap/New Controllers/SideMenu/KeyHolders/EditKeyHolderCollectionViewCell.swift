//
//  EditKeyHolderCollectionViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 20/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class EditKeyHolderCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var dirTitleLabel: UILabel!
    
    public var onDeleteButtonTapped : (() ->Void)? = nil
    
    
    @IBAction func deleteBtnAction(_ sender: Any) {
        
        onDeleteButtonTapped!()
    }
    
    
}
