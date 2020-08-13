//
//  MoveFilePopup.swift
//  LoopLeap
//
//  Created by iOS6 on 15/03/19.
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

protocol RefreshFileDelegate {
    func refreshDirFileList()
}

class MoveFilePopup: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var chooseDirectoryView: UIView!
    @IBOutlet weak var chooseDirectoryTextField: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var selectDirBtn: UIButton!
    
    var updateAction :blockAction?
    var noAction :blockAction?
    var obj = KeyHolderObject()
    var dirName = String()
    var dirId = String()
    var delegate: RefreshFileDelegate?
    var dirArray = [GetDirectoryListObject]()
    var textFieldPressedValue = Int()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        chooseDirectoryTextField.delegate = self
       // chooseDirectoryTextField.text = dirName
        showPicker()
        getDirectoriesList()
        
        updateBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: updateBtn.frame.size.height/2)
        
        chooseDirectoryView.setBorder(width: 1, color: #colorLiteral(red: 0.9554988742, green: 0.9562225938, blue: 0.9556109309, alpha: 1), cornerRaidus: 2)
        
//        let dirData = UserDefaults.standard.object(forKey: DefaultsIdentifier.dir_data) as? NSData
//        dirArray = NSKeyedUnarchiver.unarchiveObject(with: dirData! as Data) as! [GetDirectoryListObject]


        // Do any additional setup after loading the view.
    }
    
    
    //MARK:-
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == chooseDirectoryTextField {
            textField.tag = 1
            textFieldPressedValue = textField.tag
            showPicker()
            print("You edit myTextField")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:-
    //MARK:- Custom Method
    
    
    @objc func showPicker()
    {
        chooseDirectoryTextField.inputView = pickerInputView
        chooseDirectoryTextField.inputAccessoryView = nil

    }
    
    

    
    //MARK:-
    //MARK:- IB Actions
    
    
    
    @IBAction func closeBtnAction(_ sender: Any) {
        
        
        self.noAction!()
    }
    
    @IBAction func updateBtnAction(_ sender: Any) {
        
        self.updateAction!()
        moveFileApi()
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.view.endEditing(true)
       // self.dismiss(animated: true, completion: nil)

        
    }
    
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
         let row = pickerView.selectedRow(inComponent: 0)
        chooseDirectoryTextField.text = dirArray[row].dir_name
        //dismiss date picker dialog
        self.view.endEditing(true)
        
    }
    
    @IBAction func selectDirBtnAction(_ sender: Any) {
        
        
        chooseDirectoryTextField.becomeFirstResponder()
        
    }
    
    //MARK:-
    //MARK:- PickerView DataSources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dirArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dirArray[row].dir_name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //selectPickerIndex = row
        //        chooseDirTextField.text = pickerArray[row]
        //        dircollectionArray.append(pickerArray[row])
        //        directoryCollectionView.reloadData()
        
        
    }
    
    
    
   
    //MARK:-
    //MARK:- API Methods
    
    func moveFileApi() {
        
        
         let dirStr:String = (chooseDirectoryTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        
        if dirStr.isEmpty {
            
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"please select directory", vc:self)
            
        }
      
        else {
            
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
                
                if textFieldPressedValue == 1 {
                    
                    parameters = ["file_id":obj.file_id, "directory_id":dirArray[row].id]
                    
                    
                }
                    
                else {
                    parameters = ["file_id":obj.file_id, "directory_id":dirId]
                    
                }
                
                if ProjectManager.sharedInstance.isInternetAvailable()
                {
                    ProjectManager.sharedInstance.showLoader()
                    
                    
                    Alamofire.request(baseURL + ApiMethods.moveFile, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                    
                                    self.delegate?.refreshDirFileList()
                                }
                                
                                UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                    
                                    let msg = json["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                })
                                
                                // self.dismiss(animated: true, completion: nil)
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
    }
    
    func getDirectoriesList() {
        
        
        // let todoEndpoint: String = "http://dev.loopleap.com/api/timelineyears?user_id=\(userId)"
        // let parameters = ["user_id": userId]
        
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
                //ProjectManager.sharedInstance.showLoader()
                
                
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
                                self.dirArray = ProjectManager.sharedInstance.GetDirectoryListObjects(array: data)
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

public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}
