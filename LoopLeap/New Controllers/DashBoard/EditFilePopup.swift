//
//  EditFilePopup.swift
//  LoopLeap
//
//  Created by iOS6 on 26/03/19.
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

protocol RefreshFilestDelegate {
    func refreshFileList()
}



class EditFilePopup: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var editNameTextFiled: UITextField!
    @IBOutlet weak var editDateTextFiled: UITextField!
    @IBOutlet weak var uddateFileBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!

    
    @IBOutlet var inputDateView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var datePicker: UIDatePicker!
    
     var updateAction :blockAction?
     var noAction :blockAction?
     var obj = KeyHolderObject()
     var delegate: RefreshFilestDelegate?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        editNameTextFiled.delegate = self
        editDateTextFiled.delegate = self
        editNameTextFiled.setBorder(width: 1, color: #colorLiteral(red: 0.9554988742, green: 0.9562225938, blue: 0.9556109309, alpha: 1), cornerRaidus: 2)
        editDateTextFiled.setBorder(width: 1, color: #colorLiteral(red: 0.9554988742, green: 0.9562225938, blue: 0.9556109309, alpha: 1), cornerRaidus: 2)
        uddateFileBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: self.uddateFileBtn.frame.size.height/2)
        editNameTextFiled.textFieldWithLeftView(width:35, icon:#imageLiteral(resourceName: "edit-2"))
        editDateTextFiled.textFieldWithLeftView(width:35, icon:#imageLiteral(resourceName: "clndr"))
        editNameTextFiled.text = obj.file_name
        editDateTextFiled.text = obj.file_date
        
        showDatePicker()

        // Do any additional setup after loading the view.
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK:-
    //MARK:- IB Actions
  
    
    @IBAction func closeBtnAction(_ sender: Any) {
        
        self.noAction!()
    }
    
    @IBAction func updateFileBtnAction(_ sender: Any) {
        
         self.updateAction!()
         editFileApi()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
          self.view.endEditing(true)
       // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        editDateTextFiled.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    //MARK:-
    //MARK:- Custom Methods
    
    @objc func showDatePicker()
    {
        //Formate Date
        datePicker.datePickerMode = .date
        editDateTextFiled.inputView = inputDateView
        editDateTextFiled.inputAccessoryView = nil
        datePicker.minimumDate = Date()
        
        
    }
    

    //MARK:-
    //MARK:- API Methods
    
    func editFileApi() {
        
        let fileName:String = (editNameTextFiled.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let fileDate:String = (editDateTextFiled.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
       
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            var parameters = [String: Any]()
            parameters = ["file_id":obj.file_id, "file_name":fileName, "file_date":fileDate]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.updateFile, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            
                            if self.delegate != nil {
                                
                                self.delegate?.refreshFileList()
                            }
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        else {
                            self.navigationController?.popViewController(animated: true)
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "File is not Deleted", vc: UIApplication.topViewController()!)
                            
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
