//
//  ForgotPasswordViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 13/09/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var emailTxtFld: UITextField!
    
    @IBOutlet weak var resetPasswordBtn: UIButton!
    //MARK:-
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        SetUI()
        // Do any additional setup after loading the view.
    }
    func SetUI()  {
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = true
            self.resetPasswordBtn.layer.cornerRadius = 22.3
            self.resetPasswordBtn.layer.masksToBounds = true
            self.emailTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "Email-icon"))
          
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    //MARK:- UITextfield Delagate Method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:-
    //MARK:- IBAction Methods
    @IBAction func backAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signinAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        self.view.endEditing(true)
        let email:String = (emailTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        
        if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email", vc: self)
        }
        else if !ProjectManager.sharedInstance.isEmailValid(email: email) {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Invalid email", vc: self)
        }
       
        else {
            ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWithoutHeader(params:[ "email":email ], url:baseURL + ApiMethods.forgotPasswordAPI, image:nil, imageParam:"") { (response, error) in
                ProjectManager.sharedInstance.stopLoader()
                if response != nil {
                    if let status = response?["status"] as? NSNumber {
                        if status == 0 {
                            if let msg = response?["message"] as? String {
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg, vc: UIApplication.topViewController()!)
                            }
                        }
                        else {
                            if let msg = response?["message"] as? String {
                                self.navigationController?.popViewController(animated: true)
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg, vc: UIApplication.topViewController()!)
                            }
                        }
                    }
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
