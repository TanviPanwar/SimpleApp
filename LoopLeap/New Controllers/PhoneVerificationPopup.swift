//
//  PhoneVerificationPopup.swift
//  LoopLeap
//
//  Created by iOS6 on 27/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import Photos
import PopupDialog
import IQKeyboardManagerSwift
import AVKit

protocol refreshChildListDelegate {
    func refreshChildList(index : Int)
}

protocol refreshAddedChildDelegate {
    func refreshAddedChild()
}


class PhoneVerificationPopup: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    
    var verifyAction :blockAction?
    var  noAction : blockAction?
    var obj = KeyHolderObject()
    var boolChecked = Bool()
    
    var isEditBool = Bool()
    var pro_pic = UIImage()
    var isEditKeyBool = Bool()
    var deleteBool = Bool()
    var addChildBool = Bool()
    var releaseChildBool = Bool()
    var releaseObj = KeyHolderObject()
    var profileBool = Bool()
    var profileObject = KeyHolderObject()
    var profile_pic = UIImage()

    
    
    
    
    var index = Int()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        phoneTextField.setBorder(width: 1, color: #colorLiteral(red: 0.9554988742, green: 0.9562225938, blue: 0.9556109309, alpha: 1), cornerRaidus: 2)
        verifyBtn.setBorder(width: 1, color: #colorLiteral(red: 0.9554988742, green: 0.9562225938, blue: 0.9556109309, alpha: 0), cornerRaidus: 39/2)
        
        phoneTextField.textFieldWithLeftView(width:35, icon:#imageLiteral(resourceName: "call"))
        
        
        if isEditBool || deleteBool || boolChecked {
            
            titleLabel.text = "A verification code has been sent to child email:"
        }
        
        if profileBool {
            
            emailLabel.text = profileObject.email
            phoneLabel.text = profileObject.phone
   
        }
        
        else {
           emailLabel.text = obj.email
           phoneLabel.text = obj.phone
        }
       
        
        
        // phoneTextField.text = obj.mobile_activation_code
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:-
    //MARK:- TextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func closeBtnAction(_ sender: Any) {
        
        noAction!()
        
    }
    
    
    @IBAction func verifyBtnAction(_ sender: Any) {
        
        verifyAction!()
        
        if isEditBool {
            
            verifyEditChildPhone()
        }
            
        else if boolChecked {
            
            verifyPhoneApi()
        }
        else if deleteBool {
            
            verifyDeletePhoneApi()
        }
            
            
        else if isEditKeyBool {
            
            verifyKeyHolderPhoneApi()
            
        }
            
        else if releaseChildBool {
            
            verifyReleaseChildPhoneApi()
            
        }
        
        else if profileBool {
            
            updateProfilePhoneVerifyApi()
        }
        
    }
    
    
    
    //MARK:-
    //MARK:- API Methods
    
    func verifyPhoneApi() {
        
        let phone:String = (phoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if phone.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter phone Otp", vc: self)
        }
            
        else {
            
            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]
                
                
                var parameters = [String: Any]()
                var action = String()
                if boolChecked {
                    action = "addChild"
                    parameters = ["child_id":obj.child_id,"action":action, "mobile_otp": phone]
                }
                else if deleteBool {
                    action = "deleteChild"
                    parameters = ["child_id":obj.child_id,"action":action, "mobile_otp": phone]

                    
                }
               
                
                
                if ProjectManager.sharedInstance.isInternetAvailable()
                {
                    ProjectManager.sharedInstance.showLoader()
                    
                    
                    Alamofire.request(baseURL + ApiMethods.verifyMobileOTP, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if status == 1 {
                                let msg = json["message"] as? String
                                
                                print(self.boolChecked)
                                
                                if self.boolChecked {
                                    
                                    
                                    UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                        
                                        //ProjectManager.sharedInstance.addedChildDelegate?.refreshAddedChild()
                                        
                                        //self.deleteChild(index: indexPath.row)
                                        
                                        let alertController = UIAlertController(title: "", message:msg, preferredStyle: .alert)
                                        
                                        // Create OK button
                                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                            
                                           
                                            UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                                            
                                        }
                                        alertController.addAction(OKAction)
                                        
                                        // Present Dialog message
                                        UIApplication.topViewController()?.present(alertController, animated: true, completion:nil)
                                        
                                        
                                        
                                    })
                                   
                                    
                                }
                                    
                                else {
                                    ProjectManager.sharedInstance.childDelegate?.refreshChildList(index: self.index)
                                    
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                }
                                
                                
                                
                                // self.dismiss(animated: true, completion: nil)
                            }
                            else {
                                
                                let msg = json["message"] as? String
                                
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                    }
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
    
    
    
    
    func verifyDeletePhoneApi() {
        
        let phone:String = (phoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if phone.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter phone Otp", vc: self)
        }
            
        else {
            
            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]
                
                
                var parameters = [String: Any]()
                var action = String()
               
               //if deleteBool {
                    action = "deleteChild"
                    parameters = ["child_id":obj.child_id,"action":action, "mobile_otp": phone]
                    
                    
               // }
                
                
                
                if ProjectManager.sharedInstance.isInternetAvailable()
                {
                    ProjectManager.sharedInstance.showLoader()
                    
                    
                    Alamofire.request(baseURL + ApiMethods.verifyMobileOTP, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if status == 1 {
                                let msg = json["message"] as? String
                                
                                print(self.boolChecked)
                                
                                ProjectManager.sharedInstance.childDelegate?.refreshChildList(index: self.index)
                                
                                
                                
                                
                                UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                    
                                    let alertController = UIAlertController(title: "", message:msg, preferredStyle: .alert)
                                    
                                    // Create OK button
                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                        
                                        // self.dismiss(animated: true, completion: nil)
                                        UIApplication.topViewController()?.dismiss(animated: true, completion: nil )
                                        
                                    }
                                    alertController.addAction(OKAction)
                                    
                                    // Present Dialog message
                                    UIApplication.topViewController()?.present(alertController, animated: true, completion:nil)
                                    
                                    
                                    
                                })
                                
                                
                              //  ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                              
                            }
                            else {
                                
                                let msg = json["message"] as? String
                                
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                    }
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
    
    
    
    
    
    
    
    
    func verifyEditChildPhone() {
        
        let phone:String = (phoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if phone.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter phone Otp", vc: self)
        }
            
        else {
            
            var parameters = [String: Any]()
            
            parameters = ["action":"updateChild","mobile_otp":phone, "child_id":obj.child_id, "name":obj.name, "email": obj.email, "dob":obj.dob,"phone_code":obj.country_code,"phone":obj.phone,"address":obj.address_line_1, "city":obj.city, "zip":obj.zip, "country":obj.country]
            
            let imgParam = "change_profile_pic"
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                ProjectManager.sharedInstance.callApiWithParameters(params:parameters, url:baseURL + ApiMethods.verifyMobileOTP, image: pro_pic, imageParam:imgParam) { (response, error) in
                    ProjectManager.sharedInstance.stopLoader()
                    
                    
                    if response != nil {
                        if let status = response?["status"] as? NSNumber {
                            let message = response?["message"] as? String
                            if status == 1 {
                                
                                UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                    
                                    let alertController = UIAlertController(title: "", message:message, preferredStyle: .alert)
                                    
                                    // Create OK button
                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                        
                                       // self.dismiss(animated: true, completion: nil)
                                        UIApplication.topViewController()?.dismiss(animated: true, completion: nil )
                                        
                                    }
                                    alertController.addAction(OKAction)
                                    
                                    // Present Dialog message
                                    UIApplication.topViewController()?.present(alertController, animated: true, completion:nil)
                                    
                                    
                                    
                                })
                                
                               
                            }
                            else {
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: message!, vc: UIApplication.topViewController()!)
                                
                            }
                        }
                    }
                        
                    else {
                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Server Error", vc: UIApplication.topViewController()!)
                    }
                }
            }
                
            else {
                DispatchQueue.main.async(execute: {
                    
                    ProjectManager.sharedInstance.stopLoader()
                    ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                })
            }
            
        }
    }
    
    
    func verifyKeyHolderPhoneApi() {
        
        let phone:String = (phoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if phone.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter phone Otp", vc: self)
        }
            
        else {
            
            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]
                
                
                var parameters = [String: Any]()
                
                if obj.release_type == "ondate" {
                    
                    parameters = ["action":"editKeyholder","mobile_otp":phone,"receiver_id":obj.receiver_id, "access_dirs":obj.access_dirs, "release_type": obj.release_type, "release_date":obj.release_date]
                    
                }
                    
                else  if obj.release_type == "ondeath" {
                    
                    parameters = ["action":"editKeyholder","mobile_otp":phone,"receiver_id":obj.receiver_id, "access_dirs":obj.access_dirs, "release_type": obj.release_type]
                    
                }
                
                
                
                if ProjectManager.sharedInstance.isInternetAvailable()
                {
                    ProjectManager.sharedInstance.showLoader()
                    
                    
                    Alamofire.request(baseURL + ApiMethods.verifyMobileOTP, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                let msg = json["message"] as? String
                                
                                UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                    
                                    
                                    let alertController = UIAlertController(title: "", message:msg, preferredStyle: .alert)
                                    
                                    // Create OK button
                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                        
                                        //self.dismiss(animated: true, completion: nil)
                                        
                                        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                                        
                                    }
                                    alertController.addAction(OKAction)
                                    
                                    // Present Dialog message
                                    UIApplication.topViewController()?.present(alertController, animated: true, completion:nil)
                                    
                                    
                                    
                                    
                                })
                                
                                
                               
                                
                                // self.dismiss(animated: true, completion: nil)
                            }
                            else {
                                
                                
                                let msg = json["message"] as? String
                                
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                                
                            }
                    }
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
    
    
    func verifyReleaseChildPhoneApi() {
        
        let phone:String = (phoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if phone.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter phone Otp", vc: self)
        }
            
        else {
            
            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]
                
                var parameters = [String: Any]()
                
                parameters = ["action":"releaseChild","mobile_otp":phone,"child_id":releaseObj.id]
                
                
                
                if ProjectManager.sharedInstance.isInternetAvailable()
                {
                    ProjectManager.sharedInstance.showLoader()
                    
                    
                    Alamofire.request(baseURL + ApiMethods.verifyMobileOTP, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if status == 1 {
                                
                                ProjectManager.sharedInstance.releaseDelegate?.changeReleaseChildStatus()
                                
                                
                                self.dismiss(animated: true, completion: {
                                    
                                    let msg = json["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                    
                                })
                                
                                
                                
                            }
                            else {
                                
                                
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                    }
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
    
    
    func updateProfilePhoneVerifyApi() {
        
        let phone:String = (phoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if phone.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter phone Otp", vc: self)
        }
            
        else {
            
            var parameters = [String: Any]()
            
             parameters = ["action":"updateProfile","mobile_otp":phone,"name":profileObject.name, "email": profileObject.email, "dob":profileObject.dob,"phone_code":profileObject.country_code,"phone":profileObject.phone,"address":profileObject.address_line_1, "city":profileObject.city, "zip":profileObject.zip, "country":profileObject.country, "password":"", "enable_diary_mode":"","make_public":""]
            
            let imgParam = "change_profile_pic"
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                ProjectManager.sharedInstance.callApiWithParameters(params:parameters, url:baseURL + ApiMethods.verifyMobileOTP, image: pro_pic, imageParam:imgParam) { (response, error) in
                    ProjectManager.sharedInstance.stopLoader()
                    
                    
                    if response != nil {
                        if let status = response?["status"] as? NSNumber {
                            let message = response?["message"] as? String
                            if status == 1 {
                                
                                UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                    
                                    
                                    let alertController = UIAlertController(title: "", message:message, preferredStyle: .alert)
                                    
                                    // Create OK button
                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                        
                                        self.dismiss(animated: true, completion: nil)
                                        
                                    }
                                    alertController.addAction(OKAction)
                                    
                                    // Present Dialog message
                                    UIApplication.topViewController()?.present(alertController, animated: true, completion:nil)
                                    
                                    
                                })
                                
                               
                                
                            }
                            else {
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: message!, vc: UIApplication.topViewController()!)
                                
                            }
                        }
                    }
                        
                    else {
                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Server Error", vc: UIApplication.topViewController()!)
                    }
                }
            }
                
            else {
                DispatchQueue.main.async(execute: {
                    
                    ProjectManager.sharedInstance.stopLoader()
                    ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                })
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
