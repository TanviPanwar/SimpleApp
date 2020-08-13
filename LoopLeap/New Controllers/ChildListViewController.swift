//
//  ChildListViewController.s0wift
//  LoopLeap
//
//  Created by iOS6 on 14/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import Photos
import PopupDialog
import IQKeyboardManagerSwift
import AVKit


protocol childDashboardDelegate {
    func refreshChildDashboard()
}

class ChildListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, refreshChildListDelegate, refreshAddedChildDelegate, releaseChildDelegate
{
    func changeReleaseChildStatus() {
        
        self.finalChildArray.removeAll()
        self.childTableView.reloadData()
        pageNumber = 0
        self.getChildList()
        
    }
    
    func refreshAddedChild() {
        
        self.finalChildArray.removeAll()
        self.childTableView.reloadData()
        pageNumber = 0
        self.getChildList()
        
    }
    
    func refreshChildList(index: Int) {
        
        self.finalChildArray.remove(at: index)
        
        if self.finalChildArray.count > 0
        {
            self.messageImgView.isHidden = true
            self.childTableView.isHidden = false
            self.childTableView.reloadData()
            
        }
            
        else {
            
            self.childTableView.reloadData()
            self.childTableView.isHidden = true
            self.messageImgView.isHidden = false
        }
    }
    
    

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backtoPortalBtn: UIButton!
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var messageImgView: UIImageView!
    
    
    var childArray = [KeyHolderObject]()
    var finalChildArray = [KeyHolderObject]()
    var pageNumber = 0
    var roleObject = KeyHolderObject()
    var isEditBool = Bool()

    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        backtoPortalBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: 13)
        
         ProjectManager.sharedInstance.childDelegate = self
        ProjectManager.sharedInstance.addedChildDelegate = self
        ProjectManager.sharedInstance.releaseDelegate = self


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.finalChildArray.removeAll()
        self.pageNumber = 0
        getChildList()
      
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
            
            else  {
                
                sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                
                
                
            }
                
        }
            
        else {
            
            sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
            
            
            
        }
        
        sideMenuController?.hideMenu()
        
    }
    
    
    @IBAction func backtoPortalBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        
        let vc:AddChildProfileViewController = self.storyboard?.instantiateViewController(withIdentifier:"AddChildProfileViewController") as! AddChildProfileViewController
  
        self.isEditBool = false
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    //MARK:-
    //MARK:- TableView DataSources
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return finalChildArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ChildListTableViewCell", for: indexPath) as! ChildListTableViewCell
        
        if finalChildArray.count > 0 {
            
            if finalChildArray[indexPath.row].released == "1"{
                
                cell.releaseBtn.setTitle("Released", for: .normal)
                cell.releaseBtn.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.releaseBtn.isEnabled = false
                
                cell.editBtn.isHidden = true
                cell.closeBtn.isHidden = true
                cell.impersonateBtn.isHidden = true

            }
            
            else {
                
            cell.releaseBtn.setTitle("Release", for: .normal)
            cell.releaseBtn.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
            cell.releaseBtn.isEnabled = true
                
                cell.editBtn.isHidden = false
                cell.closeBtn.isHidden = false
                cell.impersonateBtn.isHidden = false

                
            }
            
        cell.childNameLabel.text = finalChildArray[indexPath.row].name
            cell.profileImg.sd_setImage(with: URL(string : finalChildArray[indexPath.row].profile_pic_url), placeholderImage: #imageLiteral(resourceName: "place"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                
                
            }
    
        
        cell.onReleaseButtonTapped = {
  
            let alertController = UIAlertController(title:"Are you sure?", message: "Once released, child will get a link, where he/she can change his/her email and phone number!", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                self.releaseChild(index: indexPath.row, cell: cell)
                
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
            
            cell.onEditButtonTapped = {
                
                let vc:AddChildProfileViewController = self.storyboard?.instantiateViewController(withIdentifier:"AddChildProfileViewController") as! AddChildProfileViewController
                
                self.isEditBool = true
                vc.childDetailObj = self.finalChildArray[indexPath.row]
                vc.receivedEditBool = self.isEditBool
                vc.index = indexPath.row
                
                self.present(vc, animated: true, completion: nil)
                
                
            }
            
            cell.onCloseButtonTapped = {
                
                //self.deleteChild(index: indexPath.row)
                
                let alertController = UIAlertController(title:"", message: "Are you sure, you want to delete this child!", preferredStyle: .alert)
                
                // Create OK button
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    
                    
                    let alertVC :DeleteChildPopup = (self.storyboard?.instantiateViewController(withIdentifier: "DeleteChildPopup") as? DeleteChildPopup)!
                    
                    alertVC.obj = self.finalChildArray[indexPath.row]
                    
                    alertVC.index = indexPath.row
            
                    
                    let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                    , tapGestureDismissal: false, panGestureDismissal: false) {
                        let overlayAppearance = PopupDialogOverlayView.appearance()
                        overlayAppearance.blurRadius  = 30
                        overlayAppearance.blurEnabled = true
                        overlayAppearance.liveBlur    = false
                        overlayAppearance.opacity     = 0.4
                    }
                    
                    //            alertVC.noAction = {
                    //
                    //                popup.dismiss({
                    //
                    //                    self.navigationController?.popViewController(animated: true)
                    //
                    //                })
                    //
                    //
                    //            }
                    
                    alertVC.sendAction = {
                        
//                        popup.dismiss({
//
//                            // self.navigationController?.popViewController(animated: true)
//
//                        })
                        
                        
                    }
                    
                    alertVC.noAction = {
                        
                        popup.dismiss({
                            
                            // self.navigationController?.popViewController(animated: true)
                            
                        })
                        
                        
                    }
                    
                    UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
   
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
            
            cell.onImpersonateButtonTapped = {
                
                //self.deleteChild(index: indexPath.row)
                
                let alertController = UIAlertController(title:"Are you sure?", message: "You can view the child data.", preferredStyle: .alert)
                
                // Create OK button
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    
                    self.impersonateChild(index: indexPath.row)
                    
                }

                // Create Cancel button
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                    print("Cancel button tapped");
                }
                alertController.addAction(OKAction)
                alertController.addAction(cancelAction)
                
                // Present Dialog message
                self.present(alertController, animated: true, completion:nil)
                
               

            }
            
   }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == finalChildArray.count - 1 && finalChildArray.count  > 9 {
            
            if pageNumber != -1 {
            self.getChildList()
            }
            
        }
        
    }
    
    
    
    //MARK:-
    //MARK:- API Methods
    
    func getChildList() {
        
        
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
            parameters = ["page_number":"\(pageNumber)" , "per_page_child": "10"]
            
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.childList, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                             let data = json["data"] as? NSArray
                             
                            if data!.count > 0 {
                                
                                self.childArray = ProjectManager.sharedInstance.GetPublicDirObjects(array: data!)
                                
                                self.finalChildArray.append(contentsOf: self.childArray)
                                self.messageImgView.isHidden = true
                                self.childTableView.isHidden = false
                                self.childTableView.reloadData()
                                self.pageNumber += 1
                                if self.childArray.count == 0 {
                                    
                                    self.pageNumber = -1

                                }
                                
                            }
                            
                            else {
                                
                                if self.pageNumber == 0 {
                                    
                                    self.messageImgView.isHidden = false
                                    self.childTableView.isHidden = true
                                    self.childTableView.reloadData()
        
                                }
  
                                else {
                                    
                                    self.messageImgView.isHidden = true
                                    self.childTableView.isHidden = false
                                    self.childTableView.reloadData()
                                    
                                }
                                 self.pageNumber = -1
                            }
                            
                        }
                        else {
 
                            
                            self.pageNumber = -1
                            if self.pageNumber == 0 {
                                self.messageImgView.isHidden = false
                                self.childTableView.isHidden = true
                                self.childTableView.reloadData()
                            }
                            
                            else {
                                self.messageImgView.isHidden = true
                                self.childTableView.isHidden = false
                                self.childTableView.reloadData()
                            }
//                                     let msg = json["message"] as? String
//                                  ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
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
    
    func deleteChild(index: Int) {
        
        
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
            parameters = ["child_id": self.finalChildArray[index].id, "phone_code":self.finalChildArray[index].country_code, "phone":self.finalChildArray[index].phone]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.deleteChild, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                             self.finalChildArray.remove(at: index)
                            if self.finalChildArray.count > 0
                            {
                                self.messageImgView.isHidden = true
                                self.childTableView.isHidden = false
                                self.childTableView.reloadData()
                                
                            }
                                
                            else {
                                
                                self.childTableView.reloadData()
                                self.childTableView.isHidden = true
                                self.messageImgView.isHidden = false
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
    
    func releaseChild(index: Int, cell: ChildListTableViewCell ) {
        
        
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
            parameters = ["child_id": self.finalChildArray[index].id]
            
         
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.releaseChild, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            
                            if   let data = json["data"] as? [String: Any] {
                            
                            let releaseObject = ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)
                            
                            let alertVC :EmailVerificationPopupup = (self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationPopupup") as? EmailVerificationPopupup)!
                            
                            alertVC.releaseObj = releaseObject
                            alertVC.index = index                            
                            alertVC.releaseChildBool = true
                            alertVC.obj = releaseObject
                            
                            let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                            , tapGestureDismissal: false, panGestureDismissal: false) {
                                let overlayAppearance = PopupDialogOverlayView.appearance()
                                overlayAppearance.blurRadius  = 30
                                overlayAppearance.blurEnabled = true
                                overlayAppearance.liveBlur    = false
                                overlayAppearance.opacity     = 0.4
                            }
                            
                            alertVC.verifyAction = {
                                
//                                popup.dismiss({
//
//                                    // self.navigationController?.popViewController(animated: true)
//
//                                })
                                
                                
                            }
                            
                            alertVC.noAction = {
                                
                                popup.dismiss({
                                    
                                    // self.navigationController?.popViewController(animated: true)
                                    
                                })
                                
                                
                            }
                            
                            UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                            
                            
                            }
                            
                            else {
                                
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                            
                            //cell.releaseBtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//
//                            if let data = json["data"] as? NSArray {
//                                print(data)
//
//
//
//                            }
//                            else{
//
//                            }
                            
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
    
    
    func impersonateChild(index: Int) {
        
        
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
            parameters = ["child_id": self.finalChildArray[index].id]
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.impersonateChild, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                    
                                    activeStatus = false

                                    // let userID =
                                    //ProjectManager.sharedInstance.checkResponseForString(jsonKey:"enc_user_id", dict: data )
                                    
                                    let token_type =  data["token_type"] as? String
                                    UserDefaults.standard.set("Bearer ", forKey:DefaultsIdentifier.token_type)
                                    UserDefaults.standard.set(access_token, forKey:DefaultsIdentifier.access_token)
                                    
                                   let role = data["role"] as? Int
                                    UserDefaults.standard.set(role, forKey:DefaultsIdentifier.role)                                    
                                    UserDefaults.standard.synchronize()
                                    
                                  
                                }
                                
//                              self.roleObject = ProjectManager.sharedInstance.GetVerifyOtpObjects(array: data)
                                
                                
                                //ProjectManager.sharedInstance.backtoprtalDelegate?.refreshChildDashboard()
                                
                                
                                
                                //ProjectManager.sharedInstance.refreshTimeLineDelegate?.refreshTimeLine()
 
                                self.sideMenuController?.setContentViewController(with: "\(14)", animated: Preferences.shared.enableTransitionAnimation)
                                
                                
                                let msg = json["message"] as? String
                                
                                self.sideMenuController?.hideMenu()
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
      
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
