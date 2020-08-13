//
//  DashBoardViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 06/03/19.
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


class DashBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RefreshDirListDelegate , childDashboardDelegate
    //refreshDirectoriesFromUploadDelegate
{
//    func refreshDir() {
//        directoriesArray.removeAll()
//        dashBoardCollectionView.reloadData()
//        pageNumber = 0
//        self.getDirectoriesList()
//    }
    
    func refreshChildDashboard() {
        directoriesArray.removeAll()
        dashBoardCollectionView.reloadData()
        pageNumber = 0
        self.getDirectoriesList()

    }
    
    func refreshDirList() {
        directoriesArray.removeAll()
        dashBoardCollectionView.reloadData()
        pageNumber = 0
        self.getDirectoriesList()
    }
    
    
    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var dashBoardCollectionView: UICollectionView!
    @IBOutlet weak var backtoportalBtn: UIButton!
    @IBOutlet weak var addDirectoryBtn: UIButton!
    
    
    
    
    
    var directoriesArray = [GetDirectoryListObject]()
    var role = Int()
    var pageNumber = 0
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        ProjectManager.sharedInstance.backtoprtalDelegate = self
        //ProjectManager.sharedInstance.uploadsFileAudioVideoDelegate = self

       // setUI()
        getDirectoriesList()
//        if !UserDefaults.standard.bool(forKey: "isShowPopup") {
//            showPopups()
//        }

        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
//        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
//        {
//
//            if let  userRole = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
//
//                role = userRole
//
//            if role == 6 {
//
//                self.backtoportalBtn.isHidden = false
//                //self.addDirectoryBtn.isHidden = true
//            }
//
//            else  {
//
//                self.backtoportalBtn.isHidden = true
//               // self.addDirectoryBtn.isHidden = false
//
//            }
//
//            }
//
//        }
        
    }
    
    //MARK:-
    //MARK:- Custom Methods
    
    func setUI() {
        
        
        uploadBtn.layer.borderWidth = 1
        uploadBtn.layer.borderColor = #colorLiteral(red: 0.7568627451, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        uploadBtn.layer.masksToBounds = false
        uploadBtn.layer.cornerRadius = 19
        //This will change with corners of image and height/2 will make this circle shape
        uploadBtn.clipsToBounds = true
        
        backtoportalBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: backtoportalBtn.frame.size.height/2)
        
    }
    
    
    //MARK:-
    //MARK:- CollectionView DataSources
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (dashBoardCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directoriesArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardCollectionViewCell", for: indexPath) as! DashBoardCollectionViewCell
        
        cell.cellView.layer.borderWidth = 1
        cell.cellView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        cell.cellView.layer.masksToBounds = false
        cell.cellView.layer.cornerRadius = 4 //This will change with corners of image and height/2 will make this circle shape
        cell.cellView.clipsToBounds = true
        
        cell.viewBtn.contentMode = .scaleAspectFit
        cell.viewBtn.clipsToBounds = true
        
        cell.editBtn.contentMode = .scaleAspectFit
        cell.editBtn.clipsToBounds = true
        
        cell.deleteBtn.contentMode = .scaleAspectFit
        cell.deleteBtn.clipsToBounds = true
        
        cell.viewBtn1.contentMode = .scaleAspectFit
        cell.viewBtn1.clipsToBounds = true
        
        cell.editBtn.contentMode = .scaleAspectFit
        cell.editBtn.clipsToBounds = true
        
        if directoriesArray.count > 0 {
            
            
            
            
//            if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil) {
//
//               role = (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int)!
//
//            if role == 6 {
//
//                cell.deleteStackView.isHidden = false
//                cell.viewEditStackView.isHidden = true
//
//            }
//
//            else {
//
//                cell.deleteStackView.isHidden = true
//                cell.viewEditStackView.isHidden = false
//
//            }
//
//            }
            
            if directoriesArray[indexPath.row].dir_name == "Main Directory" {
                
                cell.viewEditStackView.isHidden = false
                cell.deleteStackView.isHidden = true
            }
            
            else {
                 cell.deleteStackView.isHidden = false
                 cell.viewEditStackView.isHidden = true
            }
            
            
            cell.categoryLabel.text = directoriesArray[indexPath.row].dir_name
            
            cell.categoryImageView.sd_setImage(with: URL(string : directoriesArray[indexPath.row].dir_icon), placeholderImage: UIImage(named: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                
            }
            
            cell.onViewButtonTapped = {
                
                let vc:SearchByProfileNameViewController = self.storyboard?.instantiateViewController(withIdentifier:"SearchByProfileNameViewController") as! SearchByProfileNameViewController
                
                vc.obj = self.directoriesArray[indexPath.row]
                self.present(vc, animated: true, completion:nil)
                
                
            }
            
            cell.onEditButtonTapped = {
                
                let vc:EditDirectoryViewController = self.storyboard?.instantiateViewController(withIdentifier:"EditDirectoryViewController") as! EditDirectoryViewController
                vc.obj = self.directoriesArray[indexPath.row]
                vc.delegate = self
                self.present(vc, animated: true, completion:nil)
                
            }
            
            cell.onDeleteButtonTapped = {
                
                let alertController = UIAlertController(title: "", message:"Are you sure you want to delete?", preferredStyle: .alert)
                
                // Create OK button
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    
                    self.deleteDirectoryApi(index: indexPath.row)
                    
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
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if pageNumber != -1 {
        
        if indexPath.row == directoriesArray.count - 1 && directoriesArray.count > 9 {
            
            pageNumber += 1
            self.getDirectoriesList()
        }
            
      }
    }
    
    
    
    //MARK:-
    //MARK:- IB Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
        {
            
            if let role = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
                
                if role  == 6 {
                    
                    
                    sideMenuController?.setContentViewController(with: "\(11)", animated: Preferences.shared.enableTransitionAnimation)
                    
                }
                    
                else {
                    
                    sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                    
                }
            }
                
            else {
                
                sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                
                
                
            }
            
        }
            
        else {
            
            sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
            
            
            
        }
        
        sideMenuController?.hideMenu()
    }
    
    @IBAction func sideMenuBtnAction(_ sender: Any) {
        
        sideMenuController?.revealMenu()
        //        let vc:KeyHolderItemViewController = self.storyboard?.instantiateViewController(withIdentifier:"KeyHolderItemViewController") as! KeyHolderItemViewController
        //
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func uploadBtnAction(_ sender: Any) {
        
        let vc:ContainerForUploadViewController = self.storyboard?.instantiateViewController(withIdentifier:"ContainerForUploadViewController") as! ContainerForUploadViewController
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func addDirectoryBtnAction(_ sender: Any) {
        
        let vc:CreateDirectoryViewController = self.storyboard?.instantiateViewController(withIdentifier:"CreateDirectoryViewController") as! CreateDirectoryViewController
        vc.delegate = self
        self.present(vc, animated: true, completion:nil)
        
    }
    
    @IBAction func backtoPortalBtnAction(_ sender: Any) {
        
        backtoPortalApi()
        
    }
    
    
    
    //MARK:-
    //MARK:- API Methods
    
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
            
            var parameters = [String: Any]()
            parameters = ["page_number":pageNumber, "per_page_directory":"10"]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                
                if pageNumber == 0 {
                    
                    DispatchQueue.main.async {
  
                        ProjectManager.sharedInstance.showLoader()
                        
                    }
                }
                
                Alamofire.request(baseURL + ApiMethods.getDirectoriesList, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? NSArray , data.count > 0 {
                                
                                let array = ProjectManager.sharedInstance.GetDirectoryListObjects(array: data)
                                
                                self.directoriesArray.append(contentsOf: array)
                                
                               // self.directoriesArray = ProjectManager.sharedInstance.GetDirectoryListObjects(array: data)
                                //
                                //                                let directoriesData = NSKeyedArchiver.archivedData(withRootObject: self.directoriesArray)
                                //                                UserDefaults.standard.set(directoriesData, forKey: DefaultsIdentifier.dir_data)
     
                                self.dashBoardCollectionView .reloadData()
                                
                            }
                            
                            else {
                               
                               
                                if self.pageNumber == 0 {
                                    
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:msg!, vc: UIApplication.topViewController()!)
                                    
                                }
                                
                                self.pageNumber = -1

                            }
                        }
                        else {
    
                            if self.pageNumber == 0 {
                                
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:msg!, vc: UIApplication.topViewController()!)
                                
                            }
                            
                            self.pageNumber = -1
                            
  
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
    
    func backtoPortalApi() {
        
        
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
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.leaveImpersonate, method: .post,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
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
                                
                                if  let access_token = data["access_token"] as? String {
                                    
                                    let msg = json["message"] as? String
                                    // let userID =
                                    //ProjectManager.sharedInstance.checkResponseForString(jsonKey:"enc_user_id", dict: data )
                                    
                                    let token_type =  data["token_type"] as? String
                                    UserDefaults.standard.set("Bearer ", forKey:DefaultsIdentifier.token_type)
                                    UserDefaults.standard.set(access_token, forKey:DefaultsIdentifier.access_token)
                                    
                                     UserDefaults.standard.set(access_token, forKey:DefaultsIdentifier.parent_access_token)
                                    
                                    let role = data["role"] as? Int
                                    UserDefaults.standard.set(role, forKey:DefaultsIdentifier.role)
                                    UserDefaults.standard.synchronize()
                                    self.backtoportalBtn.isHidden = true
                                  //  self.addDirectoryBtn.isHidden = false
                                    
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                    self.getDirectoriesList()
                                }
                                
                            }
                        }
                        else {
                            let msg = json["message"] as? String
                            
                            self.navigationController?.popViewController(animated: true)
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
    
    func deleteDirectoryApi(index: Int) {
       
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            let parameters = ["dir_id": directoriesArray[index].id] as [String: Any]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.deleteDirectories, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            self.directoriesArray.remove(at: index)
                            if self.directoriesArray.count > 0 {
                                self.dashBoardCollectionView .reloadData()
                            }
                            
                            else {
                        
                                self.dashBoardCollectionView .reloadData()
                                
                            }
                            
                            
                           let msg = json["message"] as? String
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                           
                        }
                        else {
                            
                                 let msg = json["message"] as? String
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
    
  
    
    func showPopups()
    {
        
        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            //ProjectManager.sharedInstance.showLoader()
            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]
                //let parameters = ["user_id": userId]
                
                Alamofire.request(baseURL + ApiMethods.startquestionnaire, method: .post,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
                    .responseJSON { response in
                        
                        //ProjectManager.sharedInstance.stopLoader()
                        
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
                        
                        UserDefaults.standard.set(true, forKey: "isShowPopup")
                        UserDefaults.standard.synchronize()
                        
                        let status = json["status"] as? Bool
                        if status == true
                        {
                           
                           // DispatchQueue.main.async {
                                
                                
                                let alertVC :QuestionnairePopup = (self.storyboard?.instantiateViewController(withIdentifier: "QuestionnairePopup") as? QuestionnairePopup)!
                                
                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                , tapGestureDismissal: false, panGestureDismissal: false) {
                                    let overlayAppearance = PopupDialogOverlayView.appearance()
                                    overlayAppearance.blurRadius  = 30
                                    overlayAppearance.blurEnabled = true
                                    overlayAppearance.liveBlur    = false
                                    overlayAppearance.opacity     = 0.4
                                }
                                
                                alertVC.noAction = {
                                    
                                    popup.dismiss({
                                        
                                        
                                    })
                                }
                                
                                alertVC.yesAcion = {
                                    
                                    popup.dismiss({
                                        if UIApplication.topViewController() is UIAlertController {
                                            
                                            self.dismiss(animated: true, completion: {
                                                
                                                
                                                let vc:NumberOfQuestionsViewController = self.storyboard?.instantiateViewController(withIdentifier:"NumberOfQuestionsViewController") as! NumberOfQuestionsViewController
                                                
                                                
                                                
                                                // self.present(vc, animated: true, completion: nil)
                                                //self.navigationController?.pushViewController(vc, animated: true)
                                                
                                                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                                            })
                                        }
                                        
                                        else
                                        {
                                            
                                            
                                            let vc:NumberOfQuestionsViewController = self.storyboard?.instantiateViewController(withIdentifier:"NumberOfQuestionsViewController") as! NumberOfQuestionsViewController
                                            
                                            
                                            
                                            // self.present(vc, animated: true, completion: nil)
                                            //self.navigationController?.pushViewController(vc, animated: true)
                                            
                                            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                                        }
                                        
                                       
                                        
                                        
                                    })
                                }
                                
                                UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                                
                                
                                
                                
                           // }
                            
                        }
                            
                        else
                        {
                            let statusCode = json["statusCode"] as? Int
                            if statusCode == 1
                            {
                                
                                let alertVC :TellAboutYourselfPopup = (self.storyboard?.instantiateViewController(withIdentifier: "TellAboutYourselfPopup") as? TellAboutYourselfPopup)!
                                
                                
                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                , tapGestureDismissal: false, panGestureDismissal: false) {
                                    let overlayAppearance = PopupDialogOverlayView.appearance()
                                    overlayAppearance.blurRadius  = 30
                                    overlayAppearance.blurEnabled = true
                                    overlayAppearance.liveBlur    = false
                                    overlayAppearance.opacity     = 0.4
                                }
                                
                                alertVC.noAction = {
                                    
                                    popup.dismiss({
                                        
                                        
                                    })
                                }
                                
                                alertVC.yesAcion = {
                                    
                                    popup.dismiss({
                                        
                                        let vc:TellAboutYourselfViewController = self.storyboard?.instantiateViewController(withIdentifier:"TellAboutYourselfViewController") as! TellAboutYourselfViewController
                                       
                                        
                                         self.present(vc, animated: true, completion: nil)
                                        //self.navigationController?.pushViewController(vc, animated: true)
                                        
                                        
                                    })
                                }
                                
                                UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                                
                            }
                                
                            else if statusCode == 4
                            {
                                self.LogoutApi()
                                let alert = UIAlertController(title: "", message:"Your account is deactivated" , preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
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
    
    func LogoutApi()
    {
        
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
                
                
                
                Alamofire.request(baseURL + ApiMethods.logout, method: .post,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
                    .responseJSON { response in
                        
                        ProjectManager.sharedInstance.stopLoader()
                        
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            if response != nil {
                                let alert = UIAlertController(title: "", message: response.result.error! as! String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
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
                        let status = json["status"] as? NSNumber
                        if status == 1 {
                            
                            UserDefaults.standard.set("logout", forKey:DefaultsIdentifier.login)
                            UserDefaults.standard.synchronize()
                            
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            let vc:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            let nav = UINavigationController(rootViewController: vc)
                            appdelegate.window?.rootViewController = nav
                            
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
    
    

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
