//
//  UploadFileViewController.swift
//  LoopLeap
//
//  Created by IOS2 on 12/19/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import AssetsPickerViewController
import Photos
import PopupDialog
import CoreServices


protocol RefreshTimeLine {
    func refresh()
}


class UploadFileViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, AudioDelegate, uploadFilesDelegate, uploadSingleFileDelegate
{
    func updateSingleFilelabel() {
        
      //  var msg = String()
        
        if  cloudBool {
            
            singleFileMsg = "Some of the iCloud Files are skipped as iCloud account is not found and remaining files Uploaded Successfully"
        }
        else if self.assets.count > 0  &&  icloudArray.count > 0{
            if icloudArray.count == assets.count {
                
                singleFileMsg = "Files from iCloud are not available for sync as iCloud account is not found. "
            } else {
                singleFileMsg = "Some of the iCloud Files are skipped as iCloud account is not found and remaining files Uploaded Successfully"
            }
        }
        else if self.urlsAarray.count > 0 &&   icloudArray.count > 0{
            if  icloudArray.count == urlsAarray.count {
                
                singleFileMsg =  "Files from iCloud are not available for sync as iCloud account is not found. "
            } else {
                singleFileMsg = "Some of the iCloud Files are skipped as iCloud account is not found and remaining files Uploaded Successfully"
            }
        }
        else {
            
            singleFileMsg = "Files Uploaded Successfully"
        }
        
    }
    
    
    
    //MARK:- Refresh Time Line Delegate Declaration
    var delegate : RefreshTimeLine?
    
    func updateFileslabel() {
        
       
        // ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Files Uploaded Successfully", vc: UIApplication.topViewController()!)
        var msg = String()
        
        if  cloudBool {
            
            msg = "Some of the iCloud Files are skipped as iCloud account is not found and remaining files Uploaded Successfully"
        }
        else if self.assets.count > 0  &&  icloudArray.count > 0{
            if icloudArray.count == assets.count {
                
                 msg = "Files from iCloud are not available for sync as iCloud account is not found. "
            } else {
                 msg = "Some of the iCloud Files are skipped as iCloud account is not found and remaining files Uploaded Successfully"
            }
        }
        else if self.urlsAarray.count > 0 &&   icloudArray.count > 0{
            if  icloudArray.count == urlsAarray.count {
                
                msg =  "Files from iCloud are not available for sync as iCloud account is not found. "
            } else {
                msg = "Some of the iCloud Files are skipped as iCloud account is not found and remaining files Uploaded Successfully"
            }
        }
        else {
            
            msg = "Files Uploaded Successfully"
        }
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            
           // ProjectManager.sharedInstance.uploadsFileAudioVideoDelegate?.refreshDir()
            
            ProjectManager.sharedInstance.refreshTimeLineDelegate?.refreshTimeLine()
            self.dismiss(animated: true, completion: nil)
            
            
            
        }
        alert.addAction(OKAction)
        
        
        
        self.present(alert, animated: true, completion: nil)
        uploadFileLbl.text = "Upload Files"
        self.index = 0
        self.assets.removeAll()
        self.icloudArray.removeAll()
        self.urlsAarray.removeAll()
        
        
        
    }
    
    
    func didFindAudioFile(found: URL) {
        print("hsjkd")
    }
    @IBOutlet weak var uploadFileLbl: UILabel!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var selectChildTextField: UITextField!
    @IBOutlet weak var selectChildBtn: UIButton!
    @IBOutlet weak var selectDirectoryTextField: UITextField!
    @IBOutlet weak var selectDirectoryBtn: UIButton!
    @IBOutlet weak var enterTagTextField: MultiAutoCompleteTextField!
    @IBOutlet weak var scrollViw: UIScrollView!
    @IBOutlet weak var browseBtn: UIButton!
    @IBOutlet weak var uplaodNowBtn: UIButton!
    @IBOutlet weak var pickerInputView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var adminBtn: UIButton!
    @IBOutlet weak var childBtn: UIButton!
    @IBOutlet weak var adminRoundView: UIView!
    @IBOutlet weak var adminFillView: UIView!
    @IBOutlet weak var childRoundView: UIView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var childFillView: UIView!
    @IBOutlet weak var selectChildView: UIView!
    @IBOutlet weak var selectDirectoryView: UIView!
    @IBOutlet weak var noteTagLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var adminView: UIView!
    
    
    
    
    
    var activeField: UITextField?
    
    var tagsArray = [String]()
    var myPickerController = UIImagePickerController()
    var index = Int()
    var assets = [PHAsset]()
    var urlsAarray = [URL]()
    var type = String()
    var textFieldPressedValue = Int()
    var directoryArray = [KeyHolderObject]()
    var childArray = [KeyHolderObject]()
    var childDirArray = [KeyHolderObject]()
    var role = Int()
    var adminArray = [KeyHolderObject]()
    var cloudBool = Bool()
    var icloudArray = [Bool]()
    var singleFileMsg = String()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        type = "admin"
        
        browseBtn.layer.cornerRadius = 22
        browseBtn.clipsToBounds = true
        
        uplaodNowBtn.layer.cornerRadius = 20
        uplaodNowBtn.clipsToBounds = true
        
        adminRoundView.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: adminRoundView.frame.height/2)
        adminFillView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: adminFillView.frame.height/2)
        
        childRoundView.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: adminRoundView.frame.height/2)
        childFillView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: childFillView.frame.height/2)
        showPicker()
        
       // getChildList()
        
        getDirectoriesList()
        
        
        
        
        //  chooseDateTextField.delegate = self
        enterTagTextField.delegate = self
        enterTagTextField.leftViewMode = .always
        let viw =  UIView(frame: CGRect(x:0, y:0, width: 60, height: 60))
        let tagIcon = UIImageView(frame: CGRect(x:17, y:22, width: 16, height: 16))
        tagIcon.image = UIImage(named: "enterTag-Icon")
        viw.addSubview(tagIcon)
        enterTagTextField.leftView = viw
        
        
        selectChildTextField.delegate = self
        selectChildTextField.leftViewMode = .always
        let viw1 =  UIView(frame: CGRect(x:0, y:0, width: 60, height: 60))
        let childIcon = UIImageView(frame: CGRect(x:17, y:22, width: 16, height: 16))
        childIcon.image = UIImage(named: "child")
        viw1.addSubview(childIcon)
        selectChildTextField.leftView = viw1
        
        selectDirectoryTextField.delegate = self
        selectDirectoryTextField.leftViewMode = .always
        let viw2 =  UIView(frame: CGRect(x:0, y:0, width: 60, height: 60))
        let directoryIcon = UIImageView(frame: CGRect(x:17, y:22, width: 16, height: 16))
        directoryIcon.image = UIImage(named: "selectDirectry-Icon")
        viw2.addSubview(directoryIcon)
        selectDirectoryTextField.leftView = viw2
        
        showDatePicker()
        ProjectManager.sharedInstance.uploadDelegate = self
        ProjectManager.sharedInstance.uploadSingleDelegate = self

        
        
        
        
        
        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil) {
            
            if let  userRole = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
            
            role = userRole
            
            if role == 6 {
                
                selectionView.isHidden = true
                selectChildView.isHidden = true
                
                selectionView.translatesAutoresizingMaskIntoConstraints = true
                adminView.translatesAutoresizingMaskIntoConstraints = true
                selectDirectoryView.translatesAutoresizingMaskIntoConstraints = true
                noteLabel.translatesAutoresizingMaskIntoConstraints = true
                
                adminView.frame = CGRect(x: adminView.frame.origin.x , y: selectionView.frame.origin.y
                    , width: adminView.frame.size.width, height: adminView.frame.size.height)
                
                selectDirectoryView.frame = CGRect(x: selectDirectoryView.frame.origin.x , y: selectDirectoryView.frame.origin.y
                    , width: UIScreen.main.bounds.size.width - 50, height: selectDirectoryView.frame.size.height)
                
                noteLabel.frame = CGRect(x: noteLabel.frame.origin.x , y: noteLabel.frame.origin.y
                    , width: UIScreen.main.bounds.size.width - 30, height: noteLabel.frame.size.height)
                
                
                
            }
                
            else {
                
                selectionView.isHidden = false
                selectChildView.isHidden = false
                
                if type == "child" {
                    
                    getChildList()
                }
                
            }
            
        }
            
            else {
                
                if type == "child" {
                    getChildList()
                }
                
            }
            
        }
        
        else {
            
            if type == "child" {
                getChildList()
            }

        }
        
        self.parent?.view.endEditing(true)

        
        
        // Do any additional setup after loading the view.
        
        //self.view.endEditing(true)
        
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
    
    
    
    //MARK:-
    //MARK:- Picker Method
    
    @objc func showPicker()
    {
        
        selectDirectoryTextField.inputView = pickerInputView
        selectDirectoryTextField.inputAccessoryView = nil
        selectChildTextField.inputView = pickerInputView
        selectChildTextField.inputAccessoryView = nil
        
        
    }
    
    
    //MARK:-
    //MARK:- ImagePicker Delegate
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
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
        
        if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset,
            let creationDate = asset.creationDate {
            print(creationDate) // Here is the date when your image was taken
        }
        
        self.dismiss(animated: false) {
            let vc:PreviewController = self.storyboard?.instantiateViewController(withIdentifier:"PreviewController") as! PreviewController
            vc.selectedImg = image
            self.present(vc, animated: true, completion:nil)
        }
        
        
    }
    //MARK:-
    //MARK:- TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == selectDirectoryTextField && type == "child" && (selectChildTextField.text?.isEmpty)! {
            
            selectDirectoryTextField.isEnabled = false
            selectDirectoryTextField.isUserInteractionEnabled = false

            
            
        }
        
        else {
            
             selectDirectoryTextField.isEnabled = true
             selectDirectoryTextField.isUserInteractionEnabled = true

        }
        
        
        if textField == selectChildTextField {
            
              textFieldPressedValue = 1
             type = "child"
            
           
        }
        if textField == selectDirectoryTextField && type == "admin" {
            
            textFieldPressedValue = 2
     
        }
        
        pickerView.reloadAllComponents()
        
        return true
    }
    
    
    
    //MARK:-
    //MARK:- IBAction Methods
    
    @IBAction func adminSelectionBtnAction(_ sender: Any) {
        
         type = "admin"
         self.view.endEditing(true)
        
        selectDirectoryTextField.text = ""
        selectChildTextField.text = ""
        enterTagTextField.text = ""
        
        directoryArray = adminArray
        
        selectDirectoryTextField.isEnabled = true
        selectDirectoryTextField.isUserInteractionEnabled = true
        
       
        adminFillView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        childFillView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        selectChildView.isHidden = true
        
        adminView.translatesAutoresizingMaskIntoConstraints = true
        selectChildView.translatesAutoresizingMaskIntoConstraints = true
        
        
        selectChildView.frame = CGRect(x: selectChildView.frame.origin.x , y: selectChildView.frame.origin.y
            , width: selectChildView.frame.size.width, height: selectChildView.frame.size.height)
        
        adminView.frame = CGRect(x: adminView.frame.origin.x , y: selectChildView.frame.origin.y
            , width: adminView.frame.size.width, height: adminView.frame.size.height)
        
        
    }
    
    @IBAction func childSelectionBtnAction(_ sender: Any) {
        
         type = "child"
        
        childArray.removeAll()
        childDirArray.removeAll()
        
         getChildList()
        
         self.view.endEditing(true)
        
        selectChildTextField.isEnabled = true
        selectChildTextField.isUserInteractionEnabled = true
        
        selectDirectoryTextField.isEnabled = false
        selectDirectoryTextField.isUserInteractionEnabled = false

        
        selectDirectoryTextField.text = ""
        selectChildTextField.text = ""
        enterTagTextField.text = ""
        
        directoryArray.removeAll()
        
       
        childFillView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        adminFillView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        selectChildView.isHidden = false
        
        adminView.translatesAutoresizingMaskIntoConstraints = true
        selectChildView.translatesAutoresizingMaskIntoConstraints = true
        
        selectChildView.frame = CGRect(x: selectChildView.frame.origin.x , y: selectChildView.frame.origin.y
            , width: selectChildView.frame.size.width, height: selectChildView.frame.size.height)
        
        adminView.frame = CGRect(x: adminView.frame.origin.x , y: selectChildView.frame.origin.y + selectChildView.frame.size.height + 5
            , width: adminView.frame.size.width, height: adminView.frame.size.height)
        
        
    }
    
    
    
    @IBAction func selectDirectoryButtonAction(_ sender: Any)
    {
        
        print("abc")
    }
    
    @IBAction func selectChildButtonAction(_ sender: Any)
    {
        
        print("abcd")
    }
    
    @IBAction func enterTagButtonAction(_ sender: Any)
    {
        
        print("abcde")
    }
    
    @IBAction func cancelToolButtonAction(_ sender: Any)
    {
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
        
    }
    
    
    
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        
        let row = pickerView.selectedRow(inComponent: 0)
        
        if textFieldPressedValue == 1 {
            
            if childArray.count > 0 {
                selectChildTextField.text = childArray[row].name
                
                selectDirectoryTextField.text = ""
                
                self.childDirArray.removeAll()
               
                self.getChildDirectoriesList()
            }
            
            
        }
            
        else if textFieldPressedValue == 2 {
            
            if type == "child" {
                
                if childDirArray.count > 0 {
                    
                    selectDirectoryTextField.text = childDirArray[row].dir_name
                    
                }
            }
                
                
            else {
                if directoryArray.count > 0 {
                    selectDirectoryTextField.text = directoryArray[row].dir_name
                    
                }
                
            }
            
        }
        
        self.view.endEditing(true)
        
        
        
    }
    
    @IBAction func browseButtonAction(_ sender: Any)
    {
        
        let alertController = UIAlertController(title:"", message:"", preferredStyle: .actionSheet)
        let cameraAction =  UIAlertAction(title:"Photos And Videos", style:.default) { (action) in
            let picker = AssetsPickerViewController()
            picker.pickerDelegate = self
            self.present(picker, animated: true, completion: nil)
        }
        let browseAction = UIAlertAction(title:"Browse", style:.default) { (action) in
            
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeWaveformAudio) , String(kUTTypeAudio), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
            documentPicker.allowsMultipleSelection = true
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
            
            
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(browseAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func uplaodNowButtonAction(_ sender: Any)
    {
        cloudBool = false
        icloudArray.removeAll()
        let dir:String = (selectDirectoryTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        let childDir:String = (selectChildTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if dir.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter Directory", vc: self.parent!)
            
        }
        else if type == "child" && childDir.isEmpty  {
            
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter child Directory", vc: self.parent!)
            
        }
        
      else  if assets.count == 0 && self.urlsAarray.count == 0{
            
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Please choose atleast one file to upload", vc: self)
        }
            //        else if (chooseDateTextField.text?.isEmpty)!  {
            //            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Please choose date", vc: self)
            //        }
        else {
            if self.assets.count > 0
            {
                self.uploadPopup()
                self.sendData()
            }  else if self.urlsAarray.count > 0 {
                self.uploadPopup()
                self.sendData()
                
                
            }
            
            
        }
        
    }
    
    
    //MARK:-
    //MARK:- PickerView DataSources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if textFieldPressedValue == 1 {
            
            
            
            return childArray.count
            
        }
            
        else {
            
            if type == "child" {
                
                if childDirArray.count > 0 {
                
                return childDirArray.count
                    
                }
                
                else {
                    
                    return 0
                }
                
            }
                
            else {
                return directoryArray.count
                
            }
            
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if textFieldPressedValue == 1 {
            return childArray[row].name
        }
        else {
            
            if type == "child" {
                
                if childDirArray.count > 0 {
                
                return childDirArray[row].dir_name
                    
                }
                
                else {
                return ""
                }
            }
                
            else {
                
                return directoryArray[row].dir_name
            }
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //selectPickerIndex = row
        //        chooseDirTextField.text = pickerArray[row]
        //        dircollectionArray.append(pickerArray[row])
        //        directoryCollectionView.reloadData()
        
        
    }
    
    
    
    //MARK:-
    //MARK:- Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        activeField = textField
        
        if textField == selectDirectoryTextField {
            textFieldPressedValue = textField.tag
            showPicker()
            print("You edit myTextField")
        }
            
        else if textField == selectChildTextField {
            textFieldPressedValue = textField.tag
            showPicker()
            print("You edit myTextField")
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == enterTagTextField {
            activeField = nil
        }
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = enterTagTextField.text
        {
            getTags()
        }
        return true
    }
    
    
    @objc func showDatePicker()
    {
        //Formate Date
        //        datePicker.datePickerMode = .date
        //        chooseDateTextField.inputView = pickerInputView
        //        chooseDateTextField.inputAccessoryView = nil
        //        datePicker.maximumDate = Date()
        
    }
    
    //MARK:-
    //MARK:- Api Methods
    
    @objc func getTags()
    {
        
        // let todoEndpoint: String = "http://dev.loopleap.com/api/tags"
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            let parameters:[String : Any] = ["term":"tag"]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                //ProjectManager.sharedInstance.showLoader()
                
                
                
                Alamofire.request(baseURL + ApiMethods.tags, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
                    .responseJSON { response in
                        
                        //  ProjectManager.sharedInstance.stopLoader()
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
                        
                        if let data = json["data"] as? [String]
                        {
                            print(data)
                            self.tagsArray.append(contentsOf: data)
                            print(self.tagsArray)
                            self.enterTagTextField.maximumAutoCompleteCount = data.count
                            self.enterTagTextField.autoCompleteStrings?.removeAll()
                            
                            self.enterTagTextField.autoCompleteStrings = data
                            self.enterTagTextField.reload()
                            //                     {
                            //                         print("done")
                            //
                            //                    }
                            //
                            //                    else
                            //                     {
                            //                          print("Undone")
                            //                          self.enterTagTextField.autoCompleteStrings = [self.enterTagTextField.text] as? [String]
                            //
                            //                    }
                            
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
    
    func sendData()
    {
        
        let row = self.pickerView.selectedRow(inComponent: 0)
  
        if self.assets.count > 0 {
            
            if self.index < assets.count {
                let asset = self.assets[self.index]
                if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
                {
                    let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                    //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
                    let headers = [
                        "Authorization": token_type + accessToken,
                        "Accept": "application/json"
                    ]
                    if ProjectManager.sharedInstance.isInternetAvailable() {
                        
                        let requestImageOption = PHImageRequestOptions()
//                        requestImageOption.resizeMode = PHImageRequestOptionsResizeMode.exact
                      requestImageOption.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
                        requestImageOption.isSynchronous = true
                        requestImageOption.isNetworkAccessAllowed = true
                        // this one is key
                        
                        let url = baseURL + ApiMethods.uploadFileAPI
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let imgParam = "files[]"
                        var fileSize =  Int()
                        let manager = PHImageManager.default()
                        var createdDate = asset.creationDate
                        print(asset.creationDate!)
                        let fileName : String = asset.value(forKey: "filename") as! String
                        print(fileName)
                        
                        let delimiter = "."
                        var newstr = fileName
                        var orignalFileName = newstr.components(separatedBy: delimiter)
                        print (orignalFileName[0])
                       
                        
                        
                        if asset.mediaType == .image {
                            manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode:PHImageContentMode.default, options: requestImageOption) { image , dict in
                                if image == nil {
                                    self.index = self.index + 1
                                    let obj = ImageObject()
                                    obj.TotalImages = self.assets.count
                                    obj.CurrentImageNo = self.index
                                    
                                    if self.assets.count == 1 {
                                        if !self.cloudBool {
                                            
                                            
                                            self.cloudBool =  true
                                            
                                        }
                                        self.uploadFileLbl.text = "Upload Files"
                                        self.index = 0
                                        self.assets.removeAll()
                                        self.urlsAarray.removeAll()
                                        if  UIApplication.topViewController() is PopupDialog {
                                            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Image from iCloud is not available for sync as iCloud account is not found. ", vc: UIApplication.topViewController()!)
                                            })
                                        }
                                        
                                            
                                    
                                       
                                    }
                                   else if self.assets.count > 1 {
                                       
                                       self.icloudArray.append(true)
                                        NotificationCenter.default.post(name:.uploadMultipleImages, object:obj )
                                           self.sendData()
                                    }
                                    
                                    
                                   
                                    
                                    
                                  
                                } else {
                                fileSize = UIImageJPEGRepresentation(image!, 1.0)!.count / 1024
                               
                                var params = [String:Any]()
                                if self.type == "admin" {
                                    params = ["file_date": dateFormatter.string(from: createdDate!), "file_size": String(fileSize), "tags": self.enterTagTextField.text!, "type":self.type, "directory_id":self.directoryArray[row].dir_id]
                                }
                                    
                                else {
                                    params = ["file_date": dateFormatter.string(from: createdDate!), "file_size": String(fileSize), "tags": self.enterTagTextField.text!, "type":self.type, "directory_id":self.childDirArray[row].dir_id, "child_id":self.childArray[row].id]
                                }
                                
                                print(url , params) //dateFormatter.string(from:Date()) as String   // (Date().ticks).jpeg
                                Alamofire.upload(multipartFormData: { (multipartFormData) in
                                    multipartFormData.append(UIImageJPEGRepresentation(image!, 0.4)!, withName: imgParam, fileName: "\(orignalFileName[0]).jpeg", mimeType: "image/jpeg")
                                    for (key, value) in params {
                                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                                    }
                                }, to:url, headers:headers)
                                { (result) in
                                    
                                    self.delegate?.refresh()
                                    switch result {
                                        
                                        
                                        
                                    case .success(let upload, _, _):
                                        if self.assets.count == 1 {
                                            upload.uploadProgress(closure: { (progress) in
                                                if progress.fractionCompleted != 1 {
                                                NotificationCenter.default.post(name:.uploadProgress, object:progress )
                                                    
                                                }
                                                
                                            })
                                        }
                                        upload.responseJSON { response in
                                            
                                      
                                            if response.result.isFailure {
                                                DispatchQueue.main.async {
                                                    
                                                    //                                    ProjectManager.sharedInstance.showServerError(viewController:self)
                                                    
                                                    
                                                    
                                                }
                                            }
                                            else {
                                                print("cancel Request")
                                                print(response.result.value)
                                                
                                                if let response = response.result.value as? [String: Any] {
                                                    
                                                                                                        if let status = response["status"] as? NSNumber {
                                                    
                                                                                                            if status == 1 {
                                                    
                                                                                                                if self.assets.count == 1{
                                                                                                                    
                                                                   NotificationCenter.default.post(name:.uploadProgress, object:true )
                                                                                                                    
                                                                                                                    let msg = response["message"] as? String
                                                                                                                    self.uploadFileLbl.text = "Upload Files"
                                                                                                                    self.index = 0
                                                                                                                    self.assets.removeAll()
                                                                                                                    self.icloudArray.removeAll()
                                                                                                                    self.urlsAarray.removeAll()
                                                                                                           //ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: self.parent!)
                                                                        
                                                                                                                    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                                                                                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                                                                                                        
                                                                                                                        
                                                                                                                        // ProjectManager.sharedInstance.uploadsFileAudioVideoDelegate?.refreshDir()
                                                                                                                        
                                                                                                                        ProjectManager.sharedInstance.refreshTimeLineDelegate?.refreshTimeLine()
                                                                                                                        self.dismiss(animated: true, completion: nil)
                                                                                                                        
                                                                                                                        
                                                                                                                        
                                                                                                                    }
                                                                                                                    alert.addAction(OKAction)
                                                                                                                    
                                                                                                                    
                                                                                                                    
                                                                                                                    self.present(alert, animated: true, completion: nil)
                                                                                                                 
                                                                                                                }
                                                                                                                
                                                                                                                else {
                                                                                                                self.index = self.index + 1
                                                                                                                let obj = ImageObject()
                                                                                                                obj.TotalImages = self.assets.count
                                                                                                                obj.CurrentImageNo = self.index
                                                                                                                if self.assets.count > 1 {
                                                                                                                    NotificationCenter.default.post(name:.uploadMultipleImages, object:obj )
                                                                                                                }
                                                                                                                
                                                                                                                self.sendData()
                                                                                                                    
                                                                                                                }
//                                                                                                                let msg = response["message"] as? String
//                                                                                                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                                    
                                                                                                            }
                                                    
                                                                                                            else {
                                                    
                                                                                                                self.uploadFileLbl.text = "Upload Files"
                                                                                                                self.index = 0
                                                                                                                self.assets.removeAll()
                                                                                                                self.urlsAarray.removeAll()
                                                                                                                if  UIApplication.topViewController() is PopupDialog {
                                                                                                                    UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                                                    
                                                                                                                        
                                                                                                                        let msg = response["message"] as? String
                                                                                                                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                                                                                                    })
                                                                                                                    
                                                                                                                }
                                                                                                                
                                                                                                                
                                                                                                            }
                                                    
                                                                                                        }
                                                }
                                            }
                                            
                                            //print response.result
                                        }
                                        
                                    case .failure(let _):
                                        
                                        print("cancel Request")
                                        break
                                    }
                                }
                                
                            }
                        }
                        }
                            
                            
                        else {
                            
                            // let date = self.chooseDateTextField.text!
                            let tag = self.enterTagTextField.text!
                            let options = PHVideoRequestOptions()
                            options.version = .original
                            options.deliveryMode = .automatic
                            options.isNetworkAccessAllowed = true
                            
                            manager.requestAVAsset(forVideo: asset, options: options) { (asset, audiomix, dict) in
                                if let avassetURL = asset as? AVURLAsset {
                                    if let videoData = try? Data(contentsOf: avassetURL.url) {
                                    
                                    
                                    fileSize = videoData.count / 1024
                                    
                                    var params = [String:Any]()
                                    if self.type == "admin" {
                                        
                                        params = ["file_date":dateFormatter.string(from: createdDate!), "file_size": String(fileSize), "tags": tag, "type":self.type, "directory_id":self.directoryArray[row].dir_id]
                                    }
                                        
                                    else {
                                        params = ["file_date": dateFormatter.string(from: createdDate!), "file_size": String(fileSize), "tags": tag, "type":self.type, "directory_id":self.childDirArray[row].dir_id, "child_id":self.childArray[row].id]
                                    }
                                    
                                    
                                    print(url , params)
                                    
                                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                                        multipartFormData.append(videoData, withName: imgParam, fileName: "\(orignalFileName[0]).mp4", mimeType: "video/mp4")
                                        for (key, value) in params {
                                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                                        }
                                    }, to:url, headers:headers)
                                    { (result) in
                                        
                                        
                                        switch result {
                                            
                                            
                                            
                                        case .success(let upload, _, _):
                                            if self.assets.count == 1 {
                                                upload.uploadProgress(closure: { (progress) in
                                                    if progress.fractionCompleted != 1 {
                                                        NotificationCenter.default.post(name:.uploadProgress, object:progress )
                                                        
                                                    }
                                                    
                                                })
                                            }
                                            upload.responseJSON { response in
                                             
                                                if response.result.isFailure {
                                                    print("cancel Request")
                                                }
                                                else {
                                                    
                                                    print(response.result.value)
                                                    
                                                    if let response = response.result.value as? [String: Any] {
                                                        
                                                        if let status = response["status"] as? NSNumber {
                                                            
                                                            if status == 1 {
                                                                
                                                                let msg = response["message"] as? String
                                                                
                                                                
                                                                
                                                                if self.assets.count == 1 {
                                                                    
                                                                    NotificationCenter.default.post(name:.uploadProgress, object:true )
                                                                    
                                                                    self.uploadFileLbl.text = "Upload Files"
                                                                    self.index = 0
                                                                    self.assets.removeAll()
                                                                    self.icloudArray.removeAll()
                                                                    self.urlsAarray.removeAll()
                                                                    
                                                                    let msg = response["message"] as? String
                                                                    //ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: self.parent!)
                                                                    
                                                                    
                                                                    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                                                        
                                                                        
                                                                        // ProjectManager.sharedInstance.uploadsFileAudioVideoDelegate?.refreshDir()
                                                                        
                                                                        ProjectManager.sharedInstance.refreshTimeLineDelegate?.refreshTimeLine()
                                                                        self.dismiss(animated: true, completion: nil)
                                                                        
                                                                        
                                                                        
                                                                    }
                                                                    alert.addAction(OKAction)
                                                                    
                                                                    
                                                                    
                                                                    self.present(alert, animated: true, completion: nil)
                                                                    
                                                                    
                                                                  
                                                                    
                                                                }
                                                                    
                                                                else {
                                                                
                                                                self.index = self.index + 1
                                                                let obj = ImageObject()
                                                                obj.TotalImages = self.assets.count
                                                                obj.CurrentImageNo = self.index
                                                                if self.assets.count  > 1 {
                                                                    NotificationCenter.default.post(name:.uploadMultipleImages, object:obj )
                                                                }
                                                                self.sendData( )
                                                                    
                                                                }
//                                                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                                                
                                                            }
                                                                
                                                            else {
                                                                
                                                                self.uploadFileLbl.text = "Upload Files"
                                                                self.index = 0
                                                                self.assets.removeAll()
                                                                self.urlsAarray.removeAll()
                                                                if  UIApplication.topViewController() is PopupDialog || UIApplication.topViewController() is UIAlertController  {
                                                                    UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                                                        
                                                                        
                                                                        let msg = response["message"] as? String
                                                                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                                                    })
                                                                }
                                                                
                                                                
                                                            }
                                                            
                                                        }
                                                    }
                                                }
                                                
                                                //print response.result
                                            }
                                            
                                        case .failure(let _):
                                            DispatchQueue.main.async {
                                                
                                            }
                                            
                                            break
                                        }
                                    }
                                    
                                }
                                    
                                    else {
                                        
                                        self.index = self.index + 1
                                        let obj = ImageObject()
                                        obj.TotalImages = self.assets.count
                                        obj.CurrentImageNo = self.index
                                        
                                        if self.assets.count == 1 {
                                            if !self.cloudBool {
                                                
                                                
                                                self.cloudBool =  true
                                                
                                            }
                                            self.uploadFileLbl.text = "Upload Files"
                                            self.index = 0
                                            self.assets.removeAll()
                                            self.urlsAarray.removeAll()
                                            if  UIApplication.topViewController() is PopupDialog {
                                                UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "File from iCloud is not available for sync as iCloud account is not found. ", vc: UIApplication.topViewController()!)
                                                })
                                            }
                                            
                                            
                                            
                                            
                                        }
                                        else if self.assets.count > 1 {
                                            
                                            self.icloudArray.append(true)
                                            NotificationCenter.default.post(name:.uploadMultipleImages, object:obj )
                                            self.sendData()
                                        }
                                        
                                        
                                        
                                        
                                        
                                        
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
            }
        }
        else {
            if self.index < urlsAarray.count {
                let mediaURL = self.urlsAarray[self.index]
                if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
                {
                    let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                    //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
                    let headers = [
                        "Authorization": token_type + accessToken,
                        "Accept": "application/json"
                    ]
                    if ProjectManager.sharedInstance.isInternetAvailable() {
                        var createdDate = Date()
                        do {
                            
                            let date = try  mediaURL.resourceValues(forKeys:[.creationDateKey])
                            createdDate = date.creationDate!
                            
                            
                            
                        }
                        catch {
                            
                        }
                        
                        let fileName =  mediaURL.lastPathComponent
                        print(fileName)
                       
                        let url = baseURL + ApiMethods.uploadFileAPI
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let imgParam = "files[]"
                        var fileSize =  Int()
                        do {
                            let attr: NSDictionary = try FileManager.default.attributesOfItem(atPath:mediaURL.path) as NSDictionary
                            print(attr.fileSize())
                            
                            fileSize = Int(attr.fileSize()/1024)
                            //                            let  params = ["file_date": dateFormatter.string(from: createdDate), "file_size": String(fileSize), "tags": self.enterTagTextField.text!] as [String : Any]
                            
                            
                            var params = [String:Any]()
                            if self.type == "admin" {
                                
                                params = ["file_date":dateFormatter.string(from: createdDate), "file_size": String(fileSize), "tags": self.enterTagTextField.text!, "type":self.type, "directory_id":self.directoryArray[row].dir_id]
                            }
                                
                            else {
                                params = ["file_date": dateFormatter.string(from: createdDate), "file_size": String(fileSize), "tags": self.enterTagTextField.text!, "type":self.type, "directory_id":self.childDirArray[row].dir_id, "child_id":self.childArray[row].id]
                            }
                            
                            print(url , params) //"\(Date().ticks).\(MimeType(url:mediaURL).ext!)
                            
                            let data = try Data(contentsOf:mediaURL )
                            Alamofire.upload(multipartFormData: { (multipartFormData) in
                                multipartFormData.append(data, withName: imgParam, fileName: "\(fileName)", mimeType: "\(MimeType(url:mediaURL).value)")
                                for (key, value) in params {
                                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                                }
                            }, to:url, headers:headers)
                            { (result) in
                                
                                
                                switch result {
                                    
                                    
                                    
                                case .success(let upload, _, _):
                                    if self.urlsAarray.count == 1 {
                                        upload.uploadProgress(closure: { (progress) in
                                            if progress.fractionCompleted != 1 {
                                                NotificationCenter.default.post(name:.uploadProgress, object:progress )
                                                
                                            }
                                            
                                        })
                                    }
                                    upload.responseJSON { response in
                                        
                                    
                                        
                                        if response.result.isFailure {
                                            DispatchQueue.main.async {
                                                
                                                //                                    ProjectManager.sharedInstance.showServerError(viewController:self)
                                            }
                                        }
                                        else {
                                            print("cancel Request")
                                            print(response.result.value)
                                            
                                            if let response = response.result.value as? [String: Any] {
                                                
                                                if let status = response["status"] as? NSNumber {
                                                    
                                                    if status == 1 {
                                                        
                                                        let msg = response["message"] as? String
                                                        
                                                        if self.urlsAarray.count == 1 {
                                                            
                                                            NotificationCenter.default.post(name:.uploadProgress, object:true )
                                                            
                                                            self.uploadFileLbl.text = "Upload Files"
                                                            self.index = 0
                                                            self.assets.removeAll()
                                                            self.icloudArray.removeAll()
                                                            self.urlsAarray.removeAll()
                                                            
                                                            let msg = response["message"] as? String
                                                            //ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: self.parent!)
                                                            
                                                            
                                                            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                                                
                                                                
                                                                // ProjectManager.sharedInstance.uploadsFileAudioVideoDelegate?.refreshDir()
                                                                
                                                                ProjectManager.sharedInstance.refreshTimeLineDelegate?.refreshTimeLine()
                                                                self.dismiss(animated: true, completion: nil)
                                                                
                                                                
                                                                
                                                            }
                                                            alert.addAction(OKAction)
                                                            
                                                            
                                                            
                                                            self.present(alert, animated: true, completion: nil)
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                        }
                                                            
                                                        else {
                                                            
                                                       
                                                        
                                                        self.index = self.index + 1
                                                        let obj = ImageObject()
                                                        obj.TotalImages = self.urlsAarray.count
                                                        obj.CurrentImageNo = self.index
                                                        if self.urlsAarray.count > 1 {
                                                            NotificationCenter.default.post(name:.uploadMultipleImages, object:obj )
                                                        }
                                                        
                                                        self.sendData( )
                                                            
                                                        }
//                                                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                                        
                                                    }
                                                        
                                                    else {
                                                        
                                                        self.uploadFileLbl.text = "Upload Files"
                                                        self.index = 0
                                                        self.assets.removeAll()
                                                        self.urlsAarray.removeAll()
                                                        if  UIApplication.topViewController() is PopupDialog {
                                                            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                                                
                                                                
                                                                let msg = response["message"] as? String
                                                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                                            })
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        
                                        //print response.result
                                    }
                                    
                                case .failure(let _):
                                    
                                    print("cancel Request")
                                    break
                                }
                            }
                            
                            
                        }
                        catch {
                            
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
        
       
    }
    
    
    func getOriginalAsset(asset: PHAsset, onComplete: @escaping (UIImage?, [AnyHashable: Any]?) -> ()) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (image, info) in
            onComplete(image, info)
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
                                
                                if data.count > 0 {
                                    self.selectDirectoryTextField.isEnabled = true

                                print(data)
                                self.directoryArray = ProjectManager.sharedInstance.GetKeyHolderListObjects(array: data)
                                    
                                    self.adminArray = ProjectManager.sharedInstance.GetKeyHolderListObjects(array: data)
                                }
                                
                                else {
                                    
                                    self.selectDirectoryTextField.isEnabled = false
                                    let msg = json["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                }
                                
                            }
                            else {
                                
                                self.selectDirectoryTextField.isEnabled = false
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                            
                        }
                        else {
                            
                            self.selectDirectoryTextField.isEnabled = false
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
    
    func getChildList() {
        
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
                
                
                Alamofire.request(baseURL + ApiMethods.childlistDropdown, method: .get,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
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
                                
                                if data.count > 0 {
                                    
                                     self.selectChildTextField.isEnabled = true
                                     self.selectDirectoryTextField.isEnabled = true
                                     self.selectChildTextField.isUserInteractionEnabled = true
                                     self.selectDirectoryTextField.isUserInteractionEnabled = true


                                    
                                    self.childArray = ProjectManager.sharedInstance.GetPublicDirObjects(array: data)
                                    
                                }
                                
                                else {
                                    
                                    self.selectChildTextField.isEnabled = false
                                    self.selectDirectoryTextField.isEnabled = false
                                    self.selectChildTextField.isUserInteractionEnabled = false
                                    self.selectDirectoryTextField.isUserInteractionEnabled = false

                                    let msg = json["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                    
                                }
                                
                            }
                            else{
                                
                                self.selectChildTextField.isEnabled = false
                                self.selectDirectoryTextField.isEnabled = false
                                self.selectChildTextField.isUserInteractionEnabled = false
                                self.selectDirectoryTextField.isUserInteractionEnabled = false

                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                            
                        }
                        else {
                           
                            self.selectChildTextField.isEnabled = false
                            self.selectDirectoryTextField.isEnabled = false
                            self.selectChildTextField.isUserInteractionEnabled = false
                            self.selectDirectoryTextField.isUserInteractionEnabled = false

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
    
    
    func getChildDirectoriesList() {
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            let row = pickerView.selectedRow(inComponent: 0)
            var parameters = [String: Any]()
            parameters = ["child_id":self.childArray[row].id]
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                 ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.childDirectory, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                    self.selectDirectoryTextField.isEnabled = true

                                print(data)
                                self.childDirArray = ProjectManager.sharedInstance.GetKeyHolderListObjects(array: data)
                                    
                                }
                                
                                else {
                                    
                                    self.selectDirectoryTextField.isEnabled = false
                                    let msg = json["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                }
                                
                            }
                            else {
                                
                                self.selectDirectoryTextField.isEnabled = false
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                            
                        }
                        else {
                            self.selectDirectoryTextField.isEnabled = false
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
    
    
    
    func showFilesLabel(files:Int) {
        let str = NSMutableAttributedString()
        let uploadStr = NSAttributedString(string:"Upload File" , attributes: [NSAttributedString.Key.font :UIFont(name:"Raleway-Medium", size: 14)!])
        let fileStr = NSAttributedString(string:"\n\n\(files) Files Selected *" , attributes: [NSAttributedString.Key.font :UIFont(name:"Raleway", size: 12)!])
        str.append(uploadStr)
        str.append(fileStr)
        self.uploadFileLbl.attributedText = str
    }
    
    
    
    //MARK:-
    //MARK:- Popup Method
    func uploadPopup() {
        
        let alertVC :UploadingPopUp = (self.storyboard?.instantiateViewController(withIdentifier: "UploadingPopUp") as? UploadingPopUp)!
        let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
        , tapGestureDismissal: false, panGestureDismissal: false) {
            let overlayAppearance = PopupDialogOverlayView.appearance()
            overlayAppearance.blurRadius  = 30
            overlayAppearance.blurEnabled = true
            overlayAppearance.liveBlur    = false
            overlayAppearance.opacity     = 0.4
        }
        
        alertVC.cancelBtnClick = {
            self.index = self.index + 1
            
            if self.assets.count > 0 {
                if self.index == self.assets.count - 1 || self.index > self.assets.count {
                    self.assets.removeAll()
                    self.urlsAarray.removeAll()
                    self.index = 0
                    DispatchQueue.main.async {
                        let uploadStr = NSAttributedString(string:"Upload File" , attributes: [NSAttributedString.Key.font :UIFont(name:"Raleway-Medium", size: 14)!])
                        self.uploadFileLbl.attributedText = uploadStr
                    }
                    popup.dismiss(animated:true , completion: {
                        
                    })
                    
                }
            }
            else {
                if self.index == self.urlsAarray.count - 1  || self.index > self.urlsAarray.count {
                    
                    self.assets.removeAll()
                    self.urlsAarray.removeAll()
                    self.index = 0
                    DispatchQueue.main.async {
                        let uploadStr = NSAttributedString(string:"Upload File" , attributes: [NSAttributedString.Key.font :UIFont(name:"Raleway-Medium", size: 14)!])
                        self.uploadFileLbl.attributedText = uploadStr
                    }
                    popup.dismiss(animated:true , completion: {
                        
                    })
                    
                }
            }
            //            popup.dismiss(animated:true , completion: {
            //
            //                let sessionManager = Alamofire.SessionManager.default
            //                sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in dataTasks.forEach {
            //                    $0.cancel() }
            //                  //  sessionManager.session.invalidateAndCancel()
            //
            //                }
            
            //                let sessionManager = Alamofire.SessionManager.default
            //
            //                sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in dataTasks.forEach {
            //                    $0.cancel() }
            //                    uploadTasks.forEach { $0.cancel() }
            //                    downloadTasks.forEach { $0.cancel() }
            //                    Alamofire.SessionManager.default.session.invalidateAndCancel()
            //
            //                }
            //            })
            
        }
        
        alertVC.cancelAllBtnClick = {
            
            popup.dismiss(animated:true , completion: {
                //    Alamofire.SessionManager.default.session.invalidateAndCancel()
                
                if self.assets.count > 0 {
                    self.index = self.assets.count
                }
                else {
                    self.index = self.urlsAarray.count
                }
                let sessionManager = Alamofire.SessionManager.default
                sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in dataTasks.forEach {
                    $0.cancel() }
                    self.assets.removeAll()
                    self.urlsAarray.removeAll()
                    self.index = 0
                    DispatchQueue.main.async {
                        let uploadStr = NSAttributedString(string:"Upload File" , attributes: [NSAttributedString.Key.font :UIFont(name:"Raleway-Medium", size: 14)!])
                        self.uploadFileLbl.attributedText = uploadStr
                    }
                    // sessionManager.session.invalidateAndCancel()
                    
                }
            })
        }
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
        
        let alert = UIAlertController(title: "", message: "uplaoded Successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    // MARK:-
    // MARK:- UIDocumentPickerViewController Delegates
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        cloudBool = false
        self.index = 0
        self.assets.removeAll()
        self.urlsAarray.removeAll()
        var getSizeChk = Bool()
        if urls.count > 0 {
            
            
            for i in urls {
                
                do {
                    let attr: NSDictionary = try FileManager.default.attributesOfItem(atPath:i.path) as NSDictionary
                    print(attr.fileSize())
                    let sizeInMb:Float = (Float(attr.fileSize())/Float(1024))/Float(1024)
                    if sizeInMb < 20 || sizeInMb == 20 {
                        
                        do{
                            let date = try i.resourceValues(forKeys: [.creationDateKey])
                            print(date.creationDate!)
                        }
                        catch{}
                        
                        self.urlsAarray.append(i)
                    }
                    else {
                        getSizeChk = true
                    }
                    
                } catch {
                    print(error)
                }
            }
            if getSizeChk {
                
                let alertController = UIAlertController(title:"Message", message:"Some of the files size is greater than 20 MB", preferredStyle: .alert)
                let okAction =  UIAlertAction(title:"OK", style:.default) { (action) in
                    
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            self.showFilesLabel(files: self.urlsAarray.count)
            
            
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Cancel")
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

extension UploadFileViewController: AssetsPickerViewControllerDelegate {

    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {

    }

    func assetsPickerDidCancel(controller: AssetsPickerViewController) {

    }

    func assetsPicker(controller: AssetsPickerViewController, didDismissByCancelling byCancel: Bool) {
        print("dismiss \(byCancel)")
        if !byCancel {
            let assets = self.assets
            self.urlsAarray.removeAll()
            self.assets.removeAll()
            var getSizeChk = Bool()
            for i in assets {

                let resources = PHAssetResource.assetResources(for: i) // your PHAsset

                var sizeOnDisk: Int64? = 0

                if let resource = resources.first {
                    let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                    sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
                    print(sizeOnDisk!)
                    let sizeInMb:Float = (Float(sizeOnDisk!)/Float(1024))/Float(1024)
                    if sizeInMb < 20 || sizeInMb == 20 {
                        self.assets.append(i)
                    }
                    else {
                        getSizeChk = true
                    }
                    print(sizeInMb)
                }
            }

            if getSizeChk {

                let alertController = UIAlertController(title:"Message", message:"Some of the files size is greater than 20 MB", preferredStyle: .alert)
                let okAction =  UIAlertAction(title:"OK", style:.default) { (action) in

                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)

            }

            self.showFilesLabel(files: self.assets.count)


            //  self.uploadPopup()
            //  self.sendData()
        }

    }
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        // do your job with selected assets
        self.index = 0
        self.assets = assets
        print(assets.count)


    }
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {

    }
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {}
}

class ImageObject1: NSObject {
    var TotalImages = Int()
    var CurrentImageNo = Int()
}

