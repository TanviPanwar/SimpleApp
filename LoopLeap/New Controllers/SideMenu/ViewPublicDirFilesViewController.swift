//
//  ViewPublicDirFilesViewC00ontroller.swift
//  LoopLeap
//
//  Created by iOS6 on 02/04/019.
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

class ViewPublicDirFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var filesTableView: UITableView!
    @IBOutlet weak var messageImgView: UIImageView!
    
    
    var page_number : Int = 0
    var searchPageNumber : Int = 0
    var filesArray = KeyHolderObject()
    var finalFilesArray = KeyHolderObject()
    var obj = KeyHolderObject()
    var btnTagValue = Int()
    var acceptedInvBool = Bool()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchView.setBorder(width: 1, color: #colorLiteral(red: 0.8022919297, green: 0.8022919297, blue: 0.8022919297, alpha: 1), cornerRaidus: searchView.frame.height/2)
        searchBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus:searchBtn.frame.height/2)
        
        viewFiles()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        page_number = 0
        searchPageNumber = 0
        filesArray.user_files.removeAll()
        
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
        
        searchPageNumber = 0
        self.filesArray.user_files.removeAll()
        self.filesTableView.reloadData()
        searchBtn.tag = 1
        btnTagValue = searchBtn.tag
        
//        let search = (searchTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
//
//        if search == "" {
//
//            page_number = 0
//            self.filesArray.user_files.removeAll()
//            self.filesTableView.reloadData()
//            viewFiles()
//
//        }
//
//        else {
        
           searchApi()
            
        //}
    }
    
    
    //MARK:-
    //MARK:- TableView DataSources
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filesArray.user_files.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"SearchByProfileNameTableViewCell", for: indexPath) as! SearchByProfileNameTableViewCell
        if filesArray.user_files.count > 0 {
            
            print(filesArray.main_dir_id)
            
            let str =  filesArray.user_files[indexPath.row].file_original_name
            let nameStr = str.components(separatedBy: ".").first
            cell.nameLabel.text = nameStr!
            
            let string =  filesArray.user_files[indexPath.row].created_at
            let uploadDateStr = string.components(separatedBy: " ").first
            cell.uploadDateLabel.text = uploadDateStr
            cell.eventDateLabel.text =  filesArray.user_files[indexPath.row].file_date
            
            cell.onDownloadButtonTapped = {
                
                self.downloadFileFromURL(index: indexPath.row)
            }
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == filesArray.user_files.count - 1 && filesArray.user_files.count  > 9 {
            
            if btnTagValue == 1{
                
//                 let search = (searchTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
//
//                if search == "" {
//
//                    page_number += 1
//                    self.viewFiles()
//
//                }
//
//                else {
                
                searchPageNumber += 1
                self.searchApi()
                    
               // }
            }
            else {
                page_number += 1
                self.viewFiles()
            }
        }
        
    }
    
    
    //MARK:-
    //MARK:- API Methods
    
    func viewFiles() {
        
        
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
            
            var parameters = [String: Any]()
            
            parameters = ["directory_id":obj.dir_id, "page_number":"\(page_number)", "per_page_files":"10"]
            var apiName = String()
            if acceptedInvBool == true {
                
                apiName = ApiMethods.viewSharedDirectoriesFiles
                
            }
            
            else {
                
                apiName = ApiMethods.getPublicDirectoriesFiles
                
            }
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                if self.page_number == 0 {
                    DispatchQueue.main.async {
                        
                        ProjectManager.sharedInstance.showLoader()
                        
                    }
                }
                
                Alamofire.request(baseURL + apiName, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? [String : Any ] {
                                print(data)
                                self.messageImgView.isHidden = true
                                
                                let user_files = data["user_files"] as? NSArray
                                
                                if (user_files != nil && user_files!.count > 0) {
                                    
                                    let obj  = ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)
                                    
                                    self.filesArray.user_files.append(contentsOf: obj.user_files)
                                    
                                    self.filesTableView.isHidden = false
                                    self.filesTableView.reloadData()
                                    
                                }
                                    
                                    // let user_files = data["user_files"] as? NSArray
                                    
                                    //  if (user_files != nil && user_files!.count > 0)
                                    //  {
                                    
                                    
                                    //                                    self.filesArray = ProjectManager.sharedInstance.GetDirectoriesFilesList(array: user_files!)
                                    //
                                    //                                    self.finalFilesArray.append(contentsOf:self.filesArray)
                                    //
                                    //                                    self.messageImgView.isHidden = true
                                    //                                    self.searchTableView .isHidden = false
                                    //                                    self.searchTableView.reloadData()
                                    //
                                    // }
                                    
                                else {
                                    //
                                    if self.page_number == 0 {
                                        
                                        self.messageImgView.isHidden = false
                                        self.filesTableView .isHidden = true
                                        
                                    }
                                }
                                
                            }
                            else{
                                
                                if self.page_number == 0 {
                                    
                                    self.messageImgView.isHidden = false
                                    self.filesTableView .isHidden = true
                                }
                                
                            }
                            
                        }
                        else {
                            
                            if self.page_number == 0 {
                                
                                self.messageImgView.isHidden = false
                                self.filesTableView .isHidden = true
                                self.filesTableView.reloadData()
                                
                            }
                                
                            else {
                                
                                self.messageImgView.isHidden = true
                                self.filesTableView .isHidden = false
                                self.filesTableView.reloadData()
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
    
    func searchApi() {
        
        
        let searchStr:String = (searchTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        self.view.endEditing(true)
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            var parameters = [String: Any]()
            
            parameters = ["directory_id":obj.dir_id, "page_number":"\(searchPageNumber)", "per_page_files":"10", "search":searchStr]
            
            var apiName = String()
            if acceptedInvBool == true {
                
                apiName = ApiMethods.viewSharedDirectoriesFiles
                
            }
                
            else {
                
                apiName = ApiMethods.getPublicDirectoriesFiles
                
            }
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                if self.page_number == 0 {
                    DispatchQueue.main.async {
                        
                        ProjectManager.sharedInstance.showLoader()
                        
                    }
                }
                
                Alamofire.request(baseURL + apiName, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? [String : Any ] {
                                print(data)
                                self.messageImgView.isHidden = true
                                
                                let user_files = data["user_files"] as? NSArray
                                
                                if (user_files != nil && user_files!.count > 0) {
                                  
                                    let obj  = ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)
                                    
                                    self.filesArray.user_files.append(contentsOf: obj.user_files)
                                    
                                    self.filesTableView.isHidden = false
                                    self.filesTableView.reloadData()
                                    
                                }
                                    
                                    // let user_files = data["user_files"] as? NSArray
                                    
                                    //  if (user_files != nil && user_files!.count > 0)
                                    //  {
                                    
                                    
                                    //                                    self.filesArray = ProjectManager.sharedInstance.GetDirectoriesFilesList(array: user_files!)
                                    //
                                    //                                    self.finalFilesArray.append(contentsOf:self.filesArray)
                                    //
                                    //                                    self.messageImgView.isHidden = true
                                    //                                    self.searchTableView .isHidden = false
                                    //                                    self.searchTableView.reloadData()
                                    //
                                    // }
                                    
                                else {
                                    //
                                    if self.searchPageNumber == 0 {
                                       
                                        self.messageImgView.isHidden = false
                                        self.filesTableView .isHidden = true
                                        
                                    }
                                }
                                
                            }
                            else{
                                
                                if self.searchPageNumber == 0 {
                                   
                                    self.messageImgView.isHidden = false
                                    self.filesTableView .isHidden = true
                                }
                                
                            }
                            
                        }
                        else {
                            
                            if self.searchPageNumber == 0 {
                                
                                self.messageImgView.isHidden = false
                                self.filesTableView .isHidden = true
                                self.filesTableView.reloadData()
                                
                            }
                                
                            else {
                                
                                self.messageImgView.isHidden = true
                                self.filesTableView .isHidden = false
                                self.filesTableView.reloadData()
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
    
    
    func downloadFileFromURL(index: Int)  {
        
        
        if ProjectManager.sharedInstance.isInternetAvailable() {
            
            self.downloadPopup()
            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]
                
                print(filesArray.main_dir_id)

                print(filesArray.user_files[index].file_id)
                let fileUrl = filesArray.user_files[index].file_url
                    //fileDownloadBaseURL + "/52" + "/\(filesArray.user_files[index].file_id)" // /\(obj.UserID)
                Alamofire.request(fileUrl, headers:headers).downloadProgress { (progress) in
                    NotificationCenter.default.post(name:.downloadProgress, object:progress )
                    print(progress.fractionCompleted , progress.fileTotalCount , progress.fileCompletedCount , progress.totalUnitCount )
//                    guard progress.fileCompletedCount != nil else {
//
//                          UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
//
//                        let alertController = UIAlertController(title: "", message: "File not Downloaded", preferredStyle: .alert)
//
//                        // Create OK button
//                        let OKAction = UIAlertAction(title: "OK", style: .cancel)
//
//                        alertController.addAction(OKAction)
//
//
//
//                        // Present Dialog message
//                        self.present(alertController, animated: true, completion:nil)
//
//                        return
//                    }
                    
                    }.responseData { (data) in
                        if let contentType = data.response?.allHeaderFields["Content-Type"] as? String  {
                            print("contentType ***** \(contentType)")
                            
                            
                            
                            if contentType.hasPrefix("image") {
                                if UIImage(data:data.data ?? Data() ) != nil {
                                    UIImageWriteToSavedPhotosAlbum(UIImage(data:data.data!)!, nil, nil, nil)
                                    
                                      UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                                    
                                    
                                    let alertController = UIAlertController(title: "", message: "File successfully downloaded", preferredStyle: .alert)
                                    
                                    // Create OK button
                                    let OKAction = UIAlertAction(title: "OK", style: .cancel)
                                    
                                    alertController.addAction(OKAction)
                                    
                                    
                                    
                                    // Present Dialog message
                                    self.present(alertController, animated: true, completion:nil)
                                    
                                }
                            }
                            else if contentType.hasPrefix("video") {
                                let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + ".mp4")
                                do {
                                    
                                    try data.data?.write(to:filePath!)
                                    
                                      UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                                    
                                    let alertController = UIAlertController(title: "", message: "File successfully downloaded", preferredStyle: .alert)
                                    
                                    // Create OK button
                                    let OKAction = UIAlertAction(title: "OK", style: .cancel)
                                    
                                    alertController.addAction(OKAction)
                                    
                                    
                                    
                                    // Present Dialog message
                                    self.present(alertController, animated: true, completion:nil)
                                    
                                    
                                    //                            PHPhotoLibrary.shared().performChanges({
                                    //                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: filePath!)
                                    //                            }) { saved, error in
                                    //                                print(error)
                                    //                                if saved {
                                    //
                                    //
                                    //                                }
                                    //                            }
                                }
                                catch {
                                    
                                    
                                }
                                
                            }
                            else if contentType.hasPrefix("audio") {
                                let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + "\(self.filesArray.user_files[index].file_name)")
                                do {
                                    
                                    try data.data?.write(to:filePath!)
                                    
                                      UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                                    
                                    let alertController = UIAlertController(title: "", message: "File successfully downloaded", preferredStyle: .alert)
                                    
                                    // Create OK button
                                    let OKAction = UIAlertAction(title: "OK", style: .cancel)
                                    
                                    alertController.addAction(OKAction)
                                    
                                    
                                    
                                    // Present Dialog message
                                    self.present(alertController, animated: true, completion:nil)
                                    
                                }
                                catch {
                                    
                                    
                                }
                                
                            }
                            else {
                                let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + "\(self.filesArray.user_files[index].file_name)")
                                do {
                                    
                                    try data.data?.write(to:filePath!)
                                    
                                    UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                                    
                                    let alertController = UIAlertController(title: "", message: "File successfully downloaded", preferredStyle: .alert)
                                    
                                    // Create OK button
                                    let OKAction = UIAlertAction(title: "OK", style: .cancel)
                                    
                                    alertController.addAction(OKAction)
                                    
                                    
                                    
                                    // Present Dialog message
                                    self.present(alertController, animated: true, completion:nil)
                                    
                                }
                                catch {
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                        else {
                            
                            
                            print(data.result)
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Unable To Download", vc: UIApplication.topViewController()!)
                            
                            
                        }
                        
                }
            }
        }
        else {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
            
        }
        
    }
    
    
    func documentsPathForFileName(name: String) -> URL? {
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        let fileURL = dirPaths[0].appendingPathComponent(name)
        return fileURL
    }
    func downloadPopup() {
        
        let alertVC :DownloadingPopup = (self.storyboard?.instantiateViewController(withIdentifier: "DownloadingPopup") as? DownloadingPopup)!
        let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
        ,tapGestureDismissal: false, panGestureDismissal: false) {
            let overlayAppearance = PopupDialogOverlayView.appearance()
            overlayAppearance.blurRadius  = 30
            overlayAppearance.blurEnabled = true
            overlayAppearance.liveBlur    = false
            overlayAppearance.opacity     = 0.4
        }
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
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
