//
//  PaymentScreenViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 20/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

protocol ActiveStatusDelegate {
    
    func getActiveStatus(status: String)
    
}


class PaymentScreenViewController: UIViewController, STPPaymentCardTextFieldDelegate, UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var payNowBtn: UIButton!
    
     let cardParams = STPCardParams()
     var planId = String()
     var planOrder = String()
     var delegate : ActiveStatusDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:-
    //MARK:- TextField Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       if textField == expiryDateTextField {
        
        if range.length > 0 {
            return true
        }
        if string == "" {
            return false
        }
        if range.location > 4 {
            return false
        }
        var originalText = textField.text
        let replacementText = string.replacingOccurrences(of: " ", with: "")
        
        //Verify entered text is a numeric value
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText)) {
            return false
        }
        
        //Put / after 2 digit
        if range.location == 2 {
            originalText?.append("/")
            textField.text = originalText
        }
            
        }

        else if textField == cardHolderNameTextField {
        
        if range.location > 49 {
            return false
        }

        }

        else if textField == cardNumberTextField {

        if range.location > 15 {
            return false
        }
        
        }
        
       else if  textField == cvvTextField {
        
        if range.location > 2 {
            return false
        }
        
       }

        else {


        }
        
        return true
    }
    
    func paymentCardTextFieldDidChange(_ textField: UITextField) {

       // self.payNowBtn.isEnabled = textField.isValid
        
        
        
        if payNowBtn.isEnabled {
            payNowBtn.backgroundColor = UIColor.blue
            cardParams.number = cardHolderNameTextField.text
            
            let delimiter = "/"
            let newstr = expiryDateTextField.text
            var price = newstr!.components(separatedBy: delimiter)
            print (price[0])
            cardParams.expMonth =  UInt(price[0])!
            
            let snippet =  expiryDateTextField.text
            var decimalPrice = String()
            if let range = snippet!.range(of: "/") {
                decimalPrice =  snippet![range.upperBound...].trimmingCharacters(in: .whitespaces)
                print(decimalPrice) // prints "123.456.7891"
            }

            cardParams.expYear = UInt(decimalPrice)!
            cardParams.cvc = cvvTextField.text
        }
    }
    
   
    
    //MARK:-
    //MARK:- IB Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func payNowBtnAction(_ sender: Any) {

         let nameStr:String = (cardHolderNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
         let numberStr:String = (cardNumberTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
         let expiryDateStr:String = (expiryDateTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
         let cvvStr:String = (cvvTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
         self.view.endEditing(true)
        if nameStr.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter name", vc: self)
        }
        
        else if nameStr.count < 3 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 3 characters name", vc: self)
        }
        
        else if numberStr.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter card number", vc: self)
        }
            
        else if numberStr.count < 16 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter 16 digits card number", vc: self)
        }
        else if expiryDateStr.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter expiry date", vc: self)
        }
        else if expiryDateStr.count < 5 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter 4 digits expiry date", vc: self)
        }
            
        else if cvvStr.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter cvv number", vc: self)
        }
        else if cvvStr.count < 3 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter 3 digits cvv number", vc: self)
        }
        
        else {
             ProjectManager.sharedInstance.showLoader()
        
             cardParams.number = cardNumberTextField.text
            
            let delimiter = "/"
            let newstr = expiryDateTextField.text
            var price = newstr!.components(separatedBy: delimiter)
            print (price[0])
            cardParams.expMonth =  UInt(price[0])!
            
            let snippet =  expiryDateTextField.text
            var decimalPrice = String()
            if let range = snippet!.range(of: "/") {
                decimalPrice =  snippet![range.upperBound...].trimmingCharacters(in: .whitespaces)
                print(decimalPrice) // prints "123.456.7891"
          }
            
            cardParams.expYear = UInt(decimalPrice)!
            cardParams.cvc = cvvTextField.text
     
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let error = error {
                // show the error to the user
                 ProjectManager.sharedInstance.stopLoader()
                print(error)
                self.showAlertButtonTapped(strTitle: "Error", strMessage: error.localizedDescription)
            } else if let token = token {
                print(token)
                self.getPaymentTokenApi(token: "\(token)")
                //Send token to backend for process
            }
        }
            
    }
        
    }
    
    
    //MARK:- AlerViewController
    func showAlertButtonTapped(strTitle:String, strMessage:String) {
        // create the alert
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:-
    //MARK:- API Methods
    
    func getPaymentTokenApi(token: String) {
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            var params =  ["_token":token, "plan_id":planId] as [String: Any]
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
               // ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.getpaymentoken, method: .post,  parameters: params, encoding: JSONEncoding.default, headers:headers)
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
                        let status = json["success"] as? Int
                        if status == 1 {
                            activeStatus = false
                            
                            let msg = json["message"] as? String
                            //ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            
                           // let statusActive = true
                            
                            let alert = UIAlertController(title: "", message: msg!, preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                
                               
                                self.delegate?.getActiveStatus(status: self.planOrder)
                                
                                let vc:TimeLineHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier:"TimeLineHistoryViewController") as! TimeLineHistoryViewController
                                
                                
                                
                                let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
                                
                                let window = UIApplication.shared.delegate?.window
                                // window = UIWindow(frame: UIScreen.main.bounds)
                                window!!.rootViewController = SideMenuController(contentViewController: vc,
                                                                                 menuViewController: menuViewController)

                                
                                
                            }
                    
                            alert.addAction(OKAction)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                            
                            
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
