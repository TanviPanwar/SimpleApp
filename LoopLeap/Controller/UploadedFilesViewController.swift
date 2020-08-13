//
//  UploadedFilesViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 13/09/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog
import Photos

class UploadedFilesViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var tableViw: UITableView!
    let refreshControl = UIRefreshControl()
    var filesArray = [FilesObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViw.tableFooterView = UIView()
        if #available(iOS 10.0, *) {
            tableViw.refreshControl = refreshControl
        } else {
            tableViw.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        getFilesFromServer(showLoader: true, refreshControl: false)
        
        // Do any additional setup after loading the view.
    }
    //MARK:-
    //MARK:- UIRefreshControl
    
    @objc private func refreshData(_ sender: Any) {
      
        getFilesFromServer(showLoader: false, refreshControl: true)
    }
    
    //MARK:-
    //MARK:- Download Method

    @IBAction func moreAction(_ sender: Any) {

        let actionSheet = UIAlertController(title:"", message: "", preferredStyle: .actionSheet)
        let action = UIAlertAction(title:"My Questions", style: .default) { (action) in


            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnsweredQuestionsListViewController")as? AnsweredQuestionsListViewController

            self.navigationController?.pushViewController(vc!, animated: true)

        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }


    func downloadFileFromURL(obj:FilesObject)  {


        
        
        if ProjectManager.sharedInstance.isInternetAvailable() {
        
        self.downloadPopup()
            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]

        let fileUrl = fileDownloadBaseURL + "/\(obj.FileID)" // /\(obj.UserID)
                Alamofire.request(fileUrl, headers:headers).downloadProgress { (progress) in
            NotificationCenter.default.post(name:.downloadProgress, object:progress )
            print(progress.fractionCompleted , progress.fileTotalCount , progress.fileCompletedCount , progress.totalUnitCount )
            }.responseData { (data) in
                if let contentType = data.response?.allHeaderFields["Content-Type"] as? String {
                    print("contentType ***** \(contentType)")
                    if contentType.hasPrefix("image") {
                        if UIImage(data:data.data ?? Data() ) != nil {
                            UIImageWriteToSavedPhotosAlbum(UIImage(data:data.data!)!, nil, nil, nil)
                        }
                    }
                   else if contentType.hasPrefix("video") {
                        let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + ".mp4")
                        do {

                            try data.data?.write(to:filePath!)
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
                        let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + "\(obj.FileName)")
                        do {
                            
                            try data.data?.write(to:filePath!)
                           
                        }
                        catch {
                            
                            
                        }
                        
                    }
                    else {
                        let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + "\(obj.FileName)")
                        do {
                            
                            try data.data?.write(to:filePath!)
                            
                        }
                        catch {
                            
                            
                        }
                        
                        
                        
                    }
                
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
    
    
    //MARK:-
    //MARK:- Tableview  Datasources
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesArray.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viw = UIView(frame: CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        viw.backgroundColor = .white
        let lbl = UILabel(frame:CGRect(x:24, y: 0, width: UIScreen.main.bounds.size.width - 24, height: 40) )
        lbl.textColor  = .darkGray
        lbl.font = UIFont(name:"Raleway-Light", size: 13)
        lbl.text = "Uploaded Files (\(filesArray.count))"
        viw.addSubview(lbl)
        return viw
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"ListViewCell", for: indexPath) as? ListViewCell else {return UITableViewCell() }
        let obj = filesArray[indexPath.row]
        cell.fileNameLbl.text = obj.FileName
        cell.selectionStyle = .none
        if !obj.FileSize.isEmpty {
        let sizeMB = Float(obj.FileSize)! / 1024
        if sizeMB > 1.0 {
            let size = String(format: "%.1f", sizeMB)
            cell.fileSizeLbl.text = "\(size) MB"
        }
        else {
             cell.fileSizeLbl.text = "\(obj.FileSize) KB"
        }
        } else {
            cell.fileSizeLbl.text = "0 KB"
        }
        if !obj.FileDate.isEmpty {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: obj.FileDate)
        dateFormatter.dateFormat = "dd MMM yyyy"
        cell.dateLbl.text = dateFormatter.string(from:date!)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action =  UIContextualAction(style: .normal, title: "Files", handler: { (action,view,completionHandler ) in
            //do stuff
            self.downloadFileFromURL(obj: self.filesArray[indexPath.row])
            
            completionHandler(true)
        })
        action.image = UIImage(named: "download")
        action.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        
        
        let deleteaction =  UIContextualAction(style: .normal, title: "Files", handler: { (action,view,completionHandler ) in
            //do stuff
            DispatchQueue.main.async {
                let alert = UIAlertController(title:"Are you sure ?", message: "Once delete , You will not be able to recover this file", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
                let delete = UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                    self.deleteFilesFromServer(obj: self.filesArray[indexPath.row])
                })
                alert.addAction(cancelAction)
                alert.addAction(delete)
                self.present(alert, animated: true, completion: nil)
            }
         
            completionHandler(true)
        })
        deleteaction.image = UIImage(named: "delete")
        deleteaction.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        let confrigation = UISwipeActionsConfiguration(actions: [action, deleteaction])
        
        return confrigation
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK:-
    //MARK:- Get Files Webservice
  
    
    
    func getFilesFromServer(showLoader:Bool , refreshControl:Bool) {
        
        //if let userID = UserDefaults.standard.value(forKey:DefaultsIdentifier.userID) {
            if showLoader {
                ProjectManager.sharedInstance.showLoader()
            }
            ProjectManager.sharedInstance.callApiWithParameters(params:[:], url:baseURL + ApiMethods.getFilesAPI, image:nil, imageParam:"") { (response, error) in
                ProjectManager.sharedInstance.stopLoader()
                if refreshControl {
                    self.refreshControl.endRefreshing()
                }
                
                if response != nil {
                    if let status = response?["status"] as? NSNumber {
                        if status == 1 {
                            if let data = response?["data"] as? [String:Any] {
                                if let arr = data["user_files"] as? NSArray {
                                self.filesArray = ProjectManager.sharedInstance.getFileObjects(array:arr)
                                    
                                self.tableViw.reloadData()
                                }
                            }
                            
                        }
                        else {
                        }
                    }
                }
            }
        //}
    }
    
    func deleteFilesFromServer(obj:FilesObject) {
        
        //if let userID = UserDefaults.standard.value(forKey:DefaultsIdentifier.userID) {
            ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWithParameters(params:["file_name":obj.FileName, "file_id":obj.FileID], url:baseURL + ApiMethods.deleteFileAPI, image:nil, imageParam:"") { (response, error) in
               
                if response != nil {
                    if let status = response?["success"] as? NSNumber {
                        if status == 1 {
                           
                            self.getFilesFromServer(showLoader: false, refreshControl: false)
                        }
                        else {
                            
                             ProjectManager.sharedInstance.stopLoader()
                        }
                    }
                    else {
                         ProjectManager.sharedInstance.stopLoader()
                    }
                }
            }
        //}
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
