//
//  LoginViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 13/09/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import PopupDialog
import AssetsPickerViewController
import Photos
import AVFoundation
import AVKit
import MediaPlayer

class LoginViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
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
        self.loginBtn.layer.cornerRadius = 22.3
        self.loginBtn.layer.masksToBounds = true
        self.emailTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "Email-icon"))
        self.passwordTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "Password-icon"))
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
    
    @IBAction func loginAction(_ sender: Any) {
        self.view.endEditing(true)
       
        let email:String = (emailTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let password:String = (passwordTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email", vc: self)
        }
        else if !ProjectManager.sharedInstance.isEmailValid(email: email) {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Invalid email", vc: self)
        }
        else if password.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter password", vc: self)
        }
        else if password.count < 8 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 8 characters password", vc: self)
        }
        else {
            ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWithoutHeader(params:[ "email":email,"password":password ], url:baseURL + ApiMethods.loginAPI, image:nil, imageParam:"") { (response, error) in
                ProjectManager.sharedInstance.stopLoader()
                if response != nil {
                    if let status = response?["status"] as? NSNumber {
                        if status == 0 {

                            let msg = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "message", dict: response!)

                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg as String, vc: UIApplication.topViewController()!)
                                        return

                            
                        }

                        else {
                            
                            UserDefaults.standard.set(false, forKey: "isShowPopup")
                            UserDefaults.standard.synchronize()

                            if  let access_token = response?["access_token"] as? String {
                               // let userID =
                                //ProjectManager.sharedInstance.checkResponseForString(jsonKey:"enc_user_id", dict: data )
                                let token_type =  response?["token_type"] as? String
                                UserDefaults.standard.set("Bearer ", forKey:DefaultsIdentifier.token_type)
                                UserDefaults.standard.set("login", forKey:DefaultsIdentifier.login)
                                UserDefaults.standard.set(access_token, forKey:DefaultsIdentifier.access_token)
                                UserDefaults.standard.set(access_token, forKey: DefaultsIdentifier.parent_id)
                                
                                 UserDefaults.standard.set(access_token, forKey:DefaultsIdentifier.parent_access_token)
                                UserDefaults.standard.synchronize()
                                ProjectManager.sharedInstance.saveDeviceTokenOnServer()
     
                            }
                            //if let msg = response?["message"] as? String {
                            
                            
                            

//                                let vc:HomeViewController = self.storyboard?.instantiateViewController(withIdentifier:"HomeViewController") as! HomeViewController
//                                self.navigationController?.pushViewController(vc, animated: true)
                            
                            let paymenStatus = response?["payment_status"] as? Int
                            
                            if paymenStatus == 0 {
                                
                                let vc:UpdatePlanViewController = self.storyboard?.instantiateViewController(withIdentifier:"UpdatePlanViewController") as! UpdatePlanViewController
                               
                                vc.cancelStatusBool = true
                                
                                self.present(vc, animated: true, completion: nil)
                               
                            }
                            
                            else {
                                
                                    let msg = response?["message"] as? String
                                    
                                    let alert = UIAlertController(title: "", message: msg!, preferredStyle: .alert)
                                    
                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                        
                                        
                                        let vc:TimeLineHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier:"TimeLineHistoryViewController") as! TimeLineHistoryViewController
                                        
                                        
                                        
                                        let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
                                        
                                        let window = UIApplication.shared.delegate?.window
                                        // window = UIWindow(frame: UIScreen.main.bounds)
                                        window!!.rootViewController = SideMenuController(contentViewController: vc,
                                                                                         menuViewController: menuViewController)
                                        
                                    }
                                    
                                    // self.showPopups()
                                    
                                    alert.addAction(OKAction)
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                            
                            
//                            let msg = response?["message"] as? String
//                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            
                          
                            }

                        }


//                        else {
//
//                            if  let data = response?["data"] as? [String:Any] {
//                                let userID = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"enc_user_id", dict: data )
//
//                            UserDefaults.standard.set("login", forKey:DefaultsIdentifier.login)
//                            UserDefaults.standard.set(userID, forKey:DefaultsIdentifier.userID)
//                            UserDefaults.standard.synchronize()
//                          ProjectManager.sharedInstance.saveDeviceTokenOnServer()
//                            }
//                            if let msg = response?["message"] as? String {
//
//                                let vc:HomeViewController = self.storyboard?.instantiateViewController(withIdentifier:"HomeViewController") as! HomeViewController
//                                self.navigationController?.pushViewController(vc, animated: true)
//
//
//                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg, vc: UIApplication.topViewController()!)
//                            }
//
//                        }
                    }
                    
                    
                }
                
                
            }
            
        }
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
    }
    @IBAction func signUpAction(_ sender: Any) {
    }
    
    
   
    func showPopups()
    {
        
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            //ProjectManager.sharedInstance.showLoader()
            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]
                //let parameters = ["user_id": userId]
                
                Alamofire.request(baseURL + ApiMethods.startquestionnaire, method: .post,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
                    .responseJSON { response in
                        
                        //ProjectManager.sharedInstance.stopLoader()
                        
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
                        
                        let status = json["status"] as? Bool
                        if status == true
                        {
                            DispatchQueue.main.async {
                                let alertVC :QuestionnairePopup = (self.storyboard?.instantiateViewController(withIdentifier: "QuestionnairePopup") as? QuestionnairePopup)!
                                
                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                , tapGestureDismissal: false, panGestureDismissal: false) {
                                    let overlayAppearance = PopupDialogOverlayView.appearance()
                                    overlayAppearance.blurRadius  = 30
                                    overlayAppearance.blurEnabled = true
                                    overlayAppearance.liveBlur    = false
                                    overlayAppearance.opacity     = 0.4
                                }
                                
                                alertVC.noAction = {
                                    
                                    popup.dismiss({
                                        
                                        
                                    })
                                }
                                
                                alertVC.yesAcion = {
                                    
                                    popup.dismiss({
                                        
                                        let vc:NumberOfQuestionsViewController = self.storyboard?.instantiateViewController(withIdentifier:"NumberOfQuestionsViewController") as! NumberOfQuestionsViewController
                                        
                                        
                                        
                                        self.present(vc, animated: true, completion: nil)
                                        //self.navigationController?.pushViewController(vc, animated: true)
                                        
                                        
                                    })
                                }
                                
                                self.present(popup, animated: true, completion: nil)
                                
                                
                                
                                
                            }
                            
                        }
                            
                        else
                        {
                            let statusCode = json["statusCode"] as? Int
                            if statusCode == 1
                            {
                                
                                let alertVC :TellAboutYourselfPopup = (self.storyboard?.instantiateViewController(withIdentifier: "TellAboutYourselfPopup") as? TellAboutYourselfPopup)!
                                
                                
                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                , tapGestureDismissal: false, panGestureDismissal: false) {
                                    let overlayAppearance = PopupDialogOverlayView.appearance()
                                    overlayAppearance.blurRadius  = 30
                                    overlayAppearance.blurEnabled = true
                                    overlayAppearance.liveBlur    = false
                                    overlayAppearance.opacity     = 0.4
                                }
                                
                                alertVC.noAction = {
                                    
                                    popup.dismiss({
                                        
                                        
                                    })
                                }
                                
                                alertVC.yesAcion = {
                                    
                                    popup.dismiss({
                                        
                                        let vc:TellAboutYourselfViewController = self.storyboard?.instantiateViewController(withIdentifier:"TellAboutYourselfViewController") as! TellAboutYourselfViewController
                                        
                                        
                                        self.present(vc, animated: true, completion: nil)
                                        //self.navigationController?.pushViewController(vc, animated: true)
                                        
                                        
                                    })
                                }
                                
                                UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                                
                            }
                                
                            else if statusCode == 4
                            {
                                self.LogoutApi()
                                let alert = UIAlertController(title: "", message:"Your account is deactivated" , preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                        }
                        
                        
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
    
    func LogoutApi()
    {
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                
                Alamofire.request(baseURL + ApiMethods.logout, method: .post,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
                    .responseJSON { response in
                        
                        ProjectManager.sharedInstance.stopLoader()
                        
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            if response != nil {
                                let alert = UIAlertController(title: "", message: response.result.error! as! String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
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
                        let status = json["status"] as? NSNumber
                        if status == 1 {
                            
                            UserDefaults.standard.set("logout", forKey:DefaultsIdentifier.login)
                            UserDefaults.standard.synchronize()
                            
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            let vc:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            let nav = UINavigationController(rootViewController: vc)
                            appdelegate.window?.rootViewController = nav
                            
                            let msg = json["message"] as? String
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            
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
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
