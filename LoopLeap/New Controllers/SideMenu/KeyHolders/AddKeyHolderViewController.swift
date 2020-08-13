//
//  AddKeyHolderViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 12/03/19.
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

public protocol KeyholdersListDelegate: class {
    func refreshKeyholderList()
}

class AddKeyHolderViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource, CountryListDelegate   {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTexttField: UITextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var phoneNummberView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var relationshipView: UIView!
    @IBOutlet weak var selectRelationshipTextField: UITextField!
    @IBOutlet weak var relationshipBtn: UIButton!
    @IBOutlet weak var directoriesView: UIView!
    @IBOutlet weak var chooseDirectoriesTextField: UITextField!
    @IBOutlet weak var directoriesBtn: UIButton!
    @IBOutlet weak var selectAllDirectoriesBtn: UIButton!
    @IBOutlet weak var releaseDateBtn: UIButton!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var releaseDeathBtn: UIButton!
    @IBOutlet weak var releaseDeathLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var selectDateTextField: TextField!
    @IBOutlet weak var directoryCollectionView: UICollectionView!
    
    
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var releaseDateView: UIView!
    @IBOutlet weak var releaseDeathView: UIView!
    @IBOutlet weak var selectDateView: UIView!

    
    
    var objc = KeyHolderObject()
    var user_DirArray = [KeyHolderObject]()
    var collection_DirArray = [KeyHolderObject]()
    var relationshipArray = ["Father", "Mother", "Sister", "Brother", "Spouse"]
    
    var selectPickerIndex = Int()
    var textFieldPressedValue = Int()
    var release_type = ""
    var btnTag = Int()
    
    var objArray = [DirectoriesListObject]()
    var countryList = CountryList()
    var isCountryCode = Bool()
    var countryCode = String()
    var phoneExtension = String()
    
    var delegate: KeyholdersListDelegate?
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        chooseDirectoriesTextField.delegate = self
        selectDateTextField.delegate = self
        countryCodeTextField.delegate = self
        selectRelationshipTextField.delegate = self
        
        countryCodeTextField.text =  "🇺🇸 +1"
        phoneExtension = "+1"
        countryList.delegate = self
        
        release_type = "ondeath"
        
        nameView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        emailView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        addressView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        countryCodeView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        phoneNummberView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        relationshipView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
        directoriesView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
       // selectAllDirectoriesBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: 2)
        releaseDateBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: releaseDateBtn.frame.height/2)
        releaseDeathBtn.setBorder(width:1 , color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: releaseDeathBtn.frame.height/2)
        submitBtn.setBorder(width: 1, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) , cornerRaidus: 22.3)
        
        releaseDateView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: releaseDateView.frame.height/2)
        releaseDeathView.setBorder(width:1 , color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: releaseDeathView.frame.height/2)
        
        
        getDirectoriesList()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:-
    //MARK:- Custom methods
    
    
    @objc func showDatePicker()
    {
        //Formate Date
        datePickerView.isHidden = false
        pickerView.isHidden = true
        datePickerView.datePickerMode = .date
        selectDateTextField.inputView = pickerInputView
        selectDateTextField.inputAccessoryView = nil
        datePickerView.minimumDate = Date()
        
    }
    
    @objc func showPicker()
    {
        
        datePickerView.isHidden = true
        pickerView.isHidden = false
        chooseDirectoriesTextField.inputView = pickerInputView
        chooseDirectoriesTextField.inputAccessoryView = nil
        selectRelationshipTextField.inputView = pickerInputView
        selectRelationshipTextField.inputAccessoryView = nil
        
        
    }
    
    //MARK:-
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == chooseDirectoriesTextField {
            textFieldPressedValue = textField.tag
            showPicker()
            pickerView.reloadAllComponents()
            print("You edit myTextField")
        }
            
        else if textField == selectDateTextField {
            textFieldPressedValue = textField.tag
            showDatePicker()
            print("You edit myTextField")
        }
            
        else if textField == selectRelationshipTextField {
            textFieldPressedValue = textField.tag
            showPicker()
            pickerView.reloadAllComponents()

            print("You edit myTextField")
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func countryCodeBtnAction(_ sender: Any) {
        isCountryCode = false
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func selectRelationshipBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func chooseDirectoriesBtnAction(_ sender: Any) {
    }
    
    
    @IBAction func selectAllDirectoriesBtnAction(_ sender: Any) {
        
     selectAllDirectoriesBtn.setImage(UIImage(named: "check"), for: .normal)
        btnTag = selectAllDirectoriesBtn.tag
        
        let arr  = self.collection_DirArray.map{$0.dir_name}
        let arr1  = self.user_DirArray.map{$0.dir_name}
        
        if arr.containsSameElements(as: arr1) {
            
            collection_DirArray.removeAll()
            
            selectAllDirectoriesBtn.setImage(UIImage(named: "unchck"), for: .normal)
        }
        
        else {
        
        for i in self.user_DirArray {
            let arr  = self.collection_DirArray.map{$0.dir_name}
            
            if !arr.contains(i.dir_name) {
                let obj = KeyHolderObject()
                obj.dir_name = i.dir_name
                obj.dir_id = i.dir_id
                collection_DirArray.append(obj)
            }
        }
    }
        
        directoryCollectionView.reloadData()
        
    }
    
    @IBAction func releaseDateBtnAction(_ sender: Any) {
        
        btnTag = releaseDateBtn.tag
        release_type = "ondate"
//        releaseDateBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
//        releaseDeathBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        releaseDateView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        releaseDeathView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        
        selectDateView.isHidden = false
        
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = true
        
        releaseDateBtn.translatesAutoresizingMaskIntoConstraints = true
        releaseDeathLabel.translatesAutoresizingMaskIntoConstraints = true
        releaseDeathBtn.translatesAutoresizingMaskIntoConstraints = true
        selectDateView.translatesAutoresizingMaskIntoConstraints = true
        
        submitBtn.translatesAutoresizingMaskIntoConstraints = true
        
        
        releaseDateLabel.frame = CGRect(x: releaseDateLabel.frame.origin.x , y: releaseDateLabel.frame.origin.y , width: releaseDateLabel.frame.size.width, height: releaseDateLabel.frame.size.height)
        
        
        selectDateView.frame = CGRect(x: selectDateView.frame.origin.x , y: releaseDateLabel.frame.origin.y + releaseDateLabel.frame.size.height + 20, width: selectDateView.frame.size.width, height: selectDateView.frame.size.height)
        
        releaseDeathBtn.frame = CGRect(x: releaseDeathBtn.frame.origin.x , y: selectDateView.frame.origin.y + selectDateView.frame.size.height + 20, width: releaseDeathBtn.frame.size.width, height: releaseDeathBtn.frame.size.height)
        
        releaseDeathLabel.frame = CGRect(x: releaseDeathLabel.frame.origin.x , y: selectDateView.frame.origin.y + selectDateView.frame.size.height + 20, width: releaseDeathLabel.frame.size.width, height: releaseDeathLabel.frame.size.height)
        
        submitBtn.frame = CGRect(x: submitBtn.frame.origin.x , y: releaseDeathLabel.frame.origin.y + releaseDeathLabel.frame.size.height + 20, width: submitBtn.frame.size.width, height: submitBtn.frame.size.height)
        
        
    }
    
    @IBAction func releaseDeathBtnAction(_ sender: Any) {
        
        btnTag = releaseDeathBtn.tag
        release_type = "ondeath"
//        releaseDeathBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
//        releaseDateBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        releaseDeathView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        releaseDateView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        selectDateView.isHidden = true
        
        releaseDeathLabel.translatesAutoresizingMaskIntoConstraints = true
        releaseDeathBtn.translatesAutoresizingMaskIntoConstraints = true
        selectDateView.translatesAutoresizingMaskIntoConstraints = true
        
        submitBtn.translatesAutoresizingMaskIntoConstraints = true
        
        releaseDeathBtn.frame = CGRect(x: releaseDeathBtn.frame.origin.x , y: releaseDeathBtn.frame.origin.y - (selectDateView.frame.size.height + 20), width: releaseDeathBtn.frame.size.width, height: releaseDeathBtn.frame.size.height)
        
        releaseDeathLabel.frame = CGRect(x: releaseDeathLabel.frame.origin.x , y: releaseDeathLabel.frame.origin.y - (selectDateView.frame.size.height + 20), width: releaseDeathLabel.frame.size.width, height: releaseDeathLabel.frame.size.height)
        
        submitBtn.frame = CGRect(x: submitBtn.frame.origin.x , y: submitBtn.frame.origin.y - (releaseDeathLabel.frame.size.height + 20), width: submitBtn.frame.size.width, height: submitBtn.frame.size.height)
        
        
        
        
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        addKeyHolder()
        
    }
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if textFieldPressedValue == 1 {
            
            let arr  = self.collection_DirArray.map{$0.dir_name}
            let row = pickerView.selectedRow(inComponent: 0)
            if !arr.contains(user_DirArray[row].dir_name) {
                let obj = KeyHolderObject()
                obj.dir_name = user_DirArray[row].dir_name
                obj.dir_id = user_DirArray[row].dir_id
                collection_DirArray.append(obj)
                
            }
            
            
            //let rowIndex = pickerView.selectedRow(inComponent: 0)
            
            //                        if collection_DirArray.contains(collection_DirArray[row].dir_name) {
            //
            //                        }
            //
            //                        else {
            //                        collection_DirArray.append(user_DirArray[selectPickerIndex])
            //                        }
            
            
            directoryCollectionView.reloadData()
            
            
            
        }
            
        else if textFieldPressedValue == 2 {
            selectDateTextField.text = formatter.string(from: datePickerView.date)
            
        }
            
        else if textFieldPressedValue == 6 {
            let row = pickerView.selectedRow(inComponent: 0)
            
            selectRelationshipTextField.text = relationshipArray[row]
            
        }
        //dismiss date picker dialog
        self.view.endEditing(true)
        
    }
    
    
    
    
    //MARK:-
    //MARK:- CollectionView DataSources
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //        let cell = self.keyHolderCollectionView.cellForItem(at: indexPath as IndexPath) as? KeyHolderCollectionViewCell
        //        let contentsize: CGFloat = CGFloat(itemsArray[indexPath.row].count)
        
        
        let size =  CGSize(width:(collection_DirArray[indexPath.row].dir_name as NSString).size(withAttributes: nil).width + 50, height: 29)
        
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection_DirArray.count
        
        // return obj.accessible_dir.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditKeyHolderCollectionViewCell", for: indexPath) as! EditKeyHolderCollectionViewCell
        
        cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0.6656258702, green: 0.6661420465, blue: 0.6657058001, alpha: 1), cornerRaidus: 4)
        
        if collection_DirArray.count > 0 {
            
            cell.dirTitleLabel.text = collection_DirArray[indexPath.row].dir_name
            
            cell.onDeleteButtonTapped = {
                
                self.collection_DirArray.remove(at: indexPath.row)
                self.directoryCollectionView.reloadData()
                
            }
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
    }
    
    
    
    //MARK:-
    //MARK:- PickerView DataSources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if textFieldPressedValue == 1
        {
            return user_DirArray.count
            
        }
            
        else
        {
            return relationshipArray.count
            
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if textFieldPressedValue == 1{
            return user_DirArray[row].dir_name
            
        }
            
        else {
            return relationshipArray[row]
            
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectPickerIndex = row
        //        chooseDirTextField.text = pickerArray[row]
        //        dircollectionArray.append(pickerArray[row])
        //        directoryCollectionView.reloadData()
        
        
    }
    
    
    
    //MARK:-
    //MARK:- API Methods
    
    func addKeyHolder() {
        
        
        let name:String = (nameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let address:String = (addressTexttField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let phone:String = (phoneTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
         let country_code:String = (countryCodeTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let relationship:String = (selectRelationshipTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let select_date:String = (selectDateTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        self.view.endEditing(true)

        
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
            else  if address.isEmpty {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter address", vc: self)
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
                
            else if relationship.isEmpty {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter relationship", vc: self)
            }
                
            else if self.collection_DirArray.isEmpty {
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast one directory", vc: self)
                
            }
                
                
            else  if btnTag == 3 && select_date.isEmpty {
               
                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter date", vc: self)
                
            }
                
            else {
                
                let str =  country_code
                let split = str.split(separator: " ")
                let code    = String(split.suffix(1).joined(separator: [" "]))
                print(code)
                
                var parameters = [String: Any]()
                
                if btnTag == 3 {
                    parameters = ["keyholder_name":name, "keyholder_email":email, "keyholder_phone":phone, "country_code":code, "keyholder_address":address, "keyholder_relation":relationship, "access_dirs": self.collection_DirArray.map{$0.dir_id}, "release_type":release_type,"release_date":select_date ]
                }
                else {
                    
                    parameters = ["keyholder_name":name, "keyholder_email":email, "keyholder_phone":phone, "country_code":code, "keyholder_address":address, "keyholder_relation":relationship, "access_dirs": self.collection_DirArray.map{$0.dir_id}, "release_type":release_type]
                }
                
                
                print(parameters)
                
                
                if ProjectManager.sharedInstance.isInternetAvailable()
                {
                    ProjectManager.sharedInstance.showLoader()
                    
                    
                    Alamofire.request(baseURL + ApiMethods.addKeyholder, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                self.navigationController?.popViewController(animated: true)
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:msg!, vc: UIApplication.topViewController()!)
                               
                            }
                            else {
                                
                                if let msg = json["message"] as? String {
                                //self.navigationController?.popViewController(animated: true)
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg, vc: UIApplication.topViewController()!)
                                }
                                
                                else {
                                    let msg = json["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
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
            
        }
    }
    
    func getDirectoriesList() {
        
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            //            var parameters = [String: Any]()
            //
            //                parameters = ["sender_id":obj.sender_id,]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
               ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.getDirectoriesList, method: .get,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? NSArray {
                                
                                if data.count > 0 {
                                print(data)
                                    
                                    self.chooseDirectoriesTextField.isEnabled = true
                                    
                                self.user_DirArray = ProjectManager.sharedInstance.GetKeyHolderListObjects(array: data)
                                }
                                
                                else {
                                    
                                    self.chooseDirectoriesTextField.isEnabled = false
                                    let msg = json["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                }
                                
                                
                                
                            }
                            else{
                                
                                self.chooseDirectoriesTextField.isEnabled = false
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                            
                        }
                        else {
                            self.chooseDirectoriesTextField.isEnabled = false
                            let msg = json["message"] as? String
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            
                        }
                }
            }
                
            else {
                DispatchQueue.main.async(execute: {
                    
                    //ProjectManager.sharedInstance.stopLoader()
                    ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                })
            }
        }
    }
    
    //MARK:-
    //MARK:- Country Delegate
    func selectedCountry(country: Country) {
        
        if isCountryCode {
            countryCodeTextField.text = "\(country.flag!) +\(country.phoneExtension)"
            countryCodeTextField.text = "\(country.name!)"
            phoneExtension = "+\(country.phoneExtension)"
        }
        else {
            countryCodeTextField.text = "\(country.name!)"
            countryCodeTextField.text = "\(country.flag!) +\(country.phoneExtension)"
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



//MARK:-
//MARK:- Extensions

extension UIView {
    
    func setBorder(width:CGFloat , color :UIColor, cornerRaidus:CGFloat) {
        self.layer.borderWidth = width
        self.layer.cornerRadius = cornerRaidus
        self.layer.borderColor = color.cgColor

    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

