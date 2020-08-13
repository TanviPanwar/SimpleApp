//
//  EditKeyHolderViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 20/03/19.
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

class EditKeyHolderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    
    
    @IBOutlet weak var directoryView: UIView!
    @IBOutlet weak var chooseDirTextField: UITextField!
    @IBOutlet weak var chooseDirBtn: UIButton!
    @IBOutlet weak var directoryCollectionView: UICollectionView!
    @IBOutlet weak var selectAllDirBtn: UIButton!
    @IBOutlet weak var releaseDateBtn: UIButton!
    @IBOutlet weak var releaseDeathBtn: UIButton!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var releaseDeathLabel: UILabel!
    @IBOutlet weak var selectDateTextField: TextField!
    
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var selectDirView: UIView!
    @IBOutlet weak var releaseDateView: UIView!
    @IBOutlet weak var releaseDeathView: UIView!
    @IBOutlet weak var selectDateView: UIView!
    

    
    
    
    
    
    var textFieldPressedValue = Int()
    var pickerArray = ["Photos", "Videos", "Music", "Audio", "Home"]
    var dircollectionArray = [KeyHolderObject]()
    var selectPickerIndex = Int()
    var obj = KeyHolderObject()
    var newobj = KeyHolderObject()

    var release_type = ""
    var btnTag = Int()
    var DirectoryArray = [KeyHolderObject]()
    var dirNameArray = [String]()
    var keyholderobj = KeyHolderObject()
    var isEditKeyHolderBool = true
    
    
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUI()
        updateUI()
        chooseDirTextField.delegate = self
        selectDateTextField.delegate = self
        showDatePicker()
        showPicker()
        getDirectoriesList()
        
        dircollectionArray = obj.accessible_dir
        
    }
    
    //MARK:-
    //MARK:- Custom Methods
    
    func setUI() {
        
        directoryView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 2)
       // selectAllDirBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        releaseDateBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: releaseDateBtn.frame.height/2)
        releaseDeathBtn.setBorder(width:1 , color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: releaseDeathBtn.frame.height/2)
        updateBtn.setBorder(width: 1, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , cornerRaidus: 22.3)
      
         releaseDateView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: releaseDateView.frame.height/2)
         releaseDeathView.setBorder(width:1 , color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: releaseDeathView.frame.height/2)
        
       // selectDateTextField.textFieldWithLeftView(width: 35, icon: <#T##UIImage#>)
    }
    
    
    func updateUI() {
        
        if obj.release_type == "ondate" {
            
//            releaseDateBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
//            releaseDeathBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            releaseDateView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
            releaseDeathView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            
            selectDateView.isHidden = false
            selectDateTextField.text = obj.release_date
            
            releaseDateLabel.translatesAutoresizingMaskIntoConstraints = true
            
            releaseDateBtn.translatesAutoresizingMaskIntoConstraints = true
            releaseDeathLabel.translatesAutoresizingMaskIntoConstraints = true
            releaseDeathBtn.translatesAutoresizingMaskIntoConstraints = true
            selectDateView.translatesAutoresizingMaskIntoConstraints = true
            
            updateBtn.translatesAutoresizingMaskIntoConstraints = true
            
            
            releaseDateLabel.frame = CGRect(x: releaseDateLabel.frame.origin.x , y: releaseDateLabel.frame.origin.y , width: releaseDateLabel.frame.size.width, height: releaseDateLabel.frame.size.height)
            
            
            selectDateView.frame = CGRect(x: selectDateView.frame.origin.x , y: releaseDateLabel.frame.origin.y + releaseDateLabel.frame.size.height + 20, width: selectDateView.frame.size.width, height: selectDateView.frame.size.height)
            
            releaseDeathBtn.frame = CGRect(x: releaseDeathBtn.frame.origin.x , y: selectDateView.frame.origin.y + selectDateView.frame.size.height + 20, width: releaseDeathBtn.frame.size.width, height: releaseDeathBtn.frame.size.height)
            
            releaseDeathLabel.frame = CGRect(x: releaseDeathLabel.frame.origin.x , y: selectDateView.frame.origin.y + selectDateView.frame.size.height + 20, width: releaseDeathLabel.frame.size.width, height: releaseDeathLabel.frame.size.height)
            
            updateBtn.frame = CGRect(x: updateBtn.frame.origin.x , y: releaseDeathLabel.frame.origin.y + releaseDeathLabel.frame.size.height + 20, width: updateBtn.frame.size.width, height: updateBtn.frame.size.height)
            
            
            
            
        }
            
        else {
            
//            releaseDeathBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
//            releaseDateBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            releaseDeathView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
            releaseDateView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            
        }
        
    }
    
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
        chooseDirTextField.inputView = pickerInputView
        chooseDirTextField.inputAccessoryView = nil
      
        
    }
    
    //MARK:-
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == chooseDirTextField {
            textFieldPressedValue = textField.tag
            showPicker()
            print("You edit myTextField")
        }
            
        else if textField == selectDateTextField {
            textFieldPressedValue = textField.tag
            showDatePicker()
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
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseDirBtnAction(_ sender: Any) {
        
        
        
    }
    
    @IBAction func selectAllDirBtnAction(_ sender: Any) {
        
        // selectAllDirBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
         selectAllDirBtn.setImage(UIImage(named: "check"), for: .normal)
        
        let arr  = self.dircollectionArray.map{$0.dir_name}
        let arr1  = self.DirectoryArray.map{$0.dir_name}
        
        if arr.containsSameElements(as: arr1) {
            
            dircollectionArray.removeAll()
           // selectAllDirBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            selectAllDirBtn.setImage(UIImage(named: "unchck"), for: .normal)


        }
            
        else {
            
            for i in self.DirectoryArray {
                let arr  = self.dircollectionArray.map{$0.dir_name}
                
                if !arr.contains(i.dir_name) {
                    let obj = KeyHolderObject()
                    obj.dir_name = i.dir_name
                    obj.dir_id = i.dir_id
                    dircollectionArray.append(obj)
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
        
        updateBtn.translatesAutoresizingMaskIntoConstraints = true
        
        
        releaseDateLabel.frame = CGRect(x: releaseDateLabel.frame.origin.x , y: releaseDateLabel.frame.origin.y , width: releaseDateLabel.frame.size.width, height: releaseDateLabel.frame.size.height)
        
        
        selectDateView.frame = CGRect(x: selectDateView.frame.origin.x , y: releaseDateLabel.frame.origin.y + releaseDateLabel.frame.size.height + 20, width: selectDateView.frame.size.width, height: selectDateView.frame.size.height)
        
        releaseDeathBtn.frame = CGRect(x: releaseDeathBtn.frame.origin.x , y: selectDateView.frame.origin.y + selectDateView.frame.size.height + 20, width: releaseDeathBtn.frame.size.width, height: releaseDeathBtn.frame.size.height)
        
        releaseDeathLabel.frame = CGRect(x: releaseDeathLabel.frame.origin.x , y: selectDateView.frame.origin.y + selectDateView.frame.size.height + 20, width: releaseDeathLabel.frame.size.width, height: releaseDeathLabel.frame.size.height)
        
        updateBtn.frame = CGRect(x: updateBtn.frame.origin.x , y: releaseDeathLabel.frame.origin.y + releaseDeathLabel.frame.size.height + 20, width: updateBtn.frame.size.width, height: updateBtn.frame.size.height)
        
        
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
        
        updateBtn.translatesAutoresizingMaskIntoConstraints = true
        
        releaseDeathBtn.frame = CGRect(x: releaseDeathBtn.frame.origin.x , y: releaseDeathBtn.frame.origin.y - (selectDateView.frame.size.height + 20), width: releaseDeathBtn.frame.size.width, height: releaseDeathBtn.frame.size.height)
        
        releaseDeathLabel.frame = CGRect(x: releaseDeathLabel.frame.origin.x , y: releaseDeathLabel.frame.origin.y - (selectDateView.frame.size.height + 20), width: releaseDeathLabel.frame.size.width, height: releaseDeathLabel.frame.size.height)
        
        updateBtn.frame = CGRect(x: updateBtn.frame.origin.x , y: updateBtn.frame.origin.y - (releaseDeathLabel.frame.size.height + 20), width: updateBtn.frame.size.width, height: updateBtn.frame.size.height)
        
        
        
        
    }
    
    @IBAction func updateBtnAction(_ sender: Any) {
        
        editKeyHolderApi()
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if textFieldPressedValue == 1 {
            
            let arr  = self.dircollectionArray.map{$0.dir_name}
            let row = pickerView.selectedRow(inComponent: 0)
            if !arr.contains(DirectoryArray[row].dir_name) {
                let obj = KeyHolderObject()
                obj.dir_name = DirectoryArray[row].dir_name
                obj.dir_id = DirectoryArray[row].dir_id

                dircollectionArray.append(obj)
            }
            //let rowIndex = pickerView.selectedRow(inComponent: 0)
            
//            if dircollectionArray.contains(dirNameArray[selectPickerIndex]) {
//
//            }
//
//            else {
//            dircollectionArray.append(DirectoryArray[selectPickerIndex].dir_name)
//            }
            directoryCollectionView.reloadData()
            
            
            
        }
            
        else if textFieldPressedValue == 2 {
            selectDateTextField.text = formatter.string(from: datePickerView.date)
            
        }
        //dismiss date picker dialog
        self.view.endEditing(true)
        
    }
    
    
    //MARK:-
    //MARK:- CollectionView DataSources
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //        let cell = self.keyHolderCollectionView.cellForItem(at: indexPath as IndexPath) as? KeyHolderCollectionViewCell
        //        let contentsize: CGFloat = CGFloat(itemsArray[indexPath.row].count)
        
        
        let size =  CGSize(width:(dircollectionArray[indexPath.row].dir_name as NSString).size(withAttributes: nil).width + 50, height: 29)
        
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return dircollectionArray.count
        
       // return obj.accessible_dir.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditKeyHolderCollectionViewCell", for: indexPath) as! EditKeyHolderCollectionViewCell
        
        cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0.6656258702, green: 0.6661420465, blue: 0.6657058001, alpha: 1), cornerRaidus: 4)
        
        cell.dirTitleLabel.text = dircollectionArray[indexPath.row].dir_name
        
        cell.onDeleteButtonTapped = {
            
            self.dircollectionArray.remove(at: indexPath.row)
            self.directoryCollectionView.reloadData()
            
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
        return DirectoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DirectoryArray[row].dir_name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectPickerIndex = row
        //        chooseDirTextField.text = pickerArray[row]
        //        dircollectionArray.append(pickerArray[row])
        //        directoryCollectionView.reloadData()
        
        
    }
    
    //MARK:-
    //MARK:- API Methods
    
    func editKeyHolderApi() {
        
        
        let releaseDate:String = (selectDateTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            var parameters = [String: Any]()
            
            
            if btnTag == 3 {
            
            parameters = ["receiver_id":obj.receiver_id, "release_type":release_type, "release_date":releaseDate, "access_dirs": self.dircollectionArray.map{$0.dir_id}]
            }
            
            else if btnTag == 4 {
                
                parameters = ["receiver_id":obj.receiver_id, "release_type":release_type, "access_dirs": self.dircollectionArray.map{$0.dir_id}]
                
            }
            
            else {
                
                if obj.release_type == "ondate" {
               
                    parameters = ["receiver_id":obj.receiver_id, "release_type":obj.release_type, "release_date":obj.release_date, "access_dirs": self.dircollectionArray.map{$0.dir_id}]
                    
                }
                
                else if obj.release_type == "ondeath" {
                    
                    parameters = ["receiver_id":obj.receiver_id, "release_type":obj.release_type, "access_dirs": self.dircollectionArray.map{$0.dir_id}]
                    print(parameters)
           
            }
                
                else if obj.release_type == "now" {
                    
                    parameters = ["receiver_id":obj.receiver_id, "release_type":obj.release_type, "access_dirs": self.dircollectionArray.map{$0.dir_id}]
                    
                }
                
            }
            
            print(parameters)
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.updateKeyholder, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? [String: Any] {
                            
                                self.keyholderobj = ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)
                            
                            print(self.keyholderobj)
                                
                                
                           
                                
                                let alertVC :EmailVerificationPopupup = (self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationPopupup") as? EmailVerificationPopupup)!
                                
                                alertVC.obj = self.keyholderobj
                                alertVC.isEditKeyHolderBool = self.isEditKeyHolderBool
  
                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                , tapGestureDismissal: false, panGestureDismissal: false) {
                                    let overlayAppearance = PopupDialogOverlayView.appearance()
                                    overlayAppearance.blurRadius  = 30
                                    overlayAppearance.blurEnabled = true
                                    overlayAppearance.liveBlur    = false
                                    overlayAppearance.opacity     = 0.4
                                }
                                
                                //            alertVC.noAction = {
                                //
                                //                popup.dismiss({
                                //
                                //                    self.navigationController?.popViewController(animated: true)
                                //
                                //                })
                                //
                                //
                                //            }
                                
                                alertVC.verifyAction = {
                                    
                                   
                                    
                                    
                                }
                                
                                alertVC.noAction = {
                                    
                                    popup.dismiss({
                                        
                                        // self.navigationController?.popViewController(animated: true)
                                        
                                    })
                                    
                                    
                                }
                                
                                UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                            
                        }
                            else {
                                
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
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
    
    func getDirectoriesList() {
        
        
        let releaseDate:String = (selectDateTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
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
                        if status == 1{
                            if let data = json["data"] as? NSArray {
                                print(data)
                                 self.DirectoryArray = ProjectManager.sharedInstance.GetKeyHolderListObjects(array: data)
      
                            }
                            else{
                                
                            }
                            
                        }
                        else {
                            self.navigationController?.popViewController(animated: true)
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Directories not found", vc: UIApplication.topViewController()!)
                            
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
