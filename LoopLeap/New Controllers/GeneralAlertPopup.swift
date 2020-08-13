//
//  GeneralAlertPopup.swift
//  LoopLeap
//
//  Created by iOS6 on 21/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class GeneralAlertPopup: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var showPlansBtn: UIButton!
    
    var cancelAction :blockAction?
    var showPlansAction : blockAction?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cancelBtn.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: cancelBtn.frame.size.height/2)
           showPlansBtn.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: showPlansBtn.frame.size.height/2)
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        cancelAction!()
        
    }
    
    @IBAction func showPlansBtnAction(_ sender: Any) {
        
      showPlansAction!()
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
