//
//  AddChildProfileViewController.swift
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


class AddChildProfileViewController: UIViewController, UITextFieldDelegate, CountryListDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var childProfileIconImg: UIImageView!
    @IBOutlet weak var childProfileBtn: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dateofBirthView: UIView!
    @IBOutlet weak var dateofBirthTextField: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTexttField: UITextField!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipView: UIView!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    @IBOutlet weak var pickerInputView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var countryList = CountryList()
    var isCountryCode = Bool()
    var countryCode = String()
    var phoneExtension = String()
    var myPickerController = UIImagePickerController()
    var activationObject = KeyHolderObject()
    var editActivationObject = KeyHolderObject()
    var IdentifyBool = true
    var childDetailObj = KeyHolderObject()
    var receivedEditBool = Bool()
    var index = Int()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        countryList.delegate = self
        dateofBirthTextField.delegate = self
        countryCodeTextField.text = "🇺🇸 +1"
        phoneExtension = "+1"
        showDatePicker()
        setUI()
        
        if receivedEditBool {
            
            updateData()
        }
        
        else {
            
            titleLabel.text = "Add Child"

        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //keyboardWillHide(notification: NSNotification.Name.UIKeyboardWillHide)
        
    }
    
    func setUI()
    {
        childProfileIconImg.setBorder(width: 1, color: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 30)

        nameView.setBorder(width: 1, color:  #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 2)
        
        emailView.setBorder(width: 1, color:  #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 2)
        
        countryCodeView.setBorder(width: 1, color: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 2)
        
        phoneNumberView.setBorder(width: 1, color:  #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 2)
        
        dateofBirthView.setBorder(width: 1, color:  #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 2)
        
        addressView.setBorder(width: 1, color: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 2)
        
        cityView.setBorder(width: 1, color:  #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 2)
        
        zipView.setBorder(width: 1, color: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 2)
        
        countryView.setBorder(width: 1, color: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 2)
        
        submitBtn.setBorder(width: 1, color: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 0), cornerRaidus: 22.5)
        
    }
    
    func updateData() {
        
        titleLabel.text = "Edit Child"
        nameTextField.text = childDetailObj.name
        emailTextField.text = childDetailObj.email
        countryCodeTextField.text = childDetailObj.country_code
        phoneTextField.text = childDetailObj.phone
        dateofBirthTextField.text = childDetailObj.dob
        addressTexttField.text = childDetailObj.address_line_1
        cityTextField.text = childDetailObj.city
        zipTextField.text = childDetailObj.zip
        countryTextField.text = childDetailObj.country
        print(childDetailObj.profile_pic_url)
        childProfileIconImg.sd_setImage(with: URL(string : childDetailObj.profile_pic_url), placeholderImage: UIImage(named: "place"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
            
        }
        
    }
    
    //MARK:-
    //MARK:- TextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func childProfileBtnAction(_ sender: Any) {
        
        let alertController = UIAlertController(title:"", message:"", preferredStyle: .actionSheet)
        let cameraAction =  UIAlertAction(title:"Camera", style:.default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title:"Gallery", style:.default) { (action) in
            self.photoLibrary()
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func countryCodeBtnAction(_ sender: Any) {
        
        isCountryCode = true
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func countryBtnAction(_ sender: Any) {
        
        isCountryCode = false
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        
        if receivedEditBool {
            
            updateChildApi()
        }
        
        else {
             addChildApi()
        }
    }
    
    
    @IBAction func cancelToolButtonAction(_ sender: UIBarButtonItem)
    {
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateofBirthTextField.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
        
        
    }
    
    
    //MARK:-
    //MARK:- Custom Methods
    
    @objc func showDatePicker()
    {
        //Formate Date
        datePicker.datePickerMode = .date
        dateofBirthTextField.inputView = pickerInputView
        dateofBirthTextField.inputAccessoryView = nil
        datePicker.maximumDate = Date()
        
    }
    
    //MARK:-
    //MARK:- ImagePicker Delegate
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.mediaTypes = [kUTTypeImage] as [String]
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        childProfileIconImg.image = image
        self.dismiss(animated: false) {
            
        }
        
    }
    
    
    
    //MARK:-
    //MARK:- Country Delegate
    func selectedCountry(country: Country) {
        
        if isCountryCode {
            countryCodeTextField.text = "\(country.flag!) +\(country.phoneExtension)"
            // countryTextField.text = "\(country.name!)"
            phoneExtension = "+\(country.phoneExtension)"
        }
        else {
            countryTextField.text = "\(country.name!)"
            //  countryCodeTextField.text = "\(country.flag!) +\(country.phoneExtension)"
            countryCode = country.countryCode
        }
    }
    
    
    //MARK:-
    //MARK:- API Methods
    
    func addChildApi() {
        
        let name:String = (nameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let countryCode:String = (countryCodeTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let phone:String = (phoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let dob:String = (dateofBirthTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let address:String = (addressTexttField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let city:String = (cityTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let zip:String = (zipTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let country:String = (countryTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        self.view.endEditing(true)
        
        if name.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter name", vc: self)
        }
        else if name.count < 3 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 3 characters name", vc: self)
        }
        else if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email", vc: self)
        }
        else if !ProjectManager.sharedInstance.isEmailValid(email: email) {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Invalid email", vc: self)
        }
        else if countryCode.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select country", vc: self)
        }
        else if phone.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter phone number", vc: self)
        }
        else if phone.count < 10 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 8 characters phone number", vc: self)
        }
        else  if dob.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select date of birth", vc: self)
        }
        else  if address.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter address", vc: self)
        }
        else if city.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter city", vc: self)
        }
        else if zip.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter postal/zip code", vc: self)
        }
            
        else if country.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select country", vc: self)
        }
            
            
        else {
            
            let str =  countryCode
            let split = str.split(separator: " ")
            let codeNumber    = String(split.suffix(1).joined(separator: [" "]))
            print(codeNumber)
            
            
            var parameters = [String: Any]()
            parameters = ["name":name , "email": email, "dob":dob,"phone_code":codeNumber,"phone":phone,"address":address, "city":city, "zip":zip, "country":country]
            let imgParam = "change_profile_pic"
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                ProjectManager.sharedInstance.callApiWithParameters(params:parameters, url:baseURL + ApiMethods.addChild, image: childProfileIconImg.image, imageParam:imgParam) { (response, error) in
                    ProjectManager.sharedInstance.stopLoader()
                    
                    
                    if response != nil {
                        if let status = response?["status"] as? NSNumber {
                            if status == 1 {
                                print(response!)
                                if let data = response?["data"] as? [String: Any] {
                                    
                                    self.activationObject = ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)
                                    
                                    print(self.activationObject)
                                    
                                    let msg = response?["message"] as? String
                                    let alertController = UIAlertController(title:"", message: msg, preferredStyle: .alert)
                                    
                                    // Create OK button
                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                        
                                        
                                        
                                        let alertVC :EmailVerificationPopupup = (self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationPopupup") as? EmailVerificationPopupup)!
                                        
                                        alertVC.obj = self.activationObject
                                        alertVC.boolChecked = self.IdentifyBool
                                        
                                        let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                        , tapGestureDismissal: false, panGestureDismissal: false) {
                                            let overlayAppearance = PopupDialogOverlayView.appearance()
                                            overlayAppearance.blurRadius  = 30
                                            overlayAppearance.blurEnabled = true
                                            overlayAppearance.liveBlur    = false
                                            overlayAppearance.opacity     = 0.4
                                        }
                                        
                                        alertVC.verifyAction = {
                                            
//                                            popup.dismiss({
//                                                
//                                                // self.navigationController?.popViewController(animated: true)
//                                                
//                                            })
//                                            
                                            
                                        }
                                        
                                        alertVC.noAction = {
                                            
                                            popup.dismiss({
                                                
                                                // self.navigationController?.popViewController(animated: true)
                                                
                                            })
                                            
                                            
                                        }
                                        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                                        
                                    }
                                    
                                    alertController.addAction(OKAction)
                                    // Present Dialog message
                                    self.present(alertController, animated: true, completion:nil)
                                    
                                }
                                
                            }
                            else {
                                
                                let msg = response?["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                        }
                    }
                        
                    else {
                        
                        
                        
                    }
                }
            }
            
        }
        
        
    }
    
    func updateChildApi() {
        
        let name:String = (nameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let countryCode:String = (countryCodeTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let phone:String = (phoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let dob:String = (dateofBirthTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let address:String = (addressTexttField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let city:String = (cityTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let zip:String = (zipTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let country:String = (countryTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        self.view.endEditing(true)
        
        if name.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter name", vc: self)
        }
        else if name.count < 3 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 3 characters name", vc: self)
        }
        else if email.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email", vc: self)
        }
        else if !ProjectManager.sharedInstance.isEmailValid(email: email) {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Invalid email", vc: self)
        }
        else if countryCode.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select country", vc: self)
        }
        else if phone.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter phone number", vc: self)
        }
        else if phone.count < 10 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 8 characters phone number", vc: self)
        }
        else  if dob.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select date of birth", vc: self)
        }
        else  if address.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter address", vc: self)
        }
        else if city.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter city", vc: self)
        }
        else if zip.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter postal/zip code", vc: self)
        }
            
        else if country.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please select country", vc: self)
        }
            
            
        else {
            
            let str =  countryCode
            let split = str.split(separator: " ")
            let codeNumber    = String(split.suffix(1).joined(separator: [" "]))
            print(codeNumber)
            
            
            var parameters = [String: Any]()
            parameters = ["child_id":childDetailObj.id,"name":name , "email": email, "dob":dob,"phone_code":codeNumber,"phone":phone,"address":address, "city":city, "zip":zip, "country":country]
            
            let imgParam = "change_profile_pic"
            
            
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                ProjectManager.sharedInstance.callApiWithParameters(params:parameters, url:baseURL + ApiMethods.updateChild, image: childProfileIconImg.image, imageParam:imgParam) { (response, error) in
                    ProjectManager.sharedInstance.stopLoader()
                    
                    
                    if response != nil {
                        if let status = response?["status"] as? NSNumber {
                            let message = response?["message"] as? String
                            if status == 1 {
                                print(response!)
                                
                                if let data = response?["data"] as? [String: Any] {
                                    
                                    self.editActivationObject =  ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)
                                    
                                       print(self.editActivationObject)
                                    
                                    
                                    if self.childDetailObj.email == email //&& self.childDetailObj.phone == phone
                                    {
                                        
                                        let alertController = UIAlertController(title:"", message: message, preferredStyle: .alert)
                                        
                                        // Create OK button
                                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                            
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                        alertController.addAction(OKAction)
                                        
                                        // Present Dialog message
                                        self.present(alertController, animated: true, completion:nil)
         
                                    }

                                    
                                    else {
                                    
                                        let alertVC :EmailVerificationPopupup = (self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationPopupup") as? EmailVerificationPopupup)!
                                        
                                        alertVC.obj = self.editActivationObject
                                        alertVC.isEditBool = self.IdentifyBool
                                        alertVC.index = self.index
                                        alertVC.pro_pic = self.childProfileIconImg.image!
 
                                        let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                        , tapGestureDismissal: false, panGestureDismissal: false) {
                                            let overlayAppearance = PopupDialogOverlayView.appearance()
                                            overlayAppearance.blurRadius  = 30
                                            overlayAppearance.blurEnabled = true
                                            overlayAppearance.liveBlur    = false
                                            overlayAppearance.opacity     = 0.4
                                        }
                                        
                                        alertVC.verifyAction = {
                                            
//                                            popup.dismiss({
//
//                                                // self.navigationController?.popViewController(animated: true)
//
//                                            })
                                            
                                            
                                        }
                                        
                                        alertVC.noAction = {
                                            
                                            popup.dismiss({
                                                
                                                // self.navigationController?.popViewController(animated: true)
                                                
                                            })
                                            
                                            
                                        }
                                        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                                }
        
                                }
                                
                                else {
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: message!, vc: UIApplication.topViewController()!)
                                }
                                
                            }
                            else {
                                
                              
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: message!, vc: UIApplication.topViewController()!)
                                
                            }
                        }
                    }
                        
                    else {
                        
                        
                        
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
