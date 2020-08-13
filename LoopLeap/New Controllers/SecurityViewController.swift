//
//  SecurityViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 13/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class SecurityViewController: UIViewController
{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    

    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        descriptionTextView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
        {
            
            if  let role = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
            
            if role  == 6 {
                
                
                sideMenuController?.setContentViewController(with: "\(11)", animated: Preferences.shared.enableTransitionAnimation)
                
            }
                
            else {
                
                sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                
            }
                
            }
            
            else {
                
                sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                
                
                
            }
            
            
        }
            
        else {
            
            sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
            
            
            
        }
        
        sideMenuController?.hideMenu()
        
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
