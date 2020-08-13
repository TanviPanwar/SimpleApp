//
//  EditDirectoryViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 19/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import AssetsPickerViewController
import Photos
import PopupDialog
import CoreServices


class EditDirectoryViewController: UIViewController , UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate, GetImageDelegate {
    
    func didGetImage(image: UIImage) {
        print(image)
        directoryIcon.image = image
        imageSent = image
        
    }
    
    
    
    
    @IBOutlet weak var directoryNameTextFiled: UITextField!
    @IBOutlet weak var selectDirView: UIView!
    @IBOutlet weak var directoryDateTextFiled: TextField!
    @IBOutlet weak var browseBtn: UIButton!
    @IBOutlet weak var directoryIcon: UIImageView!
    @IBOutlet weak var updateDirectoryBtn: UIButton!
    @IBOutlet weak var makePublicSwitchBtn: UISwitch!
    
    @IBOutlet weak var makePublicView: UIView!
    @IBOutlet weak var onDeathBtn: UIButton!
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var nowBtn: UIButton!
    @IBOutlet weak var selectDateTextField: TextField!
    @IBOutlet weak var makePublicLabel: UILabel!
    
    @IBOutlet weak var onDeathView: UIView!
    @IBOutlet weak var onDateView: UIView!
    @IBOutlet weak var nowView: UIView!
    @IBOutlet weak var selectDateview: UIView!

    
    
    
    
    @IBOutlet weak var pickerInputView: UIView!
    @IBOutlet weak var chooseDatePicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    
    var imageSent = UIImage()
    var myPickerController = UIImagePickerController()
    var delegate: RefreshDirListDelegate?
    var obj = GetDirectoryListObject()
    var btnPressedValue = Int()
    var textFieldPressedValue = Int()
    var makePublic = "1"
    var public_type = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        updateData()
        showDatePicker()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:-
    //MARK:- Custom Methods
    
    func setUI(){
        
        btnPressedValue = onDeathBtn.tag
        public_type = "ondeath"
        selectDateTextField.delegate = self
        directoryNameTextFiled.delegate = self
        directoryNameTextFiled.leftViewMode = .always
        let viw =  UIView(frame: CGRect(x:0, y:0, width: 60, height: 60))
        let tagIcon = UIImageView(frame: CGRect(x:17, y:22, width: 16, height: 16))
        tagIcon.image = UIImage(named: "selectDirectry-Icon")
        viw.addSubview(tagIcon)
        directoryNameTextFiled.leftView = viw
        
        
        directoryDateTextFiled.delegate = self
        directoryDateTextFiled.leftViewMode = .always
        let viw1 =  UIView(frame: CGRect(x:0, y:0, width: 60, height: 60))
        let childIcon = UIImageView(frame: CGRect(x:17, y:22, width: 16, height: 16))
        childIcon.image = UIImage(named: "DOB")
        viw1.addSubview(childIcon)
        directoryDateTextFiled.leftView = viw1
        
        browseBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: browseBtn.frame.size.height/2)
        updateDirectoryBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: updateDirectoryBtn.frame.height/2)
        
        onDeathBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: onDeathBtn.frame.size.height/2)
        selectDateBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: onDeathBtn.frame.size.height/2)
        nowBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: onDeathBtn.frame.size.height/2)
        
        onDeathView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: onDeathView.frame.height/2)
        onDateView.setBorder(width:1 , color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: onDateView.frame.height/2)
         nowView.setBorder(width:1 , color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: onDateView.frame.height/2)
        
    }
    
    func updateData() {
        
        directoryNameTextFiled.text = obj.dir_name
        directoryDateTextFiled.text = obj.dir_date
        if directoryNameTextFiled.text == "Main Directory" {
            
            directoryNameTextFiled.isUserInteractionEnabled = false
        }
        
        else  {
            
            directoryNameTextFiled.isUserInteractionEnabled = true
        }
        
        directoryIcon.sd_setImage(with: URL(string : obj.dir_icon), placeholderImage: UIImage(named: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
        }
            
            print("public type****",self.obj.public_type)
            
            if self.obj.public_type == "ondate" {
                
                self.public_type = "ondate"
                // self.makePublic = self.obj.is_public
                self.makePublicSwitchBtn.setOn(true, animated: false)
                self.makePublicView.isHidden = false
                self.selectDateview.isHidden = false
                self.selectDateTextField.text = self.obj.public_date
                //      self.btnPressedValue = self.selectDateBtn.tag
                
//                self.selectDateBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
//                self.onDeathBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                self.nowBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                self.onDateView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
                self.onDeathView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.nowView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                
                
                self.makePublicView.translatesAutoresizingMaskIntoConstraints = true
                self.selectDateview.translatesAutoresizingMaskIntoConstraints = true
                self.updateDirectoryBtn.translatesAutoresizingMaskIntoConstraints = true
                
                
                self.makePublicView.frame = CGRect(x: 25 , y: self.makePublicView.frame.origin.y, width: UIScreen.main.bounds.width - 50, height: self.makePublicView.frame.size.height)
                
                self.selectDateview.frame = CGRect(x: 25 , y: self.makePublicView.frame.origin.y + self.makePublicView.frame.size.height + 20, width: UIScreen.main.bounds.width - 50, height: self.selectDateview.frame.size.height)
                
                self.updateDirectoryBtn.frame = CGRect(x: 25 , y: self.selectDateview.frame.origin.y + self.selectDateview.frame.size.height + 20, width: UIScreen.main.bounds.width - 50, height: self.updateDirectoryBtn.frame.size.height)
                
            }
                
            else if self.obj.public_type == "ondeath" {
                self.public_type = "ondeath"
                // self.makePublic = self.obj.is_public
                self.makePublicSwitchBtn.setOn(true, animated: false)
                self.makePublicView.isHidden = false
                self.selectDateview.isHidden = true
                // self.btnPressedValue = self.onDeathBtn.tag
                
//                self.onDeathBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
//                self.selectDateBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                self.nowBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                
                self.onDeathView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
                self.onDateView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.nowView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                
                self.makePublicView.translatesAutoresizingMaskIntoConstraints = true
                self.updateDirectoryBtn.translatesAutoresizingMaskIntoConstraints = true
                
                
                //                if self.selectDateTextField.isHidden == false {
                //                    self.selectDateTextField.isHidden = true
                //                    self.updateDirectoryBtn.frame = CGRect(x: self.updateDirectoryBtn.frame.origin.x , y: self.updateDirectoryBtn.frame.origin.y - self.selectDateTextField.frame.size.height
                //                        , width: self.updateDirectoryBtn.frame.size.width, height: self.updateDirectoryBtn.frame.size.height)
                //
                //                }
                //                else {
                
                self.makePublicView.frame = CGRect(x: 25 , y: self.makePublicView.frame.origin.y, width: UIScreen.main.bounds.width - 50, height: self.makePublicView.frame.size.height)
                
                self.updateDirectoryBtn.frame = CGRect(x: 25 , y: self.makePublicView.frame.origin.y + self.makePublicView.frame.size.height + 20, width: UIScreen.main.bounds.width
                    - 50, height: self.updateDirectoryBtn.frame.size.height)
                // }
                
            }
                
            else if self.obj.public_type == "now" {
                
                self.public_type = "now"
                
                //  self.makePublic = self.obj.is_public
                self.makePublicSwitchBtn.setOn(true, animated: false)
                self.makePublicView.isHidden = false
                self.selectDateview.isHidden = true
                // self.btnPressedValue =  self.nowBtn.tag
                
//                self.nowBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
//                self.onDeathBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                self.selectDateBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                
                self.nowView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
                self.onDateView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.onDeathView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                
                self.makePublicView.translatesAutoresizingMaskIntoConstraints = true
                self.updateDirectoryBtn.translatesAutoresizingMaskIntoConstraints = true
                
                self.makePublicView.frame = CGRect(x: 25 , y: self.makePublicView.frame.origin.y, width: UIScreen.main.bounds.width - 50, height: self.makePublicView.frame.size.height)
                
                self.updateDirectoryBtn.frame = CGRect(x: 25 , y: self.makePublicView.frame.origin.y + self.makePublicView.frame.size.height + 20, width: UIScreen.main.bounds.width
                    - 50, height: self.updateDirectoryBtn.frame.size.height)
                //
                //
                //                if  self.selectDateTextField.isHidden == false {
                //                     self.selectDateTextField.isHidden = true
                //                     self.updateDirectoryBtn.frame = CGRect(x:  self.updateDirectoryBtn.frame.origin.x , y:  self.updateDirectoryBtn.frame.origin.y -  self.selectDateTextField.frame.size.height
                //                        , width:  self.updateDirectoryBtn.frame.size.width, height:  self.updateDirectoryBtn.frame.size.height)
                //
                //                }
                //
                //                else {
                //                     self.selectDateTextField.isHidden = true
                //
                //                    self.makePublicLabel.frame = CGRect(x:  self.makePublicLabel.frame.origin.x , y:  self.makePublicLabel.frame.origin.y, width:  self.makePublicLabel.frame.size.width, height:  self.makePublicLabel.frame.size.height)
                //
                //                     self.makePublicView.frame = CGRect(x:  self.makePublicView.frame.origin.x , y:  self.makePublicView.frame.origin.y, width:  self.makePublicView.frame.size.width, height:  self.makePublicView.frame.size.height)
                //
                //                     self.updateDirectoryBtn.frame = CGRect(x:  self.updateDirectoryBtn.frame.origin.x , y:  self.makePublicView.frame.origin.y + self.makePublicView.frame.size.height + 20, width:  self.updateDirectoryBtn.frame.size.width, height:  self.updateDirectoryBtn.frame.size.height)
                //                }
                
            }
        
        
            else {
                
                
                makePublicSwitchBtn.isOn = false
                makePublic = ""
                
                
        }
            
            
            
      
        
        
        
        
        
        
    }
    
    //MARK:-
    //MARK:- TextField Delegate
    
    //        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //            if textField == directoryDateTextFiled {
    //               // textFieldPressedValue = textField.tag
    //                return false; //do not show keyboard nor cursor
    //            }
    //
    ////            else if textField == selectDateTextField {
    ////
    ////                textFieldPressedValue = textField.tag
    ////            }
    //            return true
    //        }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == directoryDateTextFiled {
            textFieldPressedValue = textField.tag
            print("You edit myTextField")
        }
            
        else if textField == selectDateTextField {
            textFieldPressedValue = textField.tag
            print("You edit myTextField")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func browseBtnAction(_ sender: Any) {
        
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
    
    @IBAction func updateDirectoryBtnAction(_ sender: Any) {
        
        updateDirectory()
    }
    
    
    @IBAction func cancelToolButtonAction(_ sender: Any)
    {
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if textFieldPressedValue == 4 {
            directoryDateTextFiled.text = formatter.string(from: chooseDatePicker.date)
        }
            
        else if textFieldPressedValue == 5 {
            selectDateTextField.text = formatter.string(from: chooseDatePicker.date)
            
        }
        //dismiss date picker dialog
        self.view.endEditing(true)
        
    }
    
    @IBAction func makePublicSwitchBtnAction(_ sender: Any) {
        
        
        
        makePublicView.translatesAutoresizingMaskIntoConstraints = true
        selectDateview.translatesAutoresizingMaskIntoConstraints = true
        updateDirectoryBtn.translatesAutoresizingMaskIntoConstraints = true
        
        if makePublicSwitchBtn.isOn {
            
            makePublic = "1"
            
            if btnPressedValue == 2 {
                
                selectDateview.isHidden = false
                makePublicView.isHidden = false
                
                
                makePublicView.frame = CGRect(x: makePublicView.frame.origin.x , y: makePublicView.frame.origin.y, width: makePublicView.frame.size.width, height: makePublicView.frame.size.height)
                
                selectDateview.frame = CGRect(x: selectDateview.frame.origin.x , y: makePublicView.frame.origin.y + makePublicView.frame.size.height + 20, width: selectDateview.frame.size.width, height: selectDateview.frame.size.height)
                
                updateDirectoryBtn.frame = CGRect(x: updateDirectoryBtn.frame.origin.x , y: selectDateview.frame.origin.y + selectDateview.frame.size.height + 20, width: updateDirectoryBtn.frame.size.width, height: updateDirectoryBtn.frame.size.height)
                
                
            }
                
            else {
                
                makePublicView.isHidden = false
                selectDateview.isHidden = true
                makePublicView.frame = CGRect(x: makePublicView.frame.origin.x , y: makePublicView.frame.origin.y, width: makePublicView.frame.size.width, height: makePublicView.frame.size.height)
                
                updateDirectoryBtn.frame = CGRect(x: updateDirectoryBtn.frame.origin.x , y: makePublicView.frame.origin.y + makePublicView.frame.size.height + 20, width: updateDirectoryBtn.frame.size.width, height: updateDirectoryBtn.frame.size.height)
                
                
            }
            
        }
        else {
            
            makePublic = ""
            public_type = ""
            
            if btnPressedValue == 2 {
                makePublicView.isHidden = true
                selectDateview.isHidden = true
                
                updateDirectoryBtn.frame = CGRect(x: updateDirectoryBtn.frame.origin.x , y: updateDirectoryBtn.frame.origin.y - (makePublicView.frame.size.height + selectDateview.frame.size.height) , width: updateDirectoryBtn.frame.size.width, height: updateDirectoryBtn.frame.size.height)
                
            }
                
            else {
                
                makePublicView.isHidden = true
                selectDateview.isHidden = true
                
                
                updateDirectoryBtn.frame = CGRect(x: updateDirectoryBtn.frame.origin.x , y: updateDirectoryBtn.frame.origin.y - makePublicView.frame.size.height , width: updateDirectoryBtn.frame.size.width, height: updateDirectoryBtn.frame.size.height)
                
            }
            
        }
        
    }
    
    @IBAction func onDeathBtnAction(_ sender: Any) {
        
        public_type = "ondeath"
        btnPressedValue = onDeathBtn.tag
        
        
//        onDeathBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
//        selectDateBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        nowBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.onDeathView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        self.onDateView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.nowView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        
        makePublicView.translatesAutoresizingMaskIntoConstraints = true
        updateDirectoryBtn.translatesAutoresizingMaskIntoConstraints = true
        
        
        if selectDateview.isHidden == false {
            selectDateview.isHidden = true
            updateDirectoryBtn.frame = CGRect(x: updateDirectoryBtn.frame.origin.x , y: updateDirectoryBtn.frame.origin.y - selectDateview.frame.size.height
                , width: updateDirectoryBtn.frame.size.width, height: updateDirectoryBtn.frame.size.height)
            
        }
        else {
            selectDateview.isHidden = true
            
            makePublicView.frame = CGRect(x: makePublicView.frame.origin.x , y: makePublicView.frame.origin.y, width: makePublicView.frame.size.width, height: makePublicView.frame.size.height)
            
            updateDirectoryBtn.frame = CGRect(x: updateDirectoryBtn.frame.origin.x , y: updateDirectoryBtn.frame.origin.y, width: updateDirectoryBtn.frame.size.width, height: updateDirectoryBtn.frame.size.height)
        }
    }
    
    
    @IBAction func selectDateBtnAction(_ sender: Any) {
        
        public_type = "ondate"
        btnPressedValue = selectDateBtn.tag
        
        
//        selectDateBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
//        onDeathBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        nowBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        self.onDateView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        self.onDeathView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.nowView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        
        
        selectDateview.isHidden = false
        
        makePublicView.translatesAutoresizingMaskIntoConstraints = true
        selectDateview.translatesAutoresizingMaskIntoConstraints = true
        updateDirectoryBtn.translatesAutoresizingMaskIntoConstraints = true
        
        
        makePublicView.frame = CGRect(x: makePublicView.frame.origin.x , y: makePublicView.frame.origin.y, width: makePublicView.frame.size.width, height: makePublicView.frame.size.height)
        
        selectDateview.frame = CGRect(x: selectDateview.frame.origin.x , y: makePublicView.frame.origin.y + makePublicView.frame.size.height + 20, width: selectDateview.frame.size.width, height: selectDateview.frame.size.height)
        
        updateDirectoryBtn.frame = CGRect(x: updateDirectoryBtn.frame.origin.x , y: selectDateview.frame.origin.y + selectDateview.frame.size.height + 20, width: updateDirectoryBtn.frame.size.width, height: updateDirectoryBtn.frame.size.height)
        
        
    }
    
    @IBAction func nowBtnAction(_ sender: Any) {
        
        makePublic = "1"
        public_type = "now"
        btnPressedValue = nowBtn.tag
        
//        nowBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
//        onDeathBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        selectDateBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        self.nowView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        self.onDeathView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.onDateView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        
        
        makePublicView.translatesAutoresizingMaskIntoConstraints = true
        updateDirectoryBtn.translatesAutoresizingMaskIntoConstraints = true
        
        
        if selectDateview.isHidden == false {
            selectDateview.isHidden = true
            updateDirectoryBtn.frame = CGRect(x: updateDirectoryBtn.frame.origin.x , y: updateDirectoryBtn.frame.origin.y - selectDateview.frame.size.height
                , width: updateDirectoryBtn.frame.size.width, height: updateDirectoryBtn.frame.size.height)
            
        }
            
        else {
            selectDateview.isHidden = true
            
            makePublicView.frame = CGRect(x: makePublicView.frame.origin.x , y: makePublicView.frame.origin.y, width: makePublicView.frame.size.width, height: makePublicView.frame.size.height)
            
            updateDirectoryBtn.frame = CGRect(x: updateDirectoryBtn.frame.origin.x , y: updateDirectoryBtn.frame.origin.y, width: updateDirectoryBtn.frame.size.width, height: updateDirectoryBtn.frame.size.height)
        }
    }
    
    //MARK:-
    //MARK:- DatePicker Method
    
    @objc func showDatePicker()
    {
        //Formate Date
        chooseDatePicker.datePickerMode = .date
        directoryDateTextFiled.inputView = pickerInputView
        directoryDateTextFiled.inputAccessoryView = nil
        selectDateTextField.inputView = pickerInputView
        selectDateTextField.inputAccessoryView = nil
        chooseDatePicker.minimumDate = Date()
        
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
        directoryIcon.image = image
        self.dismiss(animated: false) {
            //            let vc:PreviewController = self.storyboard?.instantiateViewController(withIdentifier:"PreviewController") as! PreviewController
            //            vc.selectedImg = image
            //            let checkBool = true
            //            vc.directoryBool = checkBool
            //            vc.delegate = self
            //            self.present(vc, animated: true, completion:nil)
        }
        
    }
    
    
    
    //MARK:-
    //MARK:- API Methods
    
    func updateDirectory() {
        
        let dirName:String = (directoryNameTextFiled.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let dirDate:String = (directoryDateTextFiled.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let selectDate:String = (selectDateTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        self.view.endEditing(true)
        if dirName.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter name", vc: self)
        }
        else if dirName.count < 3 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 3 characters name", vc: self)
        }
        else if  dirName.count > 50  {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter maximum 50 characters name", vc: self)
        }
            
            
        else if public_type == "ondate" && selectDate.isEmpty {
            
            
            
                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter date", vc: self)
            
        }
        else {
            
            
            //if dirName != "" && dirDate != "" {
            
            var parameters = [String : Any]()
            
            if makePublic == "1" {
            //if btnPressedValue == 2 && makePublic == "1"
            if public_type == "ondate" {
                
                guard selectDateTextField.text != "" else {
                    let alert = UIAlertController(title: "Error", message: "Please enter Date.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                    
                    return
                    
                }
                
                parameters = ["dir_id":obj.id, "new_dir_name":dirName, "new_dir_date":dirDate, "make_public":makePublic, "public_type":public_type, "public_date":selectDate]
                
            }
                
            else if public_type == "ondeath" // btnPressedValue == 1 && makePublic == "1"
                
            {
                parameters = ["dir_id":obj.id, "new_dir_name":dirName, "new_dir_date":dirDate, "make_public":makePublic, "public_type":public_type]
                
            }
                
            else if public_type == "now" { // btnPressedValue == 3 && makePublic == "1" {
                
                parameters = ["dir_id":obj.id, "new_dir_name":dirName, "new_dir_date":dirDate,"make_public":makePublic, "public_type":"now"]
            }
                
        }
                
            else {
                
               // makePublic  = "1"
                
                parameters = ["dir_id":obj.id, "new_dir_name":dirName, "new_dir_date":dirDate, "public_type":""]
            }
            
            let imgParam = "new_dir_icon"
            
            ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWithParameters(params:parameters, url:baseURL + ApiMethods.editDirectories, image: self.directoryIcon.image, imageParam:imgParam) { (response, error) in
                ProjectManager.sharedInstance.stopLoader()
                
                
                if response != nil {
                    if let status = response?["status"] as? NSNumber {
                        if status == 1 {
                            print(response!)
                            
                            if self.delegate != nil{
                                self.delegate?.refreshDirList()
                            }
                            
                            self.dismiss(animated: true, completion: {
                                
                                let msg = response!["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            })
                            
                        }
                        else {
                            
                            let msg = response?["message"] as? String
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            
                        }
                    }
                }
                
                else {
                    
                    
                    let msg = response!["message"] as? String
                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                }
                
                
            }
            
        }
        
        //        }
        //
        //        else {
        //            var message = String()
        //
        //            if dirName == "" && dirDate != "" {
        //
        //                message = "Please enter Directory Name."
        //            }
        //
        //            else if dirDate == "" && dirName != "" {
        //
        //                message = "Please enter Directory Date."
        //            }
        //
        //            else if dirName == "" && dirDate == "" {
        //
        //                message = "Please enter Directory Name and Directory Date."
        //            }
        //
        //            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        //            present(alert, animated: true, completion: nil)
        //        }
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
