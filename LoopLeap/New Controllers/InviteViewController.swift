//
//  InviteViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 13/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController
{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        
        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
        {
            
            if let role = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
            
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
    
    @IBAction func facebookBtnAction(_ sender: Any) {
        
        UIApplication.tryURL(urls: [
            "fb://loopleap", // App
            "https://www.facebook.com/loopleap" // Website if app fails
            ])
        
    }
    
    
    @IBAction func twitterBtnAction(_ sender: Any) {
        
        UIApplication.tryURL(urls: [
            "fb://loopleap", // App
            "https://twitter.com/LoopLeap1" // Website if app fails
            ])
        
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


extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                application.openURL(URL(string: url)!)
                return
            }
        }
    }
}
