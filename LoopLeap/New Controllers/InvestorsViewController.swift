//
//  InvestorsViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 13/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import MobileCoreServices
import AssetsPickerViewController
import Photos
import PopupDialog
import AVFoundation
import AVKit
import SDWebImage


class InvestorsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        addressTextField.delegate = self
        phoneNumberTextField.delegate = self
        messageTextView.delegate = self

        nameView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        addressView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        emailView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        phoneNumberView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        messageView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        sendBtn.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 22.5)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        nameTextField.text = ""
        emailTextField.text = ""
        phoneNumberTextField.text = ""
        addressTextField.text = ""
        messageTextView.text = "Message"
        messageTextView.textColor = UIColor.lightGray
        
    }
    
    //MARK:-
    //MARK:- TextField and TextView Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            
        }
        else if textField == emailTextField {
        }
            
        else if textField == phoneNumberTextField {
        }
        else if textField == addressTextField {
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)  {
        if textView == messageTextView {
            
            if textView.text == "Message"  {
                
                textView.text = ""
                textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message"
            textView.textColor = UIColor.lightGray
        }
            
        else if textView.text == "Message"{
            
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
        submitInverstorApi()
        
    }
    
    
    //MARK:-
    //MARK:- API Methods
    
    func submitInverstorApi() {
        
        let name:String = (nameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let address:String = (addressTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let phone:String = (phoneNumberTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let message:String = (messageTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            
            if name.isEmpty {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter name", vc: self)
            }
            else if name.count < 3 {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 3 characters name", vc: self)
            }
                
            else if address.isEmpty {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter address", vc: self)
            }
            else if address.count < 3 {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 3 characters address", vc: self)
            }
            else if email.isEmpty {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email", vc: self)
            }
            else if !ProjectManager.sharedInstance.isEmailValid(email: email) {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Invalid email", vc: self)
            }
            else if phone.isEmpty {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter phone number", vc: self)
            }
            else if phone.count < 8 {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 8 characters phone number", vc: self)
            }
                
            else if message.isEmpty {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter message", vc: self)
            }
            else if message.count < 3 {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 3 characters message ", vc: self)
            }
                
            else if message == "Message" {
                
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter message ", vc: self)
                
            }
                
                
            else {
                
                var parameters = [String: Any]()
                parameters = ["name":name, "email":email, "phone":phone, "message":message, "address":address]
                
                
                
                if ProjectManager.sharedInstance.isInternetAvailable()
                {
                    ProjectManager.sharedInstance.showLoader()
                    
                    
                    Alamofire.request(baseURL + ApiMethods.investor, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
                        .responseJSON { response in
                            
                            ProjectManager.sharedInstance.stopLoader()
                            
                            // check for errors
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling GET on /todos/1")
                                print(response.result.error!)
                                return
                            }
                            
                            // make sure we got some JSON since that's what we expect
                            guard let json = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                }
                                return
                            }
                            
                            print(json)
                            let status = json["status"] as? Int
                            if status == 1{
                                
                                if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
                                {
                                    
                                    if let role = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
                                    
                                    if role  == 6 {
                                        
                                        
                                        self.sideMenuController?.setContentViewController(with: "\(11)", animated: Preferences.shared.enableTransitionAnimation)
                                        
                                    }
                                        
                                    else {
                                        
                                        self.sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                                        
                                    }
                                        
                                    }
                                    
                                    else {
                                        
                                        self.sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                                        
                                        
                                        
                                    }
                                }
                                    
                                else {
                                    
                                    self.sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                                    
                                    
                                    
                                }
                                
                                self.sideMenuController?.hideMenu()
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Message sent successfully.", vc: UIApplication.topViewController()!)
                                
                            }
                                
                            else {
                                DispatchQueue.main.async(execute: {
                                    ProjectManager.sharedInstance.stopLoader()
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                                })
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
