//
//  PaymentHistoryViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 20/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import  Alamofire

class PaymentHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var paymentHistoryTableView: UITableView!
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    var historyArray = [GetPlanListObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getHistoryApi()
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK:-
    //MARK:- TableView DataSources
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return historyArray.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 114
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PaymentHistoryTableViewCell", for: indexPath) as! PaymentHistoryTableViewCell
        
        if  historyArray[indexPath.row].subscription_status == "1" {
            
            
            cell.cellSubView.setBorder(width: 1, color: UIColor.init(alpha: 1.0, red: 146, green: 224, blue: 43), cornerRaidus: 4)
        }
        
        else {
            
            cell.cellSubView.setBorder(width: 1, color: #colorLiteral(red: 0.830683291, green: 0.830683291, blue: 0.830683291, alpha: 1), cornerRaidus: 4)
            
        }

        
        if historyArray[indexPath.row].plan_type == "Silver" {

             cell.cellPlanTypeLabel.textColor = UIColor.init(alpha: 1.0, red: 192, green: 192, blue: 192)
            
        }
        
        else if historyArray[indexPath.row].plan_type == "Bronze" {
            
            cell.cellPlanTypeLabel.textColor =  UIColor.init(alpha: 1.0, red: 205, green: 127, blue: 50)
        }
        
        else if historyArray[indexPath.row].plan_type == "Gold" {
            
            cell.cellPlanTypeLabel.textColor = UIColor.init(alpha: 1.0, red: 255, green: 215, blue: 0)
        }
        
        else {
            
            cell.cellPlanTypeLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

            
        }
 
        cell.cellPlanTypeLabel.text = historyArray[indexPath.row].plan_type
        cell.cellPlanPurchaseLabel.text = historyArray[indexPath.row].purchased_date
        
        if historyArray[indexPath.row].subscription_status == "1" {
            
            cell.statusOnLabel.text = "Expires On"
            cell.cellExpiresOnLabel.text = historyArray[indexPath.row].subscription_expire
            
        }
        
        else if historyArray[indexPath.row].subscription_status == "2" {
    
            cell.statusOnLabel.text = "Failed On:"
            cell.cellExpiresOnLabel.text = historyArray[indexPath.row].subscription_expire
   
        }
        
        else if historyArray[indexPath.row].subscription_status == "3" {
            
            cell.statusOnLabel.text = "Cancelled On:"
            cell.cellExpiresOnLabel.text = historyArray[indexPath.row].subscription_canceled
            
        }
        
        else if historyArray[indexPath.row].subscription_status == "4" {
            
            cell.statusOnLabel.text = "Pending On:"
            cell.cellExpiresOnLabel.text = historyArray[indexPath.row].subscription_expire
            
        }
        
        else {
            
            cell.statusOnLabel.text = "Expires On:"
            cell.cellExpiresOnLabel.text = historyArray[indexPath.row].subscription_expire
            
        }
        
        cell.cellPriceLabel.text = historyArray[indexPath.row].price
        cell.cellStorageLabel.text = historyArray[indexPath.row].dir_size

        
        return cell
    }
    
  
    
    //MARK:-
    //MARK:- API Methods
    
    func getHistoryApi() {
        
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
                
                
                Alamofire.request(baseURL + ApiMethods.transactionhistory, method: .post,  parameters: params, encoding: JSONEncoding.default, headers:headers)
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
                            
                            if let data = json["data"] as? NSArray , data.count > 0 {
                                
                                self.statusImageView.isHidden = true

                             let array = ProjectManager.sharedInstance.GetPlanListObjects(array: data)
                                
                                self.historyArray.append(contentsOf: array)
                                
                                self.paymentHistoryTableView.reloadData()
                                
                            }
                                
                            else {
                                
                                self.statusImageView.isHidden = false

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
