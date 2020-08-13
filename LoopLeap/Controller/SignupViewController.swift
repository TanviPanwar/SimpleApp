//
//  SignupViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 13/09/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit


class SignupViewController: UIViewController , UITextFieldDelegate ,CountryListDelegate {

    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var dobTxtFld: TextField!
    @IBOutlet weak var countryTxtFld: UITextField!
    @IBOutlet weak var cityTxtFld: UITextField!
    @IBOutlet weak var postalTxtFld: UITextField!
    @IBOutlet weak var phoneTxtFld: UITextField!
    @IBOutlet weak var signUpBtnA: UIButton!
    @IBOutlet weak var countryCodeTxtFls: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var pickerInputView: UIView!
    @IBOutlet weak var chooseDobPicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    
    var countryList = CountryList()
    var isCountryCode = Bool()
    var countryCode = String()
    var phoneExtension = String()
    //MARK:-
    //MARK:- View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList.delegate = self
        dobTxtFld.delegate = self

        SetUI()
        
        countryCodeTxtFls.text = "🇺🇸 +1"
        phoneExtension = "+1"
        showDatePicker()

        // Do any additional setup after loading the view.
    }
    func SetUI()  {
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = true
            self.signUpBtnA.layer.cornerRadius = 22.3
            self.signUpBtnA.layer.masksToBounds = true
            self.emailTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "Email-icon"))
            self.addressTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "address-icon"))
            self.dobTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "calendar"))
            self.phoneTxtFld.textFieldWithLeftView(width:35, icon:#imageLiteral(resourceName: "Phone-icon copy"))
            self.postalTxtFld.textFieldWithLeftView(width:35, icon:#imageLiteral(resourceName: "postal-code-icon"))
            self.nameTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "User-icon"))
            self.countryTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "Country-icon"))
            let dropViw = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
            dropViw.image = #imageLiteral(resourceName: "Arrow-bottom-icon")
            dropViw.contentMode = .center
            self.countryTxtFld.rightView = dropViw
            self.countryTxtFld.rightViewMode = .always
            self.cityTxtFld.textFieldWithLeftView(width:35, icon: #imageLiteral(resourceName: "city-icon"))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    //MARK:- Textfield Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func showDatePicker()
    {
        //Formate Date
        chooseDobPicker.datePickerMode = .date
        dobTxtFld.inputView = pickerInputView
        dobTxtFld.inputAccessoryView = nil
        chooseDobPicker.maximumDate = Date()


    }

    //MARK:-
    //MARK:- Custom Methods
    
    @IBAction func countryCodeAction(_ sender: Any) {
        isCountryCode = true
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countryAction(_ sender: Any) {
        isCountryCode = false
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    
    @IBAction func signupAction(_ sender: Any) {
        let nameStr:String = (nameTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let address:String = (addressTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let dob:String = (dobTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let country:String = (countryTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let city:String = (cityTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let zip:String = (postalTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let email:String = (emailTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let phone:String = (phoneTxtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        self.view.endEditing(true)
        if nameStr.isEmpty {
          ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter name", vc: self)
        }
        else if nameStr.count < 3 {
        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 3 characters name", vc: self)
        }
        else  if address.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter address", vc: self)
        }
//        else  if dob.isEmpty {
//            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select date of birth", vc: self)
//        }
        else if country.isEmpty {
             ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select country", vc: self)
        }
//        else if city.isEmpty {
//            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter city", vc: self)
//        }
//        else if zip.isEmpty {
//            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter postal/zip code", vc: self)
//        }
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
        else {
            ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWithoutHeader(params:["name":nameStr , "Email":email,"phone":phone, "address":address , "dob":dob, "city":city , "zipcode":zip ,"country":country,"country_code":countryCode , "phone_code":phoneExtension], url:baseURL + ApiMethods.signUpAPI, image:nil, imageParam:"") { (response, error) in
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
                                
                                self.navigationController?.popViewController(animated: true)
                                 ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg, vc: UIApplication.topViewController()!)
                            }
                            
                        }
                    }
                    
                    
                }
               
                
            }
            
        }
    }

    @IBAction func cancelToolButtonAction(_ sender: Any)
    {
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)

    }



    @IBAction func doneAction(_ sender: UIBarButtonItem) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dobTxtFld.text = formatter.string(from: chooseDobPicker.date)


        //dismiss date picker dialog
        self.view.endEditing(true)

    }

    //MARK:-
    //MARK:- Country Delegate
    func selectedCountry(country: Country) {
        
        if isCountryCode {
        countryCodeTxtFls.text = "\(country.flag!) +\(country.phoneExtension)"
         countryTxtFld.text = "\(country.name!)"
        phoneExtension = "+\(country.phoneExtension)"
        }
        else {
            countryTxtFld.text = "\(country.name!)"
            countryCodeTxtFls.text = "\(country.flag!) +\(country.phoneExtension)"
            countryCode = country.countryCode
            phoneExtension = "+\(country.phoneExtension)"

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
