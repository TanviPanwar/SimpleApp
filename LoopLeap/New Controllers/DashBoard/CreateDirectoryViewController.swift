//
//  CreateDirectoryViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 18/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//
import UIKit
import Alamofire
import MobileCoreServices
import AssetsPickerViewController
import Photos
import PopupDialog
import CoreServices

protocol RefreshDirListDelegate {
    func refreshDirList()
}



class CreateDirectoryViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate, GetImageDelegate {
    
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
    @IBOutlet weak var createDirectoryBtn: UIButton!
    @IBOutlet weak var pickerInputView: UIView!
    @IBOutlet weak var chooseDatePicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    
    var imageSent = UIImage()
    
    var myPickerController = UIImagePickerController()
    var delegate: RefreshDirListDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        browseBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: browseBtn.frame.height/2)
         createDirectoryBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: createDirectoryBtn.frame.height/2)
        
        showDatePicker()
        
        // Do any additional setup after loading the view.
    }
   
    //MARK:-
    //MARK:- TextField Delegate
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == directoryDateTextFiled {
//            return false; //do not show keyboard nor cursor
//        }
//        return true
//    }
    
    
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
    
    @IBAction func createDirectoryBtnAction(_ sender: Any) {
        
        addDirectroy()
    }
    
    
    @IBAction func cancelToolButtonAction(_ sender: Any)
    {
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        directoryDateTextFiled.text = formatter.string(from: chooseDatePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
        
    }
    
    
    //MARK:-
    //MARK:- Custom Methods
    
    @objc func showDatePicker()
    {
        //Formate Date
        chooseDatePicker.datePickerMode = .date
        directoryDateTextFiled.inputView = pickerInputView
        directoryDateTextFiled.inputAccessoryView = nil
        chooseDatePicker.maximumDate = Date()
        
        
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
    
    func addDirectroy() {
        
        let dirName:String = (directoryNameTextFiled.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let dirDate:String = (directoryDateTextFiled.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if dirName.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter name", vc: self)
        }
        else if dirName.count < 3 {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter atleast 3 characters name", vc: self)
        }
        else if  dirName.count > 50  {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter maximum 50 characters name", vc: self)
        }
        
        else if  dirDate.isEmpty  {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter directrory date", vc: self)
        }
        
        
        
        else {
            
            let parameters:[String : Any] = ["new_dir_name":dirName, "new_dir_date":dirDate]
            let imgParam = "new_dir_icon"
            
            ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWithParameters(params:parameters, url:baseURL + ApiMethods.addDirectories, image: directoryIcon.image, imageParam:imgParam) { (response, error) in
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
                            
                            
                            let msg = response!["message"] as? String
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
