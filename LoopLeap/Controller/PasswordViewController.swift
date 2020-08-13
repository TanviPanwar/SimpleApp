//
//  PasswordViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 13/09/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    @IBOutlet weak var createPasswordTxtFld: UITextField!
    @IBOutlet weak var setPasswordBtn: UIButton!
    @IBOutlet weak var reenterPasswordTxtFld: UITextField!

    
    var bearertoken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetUI()
        //let password:String = (createPasswordTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!

        
        // Do any additional setup after loading the view.
    }
    
    func SetUI()  {
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = true
            self.setPasswordBtn.layer.cornerRadius = 22.3
            self.setPasswordBtn.layer.masksToBounds = true
            self.createPasswordTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "Password-icon"))
            self.reenterPasswordTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "Password-icon"))
          
        }
    }
    
    //MARK:-
    //MARK:- Textfield Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    //MARK:- IBAction Methods
    
    @IBAction func setPasswrdBtnAct(_ sender: Any)
    {
        self.view.endEditing(true)
        
        let password:String = (createPasswordTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let cnfirmPassword:String = (reenterPasswordTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!

        
        if password.isEmpty
        {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter password", vc: self)
        }
            
        else if password != cnfirmPassword
        {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Password and confirm password should be same", vc: self)
        }
            
        else if password.count < 8
        {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 8 characters password", vc: self)
        }
            
        else if cnfirmPassword.isEmpty
        {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter confirm password", vc: self)
        }
            
        else if cnfirmPassword.count < 8 {
            
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 8 characters password", vc: self)
        }
            
       else if validate(password: password) != true
        {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Password should contain uppercase, lower case, numbers and special characters", vc: self)

        }
            
        else if validate(password: cnfirmPassword) != true
        {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Password should contain uppercase, lower case, numbers and special characters", vc: self)
            
        }
            
        else {
            ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWithoutHeader(params:[ "token":self.bearertoken,"Password":password ], url:baseURL + ApiMethods.setPasswordAPI, image:nil, imageParam:"") { (response, error) in
                ProjectManager.sharedInstance.stopLoader()
                if response != nil {
                    if let status = response?["status"] as? NSNumber {
                        if status == 0 {
                            if let err = response?["error"] as? [String:Any] {
                                
                                if let emailArr = err["Email"] as?[String] {
                                    if emailArr.count > 0 {
                                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: emailArr[0], vc: UIApplication.topViewController()!)
                                        return
                                    }
                                    
                                }
                                
                                if let phoneArr = err["phone"] as?[String] {
                                    if phoneArr.count > 0 {
                                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: phoneArr[0], vc: UIApplication.topViewController()!)
                                        return
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        else {
                            
                                 if let msg = response?["message"] as? String {
                

                                    
                                    for vc in (self.navigationController?.viewControllers)!  {
                                        if vc is LoginViewController {
                                            self.navigationController?.popToViewController(vc, animated: true)
                                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg, vc: UIApplication.topViewController()!)
                                            return
                                        }
                                    }

                                    let vc =  self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

                                    self.navigationController?.pushViewController(vc, animated: true)
                                 ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg, vc: UIApplication.topViewController()!)
                            }
                            
                        }
                    }
                    
                    
                }
                
                
            }
            
        }
    }
    
    func validate(password: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: password) else { return false }
        
        let smallLetterRegEx  = ".*[a-z]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", smallLetterRegEx)
        guard texttest1.evaluate(with: password) else { return false }
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest2.evaluate(with: password) else { return false }
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest3 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        guard texttest3.evaluate(with: password) else { return false }
        
        return true
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
