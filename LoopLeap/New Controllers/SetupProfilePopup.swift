//
//  SetupProfilePopup.swift
//  LoopLeap
//
//  Created by iOS6 on 05/04/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import Photos
import PopupDialog
import IQKeyboardManagerSwift
import AVKit

class SetupProfilePopup: UIViewController,UITextFieldDelegate, CountryListDelegate
{
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
    
    @IBOutlet weak var registeredPhoneTextField: UITextField!
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
    var child_Id = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        popupView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 6)
        emailTextField.setBorder(width: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRaidus: 2)
        registeredPhoneTextField.setBorder(width: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRaidus: 2)
        sendBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 16)
        countryCodeView.setBorder(width: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRaidus: 2)
        registeredPhoneTextField.textFieldWithLeftView(width:35, icon:#imageLiteral(resourceName: "Phone-icon copy"))
        emailTextField.textFieldWithLeftView(width:35, icon:#imageLiteral(resourceName: "Email-icon"))

        
        countryList.delegate = self
        registeredPhoneTextField.delegate = self
        
        countryCodeTextField.text =  "🇺🇸 +1"
        phoneExtension = "+1"
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:-
    //MARK:- TextField Delegate Methods
    
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
        setupChildApi()
        
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
    
    //MARK:-
    //MARK:- API Methods
    
    func setupChildApi() {
        
        
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let phone:String = (registeredPhoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
         let countryCode:String = (countryCodeTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        self.view.endEditing(true)
        
         if email.isEmpty {
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
            
        else {
            
           
  
                let str =  countryCode
                let split = str.split(separator: " ")
                let code    = String(split.suffix(1).joined(separator: [" "]))
                print(code)
                
                
                var parameters = [String: Any]()
                
                parameters = ["child_id":child_Id, "email":email, "phone":phone, "phone_code":code ]
                
                
                if ProjectManager.sharedInstance.isInternetAvailable()
                {
                    ProjectManager.sharedInstance.showLoader()
                    
                    
                    Alamofire.request(baseURL + ApiMethods.setUpChild, method: .post,  parameters: parameters, encoding: JSONEncoding.default)
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
//                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                    
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
