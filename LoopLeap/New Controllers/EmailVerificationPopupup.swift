//
//  EmailVerificationPopupup.swift
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


class EmailVerificationPopupup: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    
    var verifyAction :blockAction?
    var noAction : blockAction?
    var obj = KeyHolderObject()
    var boolChecked = Bool()
    var isEditBool = Bool()
    var pro_pic = UIImage()
    var isEditKeyHolderBool = Bool()
    var addChildBool = true
    
    var deleteBool = Bool()
    var releaseChildBool = Bool()
    var releaseObj = KeyHolderObject()
    var profileBool = Bool()
    var profileObject = KeyHolderObject()
    var profile_pic = UIImage()


    
    
    var index = Int()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        emailTextField.setBorder(width: 1, color: #colorLiteral(red: 0.9554988742, green: 0.9562225938, blue: 0.9556109309, alpha: 1), cornerRaidus: 2)
        
        verifyBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 39/2)
        
        emailTextField.textFieldWithLeftView(width:35, icon:#imageLiteral(resourceName: "Email-icon"))
        
        if isEditBool || deleteBool || boolChecked || releaseChildBool {
            
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
       // emailTextField.text = obj.email_activation_code
        
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
            
            verifyEditChildEmail()
        }
            
        else if boolChecked {
            
            verifyEmailApi()
        }
            
        else if deleteBool {
            
            verifyDeleteEmailApi()

        }
        
        else if isEditKeyHolderBool {
            
            verifyKeyHolderApi()
            
        }
        
        else if releaseChildBool {
            
            verifyReleaseChildEmailApi()
            
        }
        
        else if profileBool {
            
            updateProfileEmailVerifyApi()
        }
        
        
    }
    
    
    //MARK:-
    //MARK:- API Methods

    
    func verifyEmailApi() {
        
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email Otp", vc: self)
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
                
                  parameters = ["child_id":obj.child_id,"action":action,"email_otp":email]
            }
            else if deleteBool {
                action = "deleteChild"
                
                 parameters = ["child_id":obj.child_id,"action":action,"email_otp":email]
            }
           
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.verifyOTP, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            
                            
                            UIApplication.topViewController()?.dismiss(animated: true, completion:
                                
                                {
                                    
                                    if self.deleteBool {
                                        
                                        ProjectManager.sharedInstance.childDelegate?.refreshChildList(index: self.index)
                                    }
                                    
                                    
                                 
                                    let msg = json["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                            }
                                
                                 /*  Phone Verification   */
                                
//                                {
//
//
//                                let alertVC :PhoneVerificationPopup = (self.storyboard?.instantiateViewController(withIdentifier: "PhoneVerificationPopup") as? PhoneVerificationPopup)!
//
//                                alertVC.obj = self.obj
//                                alertVC.index = self.index
//
//                                if self.boolChecked {
//
//                                    alertVC.boolChecked = true
//
//                                }
//                                else {
//                                    //if self.boolChecked {
//                                    alertVC.deleteBool = true  //  self.addChildBool
//                                    //}
//                                }
//
//
//                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
//                                , tapGestureDismissal: false, panGestureDismissal: false) {
//                                    let overlayAppearance = PopupDialogOverlayView.appearance()
//                                    overlayAppearance.blurRadius  = 30
//                                    overlayAppearance.blurEnabled = true
//                                    overlayAppearance.liveBlur    = false
//                                    overlayAppearance.opacity     = 0.4
//                                }
//
//                                alertVC.verifyAction = {
//
////                                    popup.dismiss({
////
////                                        // self.navigationController?.popViewController(animated: true)
////
////                                    })
//
//
//                                }
//
//                                alertVC.noAction = {
//
//                                    popup.dismiss({
//
//                                        // self.navigationController?.popViewController(animated: true)
//
//                                    })
//
//                                }
//
//                                UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
//
//
//
//                            }
                        )
                            
                           
                            
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
    
    
    
    
    
    func verifyDeleteEmailApi() {
        
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email Otp", vc: self)
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
                
                // if deleteBool {
                    action = "deleteChild"
                    
                    parameters = ["child_id":obj.child_id,"action":action,"email_otp":email]
              //  }
                
                
                
                if ProjectManager.sharedInstance.isInternetAvailable()
                {
                    ProjectManager.sharedInstance.showLoader()
                    
                    
                    Alamofire.request(baseURL + ApiMethods.verifyOTP, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                ProjectManager.sharedInstance.childDelegate?.refreshChildList(index: self.index)
                                
                                UIApplication.topViewController()?.dismiss(animated: true, completion:
                                    
                                    {
                                        
                                        let msg = json["message"] as? String
                                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                        
                                }
                                    
                                     /*  Phone Verification   */
//                                    {
//
//
//                                    let alertVC :PhoneVerificationPopup = (self.storyboard?.instantiateViewController(withIdentifier: "PhoneVerificationPopup") as? PhoneVerificationPopup)!
//
//                                    alertVC.obj = self.obj
//                                    alertVC.index = self.index
//                                    alertVC.deleteBool = true
//
//                                    let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
//                                    , tapGestureDismissal: false, panGestureDismissal: false) {
//                                        let overlayAppearance = PopupDialogOverlayView.appearance()
//                                        overlayAppearance.blurRadius  = 30
//                                        overlayAppearance.blurEnabled = true
//                                        overlayAppearance.liveBlur    = false
//                                        overlayAppearance.opacity     = 0.4
//                                    }
//
//                                    alertVC.verifyAction = {
//
//                                        //                                    popup.dismiss({
//                                        //
//                                        //                                        // self.navigationController?.popViewController(animated: true)
//                                        //
//                                        //                                    })
//
//
//                                    }
//
//                                    alertVC.noAction = {
//
//                                        popup.dismiss({
//
//                                            // self.navigationController?.popViewController(animated: true)
//
//                                        })
//
//                                    }
//
//                                    UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
//
//
//
//                                }
                            )
                                
                                
                                
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
    
    
    
    
    
    
    
    
    func verifyEditChildEmail() {
        
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email Otp", vc: self)
        }
            
        else {
        
        var parameters = [String: Any]()
        
        parameters = ["action":"updateChild","email_otp":email,"child_id":obj.child_id, "name":obj.name, "email": obj.email, "dob":obj.dob,"phone_code":obj.country_code,"phone":obj.phone,"address":obj.address_line_1, "city":obj.city, "zip":obj.zip, "country":obj.country]
        
        let imgParam = "change_profile_pic"
        
        
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            ProjectManager.sharedInstance.showLoader()
            
            
            ProjectManager.sharedInstance.callApiWithParameters(params:parameters, url:baseURL + ApiMethods.verifyOTP, image: pro_pic, imageParam:imgParam) { (response, error) in
                ProjectManager.sharedInstance.stopLoader()
                
                
                if response != nil {
                    if let status = response?["status"] as? NSNumber {
                        let message = response?["message"] as? String
                        if status == 1 {
                            
                            
                            UIApplication.topViewController()?.dismiss(animated: true, completion:
                                
                                {
                                    
                                    let msg = response?["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                            }
                                
                                /*  Phone Verification   */
                                
//                                {
//
//
//                                let alertVC :PhoneVerificationPopup = (self.storyboard?.instantiateViewController(withIdentifier: "PhoneVerificationPopup") as? PhoneVerificationPopup)!
//
//                                alertVC.obj = self.obj
//                                alertVC.index = self.index
//                                alertVC.isEditBool = self.isEditBool
//                                alertVC.pro_pic = self.pro_pic
//
//                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
//                                , tapGestureDismissal: false, panGestureDismissal: false) {
//                                    let overlayAppearance = PopupDialogOverlayView.appearance()
//                                    overlayAppearance.blurRadius  = 30
//                                    overlayAppearance.blurEnabled = true
//                                    overlayAppearance.liveBlur    = false
//                                    overlayAppearance.opacity     = 0.4
//                                }
//
//                                alertVC.verifyAction = {
//
//
//
//
//                                }
//
//                                alertVC.noAction = {
//
//                                    popup.dismiss({
//
//                                        // self.navigationController?.popViewController(animated: true)
//
//                                    })
//
//                                }
//
//                                UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
//
//
//
//
//                            }
                            
                        )
                            
                           
                            
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
    
    func verifyKeyHolderApi() {
        
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email Otp", vc: self)
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
            
            parameters = ["action":"editKeyholder","email_otp":email,"receiver_id":obj.receiver_id, "access_dirs":obj.access_dirs, "release_type": obj.release_type, "release_date":obj.release_date]
                
            }
            
            else if obj.release_type == "ondeath" {
                
                 parameters = ["action":"editKeyholder","email_otp":email,"receiver_id":obj.receiver_id, "access_dirs":obj.access_dirs, "release_type": obj.release_type]
                
            }
          
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.verifyOTP, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            
                            UIApplication.topViewController()?.dismiss(animated: true, completion:
                                
                                {
                                    let msg = json["message"] as? String
                                    
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                              }
                          
                             /*  Phone Verification   */
                                
//                                {
//
//
//                                let alertVC :PhoneVerificationPopup = (self.storyboard?.instantiateViewController(withIdentifier: "PhoneVerificationPopup") as? PhoneVerificationPopup)!
//
//                                alertVC.obj = self.obj
//                                //alertVC.index = self.index
//                                alertVC.isEditKeyBool = true
//
//                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
//                                , tapGestureDismissal: false, panGestureDismissal: false) {
//                                    let overlayAppearance = PopupDialogOverlayView.appearance()
//                                    overlayAppearance.blurRadius  = 30
//                                    overlayAppearance.blurEnabled = true
//                                    overlayAppearance.liveBlur    = false
//                                    overlayAppearance.opacity     = 0.4
//                                }
//
//                                alertVC.verifyAction = {
//
////                                    popup.dismiss({
////
////                                        // self.navigationController?.popViewController(animated: true)
////
////                                    })
////
//
//                                }
//
//                                alertVC.noAction = {
//
//                                    popup.dismiss({
//
//                                        // self.navigationController?.popViewController(animated: true)
//
//                                    })
//
//                                }
//
//                                UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
//
//
//
//
//                              }
                            )
                            
                          
                            
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
    
    
    func verifyReleaseChildEmailApi() {
    
       let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
 
        if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email Otp", vc: self)
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
            
            parameters = ["action":"releaseChild","email_otp":email,"child_id":releaseObj.id]
            
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.verifyOTP, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            
//                            let alertVC :PhoneVerificationPopup = (self.storyboard?.instantiateViewController(withIdentifier: "PhoneVerificationPopup") as? PhoneVerificationPopup)!
//
//                            alertVC.releaseObj = self.releaseObj
//                            alertVC.index = self.index
//                            alertVC.releaseChildBool = true
//                            alertVC.obj = self.releaseObj

                            
                            ProjectManager.sharedInstance.releaseDelegate?.changeReleaseChildStatus()
                            
                            self.dismiss(animated: true, completion:
                            
                                {
                                    let msg = json["message"] as? String
                                    
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            }
                                
                            )
                            
                             /*  Phone Verification   */
                                
//                                {
//
//
//                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
//                                , tapGestureDismissal: false, panGestureDismissal: false) {
//                                    let overlayAppearance = PopupDialogOverlayView.appearance()
//                                    overlayAppearance.blurRadius  = 30
//                                    overlayAppearance.blurEnabled = true
//                                    overlayAppearance.liveBlur    = false
//                                    overlayAppearance.opacity     = 0.4
//                                }
//
//                                alertVC.verifyAction = {
//
//
//                                }
//
//                                alertVC.noAction = {
//
//                                    popup.dismiss({
//
//                                        // self.navigationController?.popViewController(animated: true)
//
//                                    })
//
//                                }
//
//                                UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
//
//
//
//
//                            }
                            
                           
                            
                           
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
    
    
    func updateProfileEmailVerifyApi() {
        
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email Otp", vc: self)
        }
            
        else {
            
            var parameters = [String: Any]()
            
            parameters = ["action":"updateProfile","email_otp":email,"name":profileObject.name, "email": profileObject.email, "dob":profileObject.dob,"phone_code":profileObject.country_code,"phone":profileObject.phone,"address":profileObject.address_line_1, "city":profileObject.city, "zip":profileObject.zip, "country":profileObject.country, "password":"", "enable_diary_mode":"","make_public":""]
            
            let imgParam = "change_profile_pic"
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                ProjectManager.sharedInstance.callApiWithParameters(params:parameters, url:baseURL + ApiMethods.verifyOTP, image: pro_pic, imageParam:imgParam) { (response, error) in
                    ProjectManager.sharedInstance.stopLoader()
                    
                    
                    if response != nil {
                        if let status = response?["status"] as? NSNumber {
                            let message = response?["message"] as? String
                            if status == 1 {
                                
                                self.dismiss(animated: true, completion:
                                    
                                    {
                                        let msg = response?["message"] as? String
                                        
                                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                }
                                    
                                )
                                
                                /*  Phone Verification   */
                                    
//                                    {
//
//
//                                    let alertVC :PhoneVerificationPopup = (self.storyboard?.instantiateViewController(withIdentifier: "PhoneVerificationPopup") as? PhoneVerificationPopup)!
//
//                                    alertVC.profileObject = self.profileObject
//                                    alertVC.profileBool = true
//                                    alertVC.profile_pic = self.profile_pic
//
//                                    let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
//                                    , tapGestureDismissal: false, panGestureDismissal: false) {
//                                        let overlayAppearance = PopupDialogOverlayView.appearance()
//                                        overlayAppearance.blurRadius  = 30
//                                        overlayAppearance.blurEnabled = true
//                                        overlayAppearance.liveBlur    = false
//                                        overlayAppearance.opacity     = 0.4
//                                    }
//
//                                    alertVC.verifyAction = {
//
//                                        //                                    popup.dismiss({
//                                        //
//                                        //                                        // self.navigationController?.popViewController(animated: true)
//                                        //
//                                        //                                    })
//
//                                    }
//
//                                    alertVC.noAction = {
//
//                                        popup.dismiss({
//
//                                            // self.navigationController?.popViewController(animated: true)
//
//                                        })
//
//                                    }
//
//                                    UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
//
//
//
//                                }
                                
//                            )
                                
                               
                                
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

