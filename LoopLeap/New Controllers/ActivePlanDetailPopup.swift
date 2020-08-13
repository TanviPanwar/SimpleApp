//
//  ActivePlanDetailPopup.swift
//  LoopLeap
//
//  Created by iOS6 on 21/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import MobileCoreServices
import PopupDialog
import IQKeyboardManagerSwift
import Alamofire

protocol cancelStatusDelegate {
    func getCancelStatus()
}

class ActivePlanDetailPopup: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activePlanLabel: UILabel!
    @IBOutlet weak var totalStorageLabel: UILabel!
    @IBOutlet weak var availableStorageLabel: UILabel!
    @IBOutlet weak var usedStorageLabel: UILabel!
    @IBOutlet weak var expiresLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    var okAction :blockAction?
    var obj = GetPlanListObject()
    var titleStr = Bool()
    var delegate : cancelStatusDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        okBtn.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: okBtn.frame.size.height/2)
        

        if titleStr {
            
            titleLabel.text = "Plan Info"
            okBtn.setTitle("Cancel Subscription", for: .normal)
            if obj.payment_status == "2" {
                
                            okBtn.isHidden = true
                
                self.okBtn.translatesAutoresizingMaskIntoConstraints = true
                self.popupView.translatesAutoresizingMaskIntoConstraints = true

              
                
                
                
                
               // answerlabel.frame = CGRect(x: answerlabel.frame.origin.x , y: answerlabel.frame.origin.y, width: answerlabel.frame.size.width, height: answerlabel.frame.size.height)
                
                popupView.frame = CGRect(x: popupView.frame.origin.x , y:popupView.frame.origin.y    , width: popupView.frame.size.width, height: okBtn.frame.origin.y)
                
                        }
                
                        else {
                            okBtn.isHidden = false
                
                
                        }
        }
        
        else {
            
            titleLabel.text = "Plan Info"
            okBtn.setTitle("OK", for: .normal)

   
        }
        
        if obj.payment_status == "2" {
            
            activePlanLabel.text = ": " + "Default"

        }
        else {
            activePlanLabel.text = ": " + obj.plan_type
        }
        
        totalStorageLabel.text = ": " + obj.dir_total_storage

                let delimiter = " "
                var newstr = obj.dir_pending_storage
                var seperatedStr = newstr.components(separatedBy: delimiter)
                print (seperatedStr[0])
        
        let twoDecimalPlaces = String(format: "%.3f", Float(seperatedStr[0])!)
        
        var snippet = obj.dir_pending_storage
        let unit = snippet.components(separatedBy: " ")[1]
        print(unit)

        availableStorageLabel.text = ": " + "\(twoDecimalPlaces)" + " " + unit
        
        
        if obj.dir_used_storage == "0 Byte" {
            
            usedStorageLabel.text = ": " + obj.dir_used_storage

            
        }
        
        else {
        
        let delimiter1 = " "
        var newstr1 = obj.dir_used_storage
        var seperatedStr1 = newstr1.components(separatedBy: delimiter1)
        print (seperatedStr1[0])
        
        let twoDecimalPlaces1 = String(format: "%.3f", Float(seperatedStr1[0])!)
        
        var snippet1 = obj.dir_used_storage
        let unit1 = snippet1.components(separatedBy: " ")[1]
        print(unit1)
        
        
        usedStorageLabel.text = ": " + "\(twoDecimalPlaces1)" + " " + unit1
            
        }
        
        
        
        if obj.payment_status == "2" {
            
           expiresLabel.text =  ": LifeTime"
        }
            
        else {
        expiresLabel.text = ": " + obj.subscription_expire
            
        }

    }
    

    @IBAction func okBtnAction(_ sender: Any) {
        
        
        if titleStr {
            
            let alert = UIAlertController(title: "", message: "Are you sure? you want to cancel the subscription. Your data will get deleted and you won't able to access the app untill you buy any plan.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                self.cancelSubscriptionApi()
                self.okAction!()

             
            }
            alert.addAction(cancelAction)
            alert.addAction(OKAction)
 
            self.present(alert, animated: true, completion: nil)
    
        }
        
        else {
           
             okAction!()
            
        }
        
        
       
        
        
    }
  
    
    //MARK:-
    //MARK:- API Methods
    
    func cancelSubscriptionApi() {
        
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
                
                
                Alamofire.request(baseURL + ApiMethods.cancelsubscription, method: .post,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
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
                   
                           activeStatus = false
                            
                            let msg = json["message"] as? String
                         // ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)

                            self.delegate?.getCancelStatus()
                            
                            let alert = UIAlertController(title: "", message: msg!, preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
                            
                                
//                            { (action:UIAlertAction!) in
//
//
//
//                                let vc:TimeLineHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier:"TimeLineHistoryViewController") as! TimeLineHistoryViewController
//
//
//
//                                let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
//
//                                let window = UIApplication.shared.delegate?.window
//                                // window = UIWindow(frame: UIScreen.main.bounds)
//                                window!!.rootViewController = SideMenuController(contentViewController: vc,
//                                                                                 menuViewController: menuViewController)
//
//
//
//                            }
                           
                            alert.addAction(OKAction)
                            
                            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                           
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
