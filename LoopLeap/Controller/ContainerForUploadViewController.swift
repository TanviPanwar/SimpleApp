//
//  ContainerForUploadViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 15/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import Photos
import PopupDialog
import IQKeyboardManagerSwift
import AVKit

class ContainerForUploadViewController: UIViewController
{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var uploadFileBtn: UIButton!
    @IBOutlet weak var backtoPortalBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var uplaodIndicatorView: UIView!
    @IBOutlet weak var recordIndicatorView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var storageAlertView: UIView!
    @IBOutlet weak var storageLabel: UILabel!
    @IBOutlet weak var showPlanBtn: UIButton!

    
    
    var tagValue = Int()
    var storageObj = GetPlanListObject()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        titleLabel.text = "Upload File"
        
        backtoPortalBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: backtoPortalBtn.frame.size.height/2)
        
        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
        {
            
            if let role = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
            
            if role  == 6 {
                
                 backtoPortalBtn.isHidden = false
                
            }
            
            else {
                
                backtoPortalBtn.isHidden = true
            }
        }
            
            else {
                
                backtoPortalBtn.isHidden = true
                
            }
                
        }
            
        
        else {
            
            backtoPortalBtn.isHidden = true
            
        }
        
        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadFileViewController") as? UploadFileViewController else {
            return
        }
        addChildViewController(childVC)
        //Or, you could add auto layout constraint instead of relying on AutoResizing contraints
        childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childVC.view.frame = containerView.bounds
        
        containerView.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
        
        //Some property on ChildVC that needs to be set
        //childVC.dataSource = self
    
        paymentGeneralApi()
        
       
    }
    
    //MARK:-
    //MARK:- Custom Methods
    
    private lazy var UploadFileViewController: UploadFileViewController = {
        // Load Storyboard
        //let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "UploadFileViewController") as! UploadFileViewController
 
        // Add View Controller as Child View Controller
         self.add(asChildViewController: viewController)

       // self.addChildViewController(viewController)
        
        
        return viewController
    }()
    
    private lazy var TellAboutYourselfViewController: TellAboutYourselfViewController = {
        // Load Storyboard
       // let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "TellAboutYourselfViewController") as! TellAboutYourselfViewController
        
        // Add View Controller as Child View Controller
       self.add(asChildViewController: viewController)
       // self.addChildViewController(viewController)
        
        return viewController
    }()
    
    fileprivate func add(asChildViewController viewController: UIViewController) {
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        if tagValue == 1 {
            remove(asChildViewController: TellAboutYourselfViewController)
            add(asChildViewController: UploadFileViewController)
        } else if tagValue == 2 {
            remove(asChildViewController: UploadFileViewController)
            add(asChildViewController: TellAboutYourselfViewController)
        }
    }
   
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backtoPprtalBtnAction(_ sender: Any) {
        
        backtoPortalApi()
        
    }
    
    @IBAction func uploadFileBtnAction(_ sender: Any) {
        
//        tagValue = uploadFileBtn.tag
//        updateView()
         titleLabel.text = "Upload File"
        uplaodIndicatorView.isHidden = false
        recordIndicatorView.isHidden = true

        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadFileViewController") as? UploadFileViewController else {
            return
        }
        addChildViewController(childVC)
        //Or, you could add auto layout constraint instead of relying on AutoResizing contraints
        childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childVC.view.frame = containerView.bounds
        
        containerView.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
        
    }
    
    @IBAction func recordBtnAction(_ sender: Any) {
        
        // remove(asChildViewController: TellAboutYourselfViewController)
         titleLabel.text = "Record Video/Audio"
        uplaodIndicatorView.isHidden = true
        recordIndicatorView.isHidden = false
         guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "RecordVideoAudioViewController") as? RecordVideoAudioViewController else {
            return
        }
        addChildViewController(childVC)
        //Or, you could add auto layout constraint instead of relying on AutoResizing contraints
        childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childVC.view.frame = containerView.bounds
        
        containerView.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
        
    }
    
    @IBAction func cancelStorageAlertBtnAction(_ sender: Any) {
   
        storageAlertView.isHidden = true

    }
    
    @IBAction func showPlanBtnAction(_ sender: Any) {
  
        let vc:UpdatePlanViewController = self.storyboard?.instantiateViewController(withIdentifier:"UpdatePlanViewController") as! UpdatePlanViewController
        
        vc.fromHomeScreen = true
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    
    //MARK:-
    //MARK:- API Methods
    
    
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
                                   // ProjectManager.sharedInstance.backtoprtalDelegate?.refreshChildDashboard()
                                    
                                    ProjectManager.sharedInstance.refreshTimeLineDelegate?.refreshTimeLine()
                                    
                                    //ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                   // self.sideMenuController?.setContentViewController(with: "\(8)", animated: Preferences.shared.enableTransitionAnimation)
                                    
                                    self.dismiss(animated: true, completion: {
                                        
                                        
                                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                        
                                    })
                                    
                                    
                                   // self.sideMenuController?.hideMenu()
                                    
                                    
                                }
                                
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
    
    func paymentGeneralApi() {
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            let parent_Id =  UserDefaults.standard.value(forKey: DefaultsIdentifier.parent_id) as? String
            var params = ["parent_id":token_type + parent_Id!] as [String: Any]
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.paymentgeneraldata, method: .post,  parameters: params, encoding: JSONEncoding.default, headers:headers)
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
                        let status = json["success"] as? Int
                        if status == 1 {
                            
                            if let data = json["data"] as? [String: Any] {
                                
                                let object = ProjectManager.sharedInstance.GetGeneralPaymentObjects(object: data)
                                self.storageObj = object
                                
                                
                                if object.payment_status == "1" ||  object.payment_status == "2" {
                                    
                                    
                                    let delimiter = " "
                                    var newstr = object.dir_used_storage
                                    var seperatedStr = newstr.components(separatedBy: delimiter)
                                    print (seperatedStr[0])
                                    
                                    let threeDecimalPlaces = String(format: "%.3f", Float(seperatedStr[0])!)
                                    
                                    var snippet = object.dir_used_storage
                                    let unit = snippet.components(separatedBy: " ")[1]
                                    print(unit)
                                    
                                    self.storageAlertView.isHidden = false
                                    self.showPlanBtn.isHidden = true
                                    
                                    if object.payment_status == "2" {
                                        
                                        if object.dir_used_storage == "0 Byte" {
                                            
                                             self.storageLabel.text = "Your Default plan is active. You have used \(object.dir_used_storage) out of \(object.dir_total_storage)."
                                            
                                        }
                                       
                                        else {
                                            
                                        self.storageLabel.text = "Your Default plan is active. You have used \(threeDecimalPlaces) \(unit) out of \(object.dir_total_storage)."
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                    else if object.payment_status == "1"  {
                                    self.storageLabel.text = "Your \(object.plan_type) plan is activated and will be renewed on \(object.subscription_expire). You have used \(threeDecimalPlaces) \(unit) out of \(object.dir_total_storage)."
                                        
                                    }
                                    
                                }
                                else {
                                    
//                                    self.storageAlertView.isHidden = false
//                                    self.showPlanBtn.isHidden = false
//
//
//                                    self.storageLabel.text = "You are running out of storage! Click here to buy/renew a plan."
                                    
                                }
   
                            }
                                
                            else {
                                
                                self.storageAlertView.isHidden = true
                                self.showPlanBtn.isHidden = true
                                
                                let msg = json["message"] as? String
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
