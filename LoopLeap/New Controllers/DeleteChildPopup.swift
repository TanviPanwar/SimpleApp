//
//  DeleteChildPopup.swift
//  LoopLeap
//
//  Created by iOS6 on 14/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import Photos
import PopupDialog
import IQKeyboardManagerSwift
import AVKit

class DeleteChildPopup: UIViewController, UITextFieldDelegate, CountryListDelegate
{
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
    
    @IBOutlet weak var registeredPhoneTextField: UITextField!
    @IBOutlet weak var registeredEmailTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var sendAction :blockAction?
    var  noAction : blockAction?
    var countryList = CountryList()
    var isCountryCode = Bool()
    var countryCode = String()
    var phoneExtension = String()
    var obj = KeyHolderObject()
    var activationObject = KeyHolderObject()
    var index = Int()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        popupView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 6)
        registeredPhoneTextField.setBorder(width: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRaidus: 2)
        sendBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 16)
        countryCodeView.setBorder(width: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRaidus: 2)
         registeredPhoneTextField.textFieldWithLeftView(width:35, icon:#imageLiteral(resourceName: "Phone-icon copy"))
        
        countryList.delegate = self
        registeredPhoneTextField.delegate = self
 
        countryCodeTextField.text =  "🇺🇸 +1"
        phoneExtension = "+1"
        
       // registeredPhoneTextField.text = obj.phone
       // countryCodeTextField.text = obj.country_code
        

        // Do any additional setup after loading the view.
    }
    
    //MARK:-
    //MARK:- Textfield Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.noAction!()
        
    }
    
    @IBAction func countryCodeBtnAction(_ sender: Any) {
        
        isCountryCode = false
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
        self.sendAction!()
        deleteChild()
    }
    
    //MARK:-
    //MARK:- API Methods
    
    func deleteChild() {
        
        let email:String = (registeredEmailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
         if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email", vc: self)
        }
            
        else if !ProjectManager.sharedInstance.isEmailValid(email: email) {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Invalid email", vc: self)
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
            
            let str =  countryCodeTextField.text
            let split = str!.split(separator: " ")
            let last    = String(split.suffix(1).joined(separator: [" "]))
            print(last)
            
            var parameters = [String: Any]()
            parameters = ["child_id": obj.id, "email": email] // "phone_code":last, "phone":phone
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.deleteChild, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            
                            if let data = json["data"] as? [String: Any] {
                            self.activationObject = ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)
                                
                                print(self.activationObject)
                                
                                
                                UIApplication.topViewController()?.dismiss(animated: true, completion: {
 
                            let alertVC :EmailVerificationPopupup = (self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationPopupup") as? EmailVerificationPopupup)!
                            
                                alertVC.obj = self.activationObject
                                alertVC.index = self.index
                                
                                alertVC.deleteBool = true
 
                            let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                            , tapGestureDismissal: false, panGestureDismissal: false) {
                                let overlayAppearance = PopupDialogOverlayView.appearance()
                                overlayAppearance.blurRadius  = 30
                                overlayAppearance.blurEnabled = true
                                overlayAppearance.liveBlur    = false
                                overlayAppearance.opacity     = 0.4
                            }
                           
                            alertVC.verifyAction = {
                                
//                                popup.dismiss({
//                                    
//                                    // self.navigationController?.popViewController(animated: true)
//                                    
//                                })
//                                
                                
                            }
                            
                            alertVC.noAction = {
                                
                                popup.dismiss({
                                    
                                    // self.navigationController?.popViewController(animated: true)
                                    
                                })
                                
                                
                            }
                            
                            UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                                    
                                })
                            
                        }
                            
                            else {
                                
                                print("No data found")
                            }
                            
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
    
    
    //MARK:-
    //MARK:- Country Delegate
    func selectedCountry(country: Country) {
        
        if isCountryCode {
            countryCodeTextField.text = "\(country.flag!) +\(country.phoneExtension)" // + "\(country.name!)"
           // countryCodeTextField.text = "\(country.name!)"
            phoneExtension = "+\(country.phoneExtension)"
        }
        else {
            //countryCodeTextField.text = "\(country.name!)"
            countryCodeTextField.text = "\(country.flag!) +\(country.phoneExtension)" // + " " + "\(country.name!)"
            countryCode = country.countryCode
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
