//
//  DashBoardCollectionViewCell.swift
//  LoopLeap
//
//  Created by iOS6 on 06/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class DashBoardCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var deleteStackView: UIStackView!
    @IBOutlet weak var viewEditStackView: UIStackView!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var viewBtn1: UIButton!
    @IBOutlet weak var editBtn1: UIButton!
    
    
     public var onViewButtonTapped : (() ->Void)? = nil
     public var onEditButtonTapped : (() ->Void)? = nil
     public var onDeleteButtonTapped : (() ->Void)? = nil
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    //MARK:-
    //MARK:- IB Actions
    
    
    @IBAction func viewBtnAction(_ sender: UIButton) {
        
        onViewButtonTapped!()
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        
        onEditButtonTapped!()
    }
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        
        onDeleteButtonTapped!()
    }
   
    
    
}


