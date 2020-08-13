//
//  Card.swift
//  SwiftExample
//
//  Created by Visions on 15/05/19.
//  Copyright © 2019 Charcoal Design. All rights reserved.
//

import UIKit


protocol CardAction {
    func buyBtnClicked()
}

class Card: UIView {

    
    var delegate : CardAction?
    
    @IBOutlet var cardView: Card!
    @IBOutlet weak var buyPlanView: UIView!
    @IBOutlet weak var amountImgView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var decimalAmountLabel: UILabel!
    @IBOutlet weak var planTypeLabel: UILabel!
    @IBOutlet weak var storageLabel: UILabel!
    @IBOutlet weak var planLabel: UILabel!
    
    @IBOutlet weak var buyNowBtn: UIButton!
    
    @IBOutlet weak var buyNowView: UIView!
    
    
    //MARK:- Object Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("Card", owner: self, options: nil)
        
        cardView.frame = frame
        self.addSubview(cardView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func showPopUp() {
        delegate?.buyBtnClicked()
    }
    
    @IBAction func butNowBtnAction(_ sender: Any) {
        
        showPopUp()
        
    }
    
    
    func closePopUp() {
        removeFromSuperview()
    }

}
