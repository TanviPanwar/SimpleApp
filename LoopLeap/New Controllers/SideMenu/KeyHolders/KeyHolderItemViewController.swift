//
//  KeyHolderItemViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 07/03/19.
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

class KeyHolderItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, KeyholdersListDelegate
{
    
    func refreshKeyholderList() {
        selectedIndex = 0
        getKeyholders()
    }
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var keyHolderCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var keyHoldersTableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImgView: UIImageView!
    
    
    
    
    var itemsArray = ["Key Holders", "Pending Key Holders", "Accepted Invitations", "Pending Invitations"]
    var selectedIndex = Int()
    var selectedBool = Bool()
    var keyHoldersArray = [KeyHolderObject]()
    var pendingKeyHoldersArray = [KeyHolderObject]()
    var acceptedInvitationArray = [KeyHolderObject]()
    var userDirectoryArray = [KeyHolderObject]()
    var fromMenu = Bool()

    
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
//        selectedIndex = 0
       getKeyholders()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
       // selectedIndex = 0
       // getKeyholders()
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
    
    @IBAction func addKeyHolderBtnAction(_ sender: Any) {
        
        //        let vc:AddKeyHolderViewController = self.storyboard?.instantiateViewController(withIdentifier:"AddKeyHolderViewController") as! AddKeyHolderViewController
        //
        
        let vc:AddKeyHolderViewController = self.storyboard?.instantiateViewController(withIdentifier:"AddKeyHolderViewController") as! AddKeyHolderViewController
        
         vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    //MARK:-
    //MARK:- CollectionView DataSources
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //        let cell = self.keyHolderCollectionView.cellForItem(at: indexPath as IndexPath) as? KeyHolderCollectionViewCell
        //        let contentsize: CGFloat = CGFloat(itemsArray[indexPath.row].count)
        
        
        let size =  CGSize(width:(itemsArray[indexPath.row] as NSString).size(withAttributes: nil).width + 35, height: 40)
        
        
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyHolderCollectionViewCell", for: indexPath) as! KeyHolderCollectionViewCell
        
        
        if indexPath.row == selectedIndex {
            cell.horizontalIndicatorView.isHidden = false
        }
        else {
            cell.horizontalIndicatorView.isHidden = true
        }
        
        
        cell.keyHoldersItemCellLabel.text = itemsArray[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
        selectedIndex = row
        self.keyHolderCollectionView.reloadData()
        
        switch selectedIndex {
        case 0:
            titleLabel.text = itemsArray[selectedIndex]
            getKeyholders()
        case 1:
            titleLabel.text = itemsArray[selectedIndex]
            getPendingKeyHolderApi()
        case 2:
            titleLabel.text = itemsArray[selectedIndex]
           getAcceptedInvitationApi()
        case 3:
            titleLabel.text = itemsArray[selectedIndex]
            getKeyholders()
            
        default:
            getKeyholders()
            
        }
    }
    
    
    //MARK:-
    //MARK:- TableView DataSources
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch selectedIndex {
        case 0:
            return keyHoldersArray.count
        case 1:
            return pendingKeyHoldersArray.count
        case 2:
            return acceptedInvitationArray.count
        case 3:
            return keyHoldersArray.count
        default:
            return keyHoldersArray.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        switch selectedIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier:"KeyHolderTableViewCell", for: indexPath) as! KeyHolderTableViewCell
            
            if keyHoldersArray.count > 0 {
                
                cell.keyholderNameLabel.text = keyHoldersArray[indexPath.row].name
                cell.keyHolderMailLabel.text = keyHoldersArray[indexPath.row].email
                cell.keyHolderCallLabel.text = keyHoldersArray[indexPath.row].phone
                cell.keyHolderLocationLabel.text = keyHoldersArray[indexPath.row].address_line_1
                cell.keyHolderImgView.sd_setImage(with: URL(string : keyHoldersArray[indexPath.row].pro_pic), placeholderImage: #imageLiteral(resourceName: "place"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                    
                }
                
                cell.onEditButtonTapped = {
                    
                    let vc:EditKeyHolderViewController = self.storyboard?.instantiateViewController(withIdentifier:"EditKeyHolderViewController") as! EditKeyHolderViewController
                    
                    vc.obj = self.keyHoldersArray[indexPath.row]
                    // vc.newobj = self.keyHoldersArray[indexPath.row].accessible_dir
                    
                    self.present(vc, animated: true, completion:nil)
                    
                }
                
                cell.onCloseButtonTapped = {
                    
                    
                    let alertController = UIAlertController(title: "Are You sure?", message: "Once deleted, Keyholder will be removed permanently!", preferredStyle: .alert)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        
                       self.deleteKeyholders(index: indexPath.row)
                        
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
            
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier:"PendingKeyHoldersTableViewCell", for: indexPath) as! PendingKeyHoldersTableViewCell
            
            if pendingKeyHoldersArray.count > 0 {
                
                cell.keyholderNameLabel.text = pendingKeyHoldersArray[indexPath.row].name
                cell.keyHolderMailLabel.text = pendingKeyHoldersArray[indexPath.row].email
                cell.keyHolderCallLabel.text = pendingKeyHoldersArray[indexPath.row].phone
                cell.keyHolderLocationLabel.text = pendingKeyHoldersArray[indexPath.row].address_line_1
                
                                cell.keyHolderImgView.sd_setImage(with: URL(string : pendingKeyHoldersArray[indexPath.row].pro_pic), placeholderImage: #imageLiteral(resourceName: "place"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                
                                }
                
                cell.onremoveButtonTapped = {
                    
                    let alertController = UIAlertController(title: "Are You sure?", message: "", preferredStyle: .alert)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        
                          self.deletePendingKeyHolder(index: indexPath.row)
                        
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
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier:"AcceptedInvitationTableViewCell", for: indexPath) as! AcceptedInvitationTableViewCell
            
            if acceptedInvitationArray.count > 0 {
                
                if acceptedInvitationArray[indexPath.row].view_shared_link == "1" {
                    
                    
                    cell.sharedDirectoriesBtn.isHidden = false
                    cell.requestAccessBtn.isHidden = true

                    
                }
                
                else {
                    
                    cell.requestAccessBtn.isHidden = false
                    cell.sharedDirectoriesBtn.isHidden = true
       
                }
                
                cell.keyholderNameLabel.text = acceptedInvitationArray[indexPath.row].name
                cell.keyHolderMailLabel.text = acceptedInvitationArray[indexPath.row].email
                cell.keyHolderCallLabel.text = acceptedInvitationArray[indexPath.row].phone
                cell.keyHolderLocationLabel.text = acceptedInvitationArray[indexPath.row].address_line_1
                cell.keyHolderImgView.sd_setImage(with: URL(string : acceptedInvitationArray[indexPath.row].pro_pic), placeholderImage: UIImage(named: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                    
                }
                
                cell.onCloseButtonTapped = {
                    
                    
                    let alertController = UIAlertController(title: "Are You sure?", message: "", preferredStyle: .alert)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        
                        self.deleteAcceptedInvitationApi(index: indexPath.row)
                        
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
                
                cell.onRequestAccessButtonTapped = {
                    
                    
                   self.requestAccessInvitationApi(index: indexPath.row)
                    
                }
                
                cell.onsharedDirButtonTapped = {
                    
                    let vc:ViewPublicDirectoryViewController = self.storyboard?.instantiateViewController(withIdentifier:"ViewPublicDirectoryViewController") as! ViewPublicDirectoryViewController
                    
                    vc.obj = self.acceptedInvitationArray[indexPath.row]
                    vc.acceptedInvBool = true
                    self.present(vc, animated: true, completion:nil)
                   
                    
                }
                
                
                
                cell.onViewQuesButtonTapped = {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewQuestionnaireViewController") as! ViewQuestionnaireViewController
                    vc.obj = self.acceptedInvitationArray[indexPath.row]
                    vc.index = self.selectedIndex
                    
                    self.present(vc, animated: true, completion: nil)
                    
                }
            
                
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier:"PendingInvitationTableViewCell", for: indexPath) as! PendingInvitationTableViewCell
            
            if keyHoldersArray.count > 0 {
                
                cell.keyholderNameLabel.text = keyHoldersArray[indexPath.row].name
                cell.keyHolderMailLabel.text = keyHoldersArray[indexPath.row].email
                cell.keyHolderCallLabel.text = keyHoldersArray[indexPath.row].phone
                cell.keyHolderLocationLabel.text = keyHoldersArray[indexPath.row].address_line_1
                cell.keyHolderImgView.sd_setImage(with: URL(string : keyHoldersArray[indexPath.row].pro_pic), placeholderImage: UIImage(named: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                    
                }
                
                cell.onDoneButtonTapped = {
                    
                    self.acceptPendingInvitationApi(index: indexPath.row)
                    
                }
                
                cell.onCloseButtonTapped = {
                    
                    let alertController = UIAlertController(title: "Are You sure?", message: "", preferredStyle: .alert)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        
                       self.deletePendingInvitationApi(index: indexPath.row)
                        
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
            
        default:
            return UITableViewCell()
        }
        //
        
        
        
        
    }
    
    
    //MARK:-
    //MARK:- API Methods
    
    func getKeyholders() {
        
        
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
            if selectedIndex == 0 {
                parameters = ["keyholder_type":"keyHolders"]
            }
            else if selectedIndex == 3 {
                parameters = ["keyholder_type":"pendingInvitation"]
                
                
            }
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.keyholder, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? NSArray  {
                                if data.count > 0 {
                                print(data)
                                //self.messageLabel.isHidden = true
                                self.messageImgView.isHidden = true

                                self.keyHoldersArray = ProjectManager.sharedInstance.GetKeyHolderListObjects(array: data)
                                
                                if let user_Directory = json["directories"] as? NSArray {
                                    
                                    print(user_Directory)
                                    
                                    self.userDirectoryArray = ProjectManager.sharedInstance.GetuserDirListObjects(array: user_Directory)
                                    
                                }
                                

                                self.keyHoldersTableView.isHidden = false
                                self.keyHoldersTableView .reloadData()
                                
                            }
                                
                                else {
                                    
                                    self.keyHoldersTableView.isHidden = true
                                    // self.messageLabel.isHidden = false
                                    self.messageImgView.isHidden = false
                                    
                                }
                                
                            }
                            else{
                                
                                self.keyHoldersTableView.isHidden = true
                               // self.messageLabel.isHidden = false
                                self.messageImgView.isHidden = false

                               // self.messageLabel.text =  json["message"] as? String
                                
                                
                            }
                            
                        }
                        else {
                            
                            self.keyHoldersTableView.isHidden = true
                            // self.messageLabel.isHidden = false
                            self.messageImgView.isHidden = false
                            
//                                let msg = json["message"] as? String
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
    
    func getPendingKeyHolderApi(){
        
        
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
            parameters = ["keyholder_type":"pendingKeyHolders"]
            
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.keyholder, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                print(data)
                                //self.messageLabel.isHidden = true
                                self.messageImgView.isHidden = true
                                self.pendingKeyHoldersArray = ProjectManager.sharedInstance.GetPendingKeyHolderListObjects(array: data)
                                
                                self.keyHoldersTableView.isHidden = false
                                self.keyHoldersTableView .reloadData()
                                
                            }
                                
                                 else {
                                    
                                    self.keyHoldersTableView.isHidden = true
                                    self.messageImgView.isHidden = false
                                }
                                
                            }
                                
                            else{
                                
                                self.keyHoldersTableView.isHidden = true
                                self.messageImgView.isHidden = false

                               // self.messageLabel.isHidden = false
                               // self.messageLabel.text =  json["message"] as? String

                                
                                
                            }
                        }
                        else {
                            self.keyHoldersTableView.isHidden = true
                            self.messageImgView.isHidden = false
//                             let msg = json["message"] as? String
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
    
    
    func getAcceptedInvitationApi() {
        
        
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
            parameters = ["keyholder_type":"acceptedInvitation"]
                
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.keyholder, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                print(data)
                               // self.messageLabel.isHidden = true
                                self.messageImgView.isHidden = true

                                
                                self.acceptedInvitationArray = ProjectManager.sharedInstance.GetAcceptedInvitationListObjects(array: data)
                                print(self.selectedIndex)
                                self.keyHoldersTableView.isHidden = false
                                self.keyHoldersTableView .reloadData()
                                    
                                }
                                
                                else {
                                    
                                    self.keyHoldersTableView.isHidden = true
                                    self.messageImgView.isHidden = false
                                }
                                
                            }
                            else{
                                
                                self.keyHoldersTableView.isHidden = true
                                self.messageImgView.isHidden = false

//                                self.messageLabel.isHidden = false
//                                self.messageLabel.text =  json["message"] as? String

                                
                                
                            }
                            
                        }
                        else {
                            
                            self.keyHoldersTableView.isHidden = true
                            self.messageImgView.isHidden = false
                            
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
    
    
    func deleteKeyholders(index: Int) {
        
        
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
            parameters = ["receiverid": keyHoldersArray[index].receiver_id]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.deleteKeyholder, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            self.getKeyholders()
                            
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
    
    func deletePendingKeyHolder(index: Int) {
        
        
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
            parameters = ["receivermail": pendingKeyHoldersArray[index].email, "sender_id":pendingKeyHoldersArray[index].sender_id, "action":"removePendingKeyholder"]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.acceptRejectKeyholder, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            self.getPendingKeyHolderApi()
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
    
    func deleteAcceptedInvitationApi(index: Int) {
        
        
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
            parameters = ["sender_id":acceptedInvitationArray[index].sender_id, "action":"removeAcceptedInvitation"]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.acceptRejectKeyholder, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                           // self.getAcceptedInvitationApi()
                            
                            self.acceptedInvitationArray.remove(at: index)
                            
                            if self.acceptedInvitationArray.count > 0 {
                                
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                                self.keyHoldersTableView.isHidden = false
                                self.messageImgView.isHidden = true
                                self.keyHoldersTableView.reloadData()
                            }
                            
                            else {
                                
                                self.keyHoldersTableView.isHidden = true
                                self.messageImgView.isHidden = false
                                self.keyHoldersTableView.reloadData()
                                
                            }
                            
//                            let msg = json["message"] as? String
//                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            
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
    
    func deletePendingInvitationApi(index: Int) {
        
        
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
            parameters = ["sender_id":keyHoldersArray[index].sender_id, "action":"rejectPendingInvitation"]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.acceptRejectKeyholder, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            
                            self.getKeyholders()
                            let msg = json["message"] as? String
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                        }
                        else {
                           
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "PendingInvitation is not Deleted", vc: UIApplication.topViewController()!)
                            
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
    
    
    func acceptPendingInvitationApi(index: Int) {
        
        
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
            parameters = ["sender_id":keyHoldersArray[index].sender_id, "action":"acceptPendingInvitation"]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.acceptRejectKeyholder, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            
                            self.getKeyholders()
                            if let data = json["data"] as? NSArray {
                                print(data)
                            }
                            else{
                                
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
    
    
    
    
    func requestAccessInvitationApi(index: Int)  {
       
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            var parameters = [String: Any]()
            parameters = ["receiver_id": acceptedInvitationArray[index].receiver_id, "sender_id":acceptedInvitationArray[index].sender_id]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.requestAccess, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
    
    
    func viewQuestionnaireApi(index: Int)  {
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            var parameters = [String: Any]()
            parameters = ["sender_id":acceptedInvitationArray[index].sender_id, "page_number":"", "per_page_question":""]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.requestAccess, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            
                            let msg = json["message"] as? String
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            
                            
                            if let data = json["data"] as? NSArray {
                                print(data)
                                
                                
                                
                            }
                            else{
                                
                            }
                            
                        }
                        else {
                            
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "KeyHolder is not Deleted", vc: UIApplication.topViewController()!)
                            
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
