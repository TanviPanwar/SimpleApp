//
//  SearchByProfileNameViewController.swift
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

class SearchByProfileNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RefreshFilestDelegate, RefreshFileDelegate , progressDismissDelegate
{
    func progressDismiss() {
        
        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"File successfully downloaded", vc: UIApplication.topViewController()!)
        
        
    }
    
    func refreshDirFileList() {
        self.finalFilesArray.removeAll()
        self.searchTableView.reloadData()
        self.page_number = 0
        self.viewDirectoriesFiles()
        
    }
    
    
    
    func refreshFileList() {
        self.finalFilesArray.removeAll()
        self.searchTableView.reloadData()
        self.page_number = 0
        self.viewDirectoriesFiles()
    }
    
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var directoryNameLabel: UILabel!
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var messageImgView: UIImageView!
    
    
    var obj = GetDirectoryListObject()
    var page_number : Int = 0
    var searchPageNumber : Int = 0
    var btnTagValue = Int()

    var filesArray = [KeyHolderObject]()
    var finalFilesArray = [KeyHolderObject]()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchView.setBorder(width: 1, color: #colorLiteral(red: 0.8022919297, green: 0.8022919297, blue: 0.8022919297, alpha: 1), cornerRaidus: 17.5)
        searchBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 17.5)
        
        ProjectManager.sharedInstance.progressDelegate = self
        
        directoryNameLabel.text = obj.dir_name

        
        viewDirectoriesFiles()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
        
        searchPageNumber = 0
        self.filesArray.removeAll()
        self.finalFilesArray.removeAll()
        self.searchTableView.reloadData()
        searchBtn.tag = 1
        btnTagValue = searchBtn.tag
        
        searchApi()
        
        
    }
    
    //MARK:-
    //MARK:- TableView DataSources
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return finalFilesArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"SearchByProfileNameTableViewCell", for: indexPath) as! SearchByProfileNameTableViewCell
        
        cell.thumbnailImgView.setBorder(width: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRaidus: 2)

        
        let delimiter = "."
        var newstr = finalFilesArray[indexPath.row].file_original_name
        var token = newstr.components(separatedBy: delimiter)
        print (token[0])
        
        cell.nameLabel.text = token[0]
        
        let string =  finalFilesArray[indexPath.row].created_at
        let uploadDateStr = string.components(separatedBy: " ").first
        
        cell.uploadDateLabel .text =  uploadDateStr
        cell.eventDateLabel .text =  finalFilesArray[indexPath.row].file_date
        
        
        

        if let ext = MimeType(path:finalFilesArray[indexPath.row].file_url).ext {

            if let mimeType = mimeTypes[ext]
            {

                if mimeType.hasPrefix("audio")
                {

                    cell.thumbnailImgView?.image = #imageLiteral(resourceName: "audioPlaceholder")
                }
                else  if mimeType.hasPrefix("video")
                {


                    cell.thumbnailImgView?.image = #imageLiteral(resourceName: "video-Icon")

                }

                else  if mimeType.hasPrefix("image")
                {
                    cell.thumbnailImgView.sd_setImage(with: URL(string:  finalFilesArray[indexPath.row].file_url) , placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in

                    }
                    //cell.photo?.image.sd_setImageWithURL(self.imageURL)
                    
            


                }

                else
                {


                    cell.thumbnailImgView?.image = #imageLiteral(resourceName: "attachment")
                    cell.thumbnailImgView?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }


            }

            else
            {

                cell.thumbnailImgView?.image = #imageLiteral(resourceName: "attachment")
                cell.thumbnailImgView?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }

        }
        
        
        
        
        
        
        
        
        cell.onDownloadButtonTapped = {
            
            
            
            self.downloadFileFromURL(index: indexPath.row)
            
        }
        
        cell.onMoveButtonTapped = {
            
            
            let alertVC :MoveFilePopup = (self.storyboard?.instantiateViewController(withIdentifier: "MoveFilePopup") as? MoveFilePopup)!
            
            alertVC.obj = self.finalFilesArray[indexPath.row]
            alertVC.delegate = self
            alertVC.dirName = self.obj.dir_name
            alertVC.dirId = self.obj.id
            
            let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
            , tapGestureDismissal: false, panGestureDismissal: false) {
                let overlayAppearance = PopupDialogOverlayView.appearance()
                overlayAppearance.blurRadius  = 30
                overlayAppearance.blurEnabled = true
                overlayAppearance.liveBlur    = false
                overlayAppearance.opacity     = 0.4
            }
            
            alertVC.updateAction = {
                
//                popup.dismiss({
//                    
//                    
//                    
//                })
            }
            
            alertVC.noAction = {
                
                popup.dismiss({
                    
                    
                    
                })
            }
            
            UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
            
            
            
            
        }
        
        cell.onEditButtonTapped = {
            
            let alertVC :EditFilePopup = (self.storyboard?.instantiateViewController(withIdentifier: "EditFilePopup") as? EditFilePopup)!
            
            alertVC.obj = self.finalFilesArray[indexPath.row]
            alertVC.delegate = self
            
            let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
            , tapGestureDismissal: false, panGestureDismissal: false) {
                let overlayAppearance = PopupDialogOverlayView.appearance()
                overlayAppearance.blurRadius  = 30
                overlayAppearance.blurEnabled = true
                overlayAppearance.liveBlur    = false
                overlayAppearance.opacity     = 0.4
            }
            
            alertVC.updateAction = {
                
                popup.dismiss({
                    
                    
                    
                })
            }
            
            alertVC.noAction = {
                
                popup.dismiss({
                    
                    
                    
                })
                
            }
            
            
            UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
            
            
        }
        
        cell.onCloseButtonTapped = {
            
            let alertController = UIAlertController(title: "Are You sure?", message: "Once deleted, you will not able to recover this file!", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                self.deleteFiles(index: indexPath.row)
                
            }
            alertController.addAction(OKAction)
            
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if page_number != -1 && searchPageNumber != -1 {
        if indexPath.row == finalFilesArray.count - 1 && finalFilesArray.count  > 9 {
            
            if btnTagValue == 1 {
                
                searchPageNumber += 1
                self.searchApi()
            }
            
            else {
               page_number += 1
               self.viewDirectoriesFiles()
            }
        }
        }
    }
    
    
    
    //MARK:-
    //MARK:- API Methods
    
    func viewDirectoriesFiles() {
        
        
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
            
            parameters = ["directory_id":obj.id, "page_number":"\(page_number)", "per_page_files":"10"]
            
            
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                if self.page_number == 0 {
                    ProjectManager.sharedInstance.showLoader()
                }
                
                Alamofire.request(baseURL + ApiMethods.getDirectoryFiles, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                
                                if (user_files != nil && user_files!.count > 0)
                                {
                                    
                                    
                                    self.filesArray = ProjectManager.sharedInstance.GetDirectoriesFilesList(array: user_files!)
                                    
                                    self.finalFilesArray.append(contentsOf:self.filesArray)
                                    
                                    self.messageImgView.isHidden = true
                                    self.searchTableView .isHidden = false
                                    self.searchTableView.reloadData()
                                    
                                }
                                    
                                else {
                                    
                                    if self.page_number == 0 {
                                        
                                        self.messageImgView.isHidden = false
                                        self.searchTableView .isHidden = true
                                        
                                    }
                                    
                                    self.page_number = -1

                                    
                                    
                                }
                                
                            }
                            else{
                                
                                if self.page_number == 0 {
                                    
                                    self.messageImgView.isHidden = false
                                    self.searchTableView .isHidden = true
                                }
                                
                                self.page_number = -1

                                
                            }
                            
                        }
                        else {
                            
                            if self.page_number == 0 {
                                
                                self.messageImgView.isHidden = false
                                self.searchTableView .isHidden = true
                                self.searchTableView.reloadData()
                            }
                                
                            else {
                                
                                self.messageImgView.isHidden = true
                                self.searchTableView .isHidden = false
                                self.searchTableView.reloadData()
                            }
                            self.page_number = -1
//                            let msg = json["message"] as? String
//                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            
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
            
            parameters = ["directory_id":obj.id, "page_number":"\(searchPageNumber)", "per_page_files":"10", "search": searchStr]
            
            
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                if self.page_number == 0 {
                    ProjectManager.sharedInstance.showLoader()
                }
                
                Alamofire.request(baseURL + ApiMethods.searchDirectoryFiles, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                
                                if (user_files != nil && user_files!.count > 0)
                                {
                                    
                                    
                                    self.filesArray = ProjectManager.sharedInstance.GetDirectoriesFilesList(array: user_files!)
                                    
                                    self.finalFilesArray.append(contentsOf:self.filesArray)
                                    
                                    self.messageImgView.isHidden = true
                                    self.searchTableView .isHidden = false
                                    self.searchTableView.reloadData()
                                    
                                }
                                    
                                else {
                                    
                                    if self.searchPageNumber == 0 {
                                        
                                        self.messageImgView.isHidden = false
                                        self.searchTableView .isHidden = true
                                        
                                    }
                                    
                                    self.searchPageNumber = -1
                                }
                                
                            }
                            else{
                                
                                if self.searchPageNumber == 0 {
                                    
                                    self.messageImgView.isHidden = false
                                    self.searchTableView .isHidden = true
                                }
                                
                                self.searchPageNumber = -1
                                
                            }
                            
                        }
                        else {
                            
                            if self.searchPageNumber == 0 {
                                
                                self.messageImgView.isHidden = false
                                self.searchTableView .isHidden = true
                                self.searchTableView.reloadData()
                            }
                                
                            else {
                                
                                self.messageImgView.isHidden = true
                                self.searchTableView .isHidden = false
                                self.searchTableView.reloadData()
                            }
                            
                             self.searchPageNumber = -1
                            
//                             let msg = json["message"] as? String
//
//                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            
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
    
    
    func deleteFiles(index: Int) {
        
        
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            var parameters = [String: Any]()
            parameters = ["file_id": finalFilesArray[index].file_id, "file_name":finalFilesArray[index].file_name]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.deleteFile, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            // self.viewDirectoriesFiles()
                            self.finalFilesArray.remove(at: index)
                            if self.finalFilesArray.count > 0
                            {
                                self.searchTableView.isHidden = false
                                self.messageImgView.isHidden = true
                                self.searchTableView.reloadData()
                                
                            }
                                
                            else {
                                
                                self.searchTableView.reloadData()
                                self.searchTableView.isHidden = true
                                self.messageImgView.isHidden = false
                            }
                            
                
                            let msg = json["message"] as? String
                             ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)

                            
                            
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
                
                
                print(finalFilesArray[index].file_id)
                let fileUrl = finalFilesArray[index].file_url // /\(obj.UserID) fileDownloadBaseURL + "/\
                Alamofire.request(fileUrl, headers:headers).downloadProgress { (progress) in
                    NotificationCenter.default.post(name:.downloadProgress, object:progress )
                    print(progress.fractionCompleted , progress.fileTotalCount , progress.fileCompletedCount , progress.totalUnitCount )
                    
                    
//                    guard progress.fractionCompleted != 0.0 else {
//
//                        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
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
//
                    
                    }.responseData { (data) in
                        if let contentType = data.response?.allHeaderFields["Content-Type"] as? String {
                            print("contentType ***** \(contentType)")
                            if contentType.hasPrefix("image") {
                                if UIImage(data:data.data ?? Data() ) != nil {
                                    UIImageWriteToSavedPhotosAlbum(UIImage(data:data.data!)!, nil, nil, nil)
                                    
                                    
                                    
//                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 2000000000), execute: {
//                                    
//                                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"File successfully downloaded", vc: self)
//                                        
//                                    }
//                                    
//                                    )
                                    //ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"File successfully downloaded", vc: UIApplication.topViewController()!)
                                   
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
                                    
                                   //  UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                                    
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
                            else if contentType.hasPrefix("audio") {
                                let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + "\(self.finalFilesArray[index].file_name)")
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
                                let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + "\(self.finalFilesArray[index].file_name)")
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


//MARK:-
//MARK:- Extensions

//extension UIAlertAction {
//
//    func alert(title: String, message: String) {
//        var refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//
//        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//            print("Handle Ok logic here")
//        }))
//
//        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//            print("Handle Cancel Logic here")
//        }))
//
//        presen(refreshAlert, animated: true, completion: nil)
//    }
//}
