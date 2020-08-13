//
//  CheckDeepLinkingViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 31/10/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit

class CheckDeepLinkingViewController: UIViewController {

    var token : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
       checkVerification()
        
        // Do any additional setup after loading the view.
    }
    
    func checkVerification() {
        ProjectManager.sharedInstance.showLoader()
       
        
        ProjectManager.sharedInstance.callApiWithoutHeader(params:[ "bearertoken": token as Any], url:baseURL + ApiMethods.checkVerificationAPI, image:nil, imageParam:"") { (response, error) in
                ProjectManager.sharedInstance.stopLoader()
                
                
                if response != nil {
                    if let status = response?["status"] as? NSNumber {
                        if status == 0 {
                           let msg =  response?["message"] as? String
                           // ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg ?? "", vc: UIApplication.topViewController()!)
                            
                            let alert = UIAlertController(title: "", message: msg ?? "", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                                //exit(0)
                                let vc =  self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                
                            }))
                            self.present(alert, animated: false, completion: nil)
                            }
                        
                        else if status == 1 {
                            let vc:PasswordViewController = self.storyboard?.instantiateViewController(withIdentifier:"PasswordViewController") as! PasswordViewController
                            
                            vc.bearertoken = self.token
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                            
                        }
                        else {
                        }
                    }
                }
            }
    


}
