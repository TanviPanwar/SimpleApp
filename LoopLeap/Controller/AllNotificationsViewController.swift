//
//  AllNotificationsViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 01/01/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire


class AllNotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RefreshListDataDelegate
{
    func listDataRefresh() {
        getNotificationList(offset: 0)

    }
    
    
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var allDeleteBtn: UIButton!

    var notificationTitleArray = [String]()
    var dateArray =  [String]()
    var idArray =  [Int]()
    var notificationFinalArray = [String]()
    var dateFinalArray = [String]()
    var notificationIdFinalArray = [Int]()
    var filesArray = [GetNotificationListObject]()
    var filesFinalArray = [GetNotificationListObject]()

    var messageLabel = UILabel()


    var i: Int = 10
    var indicator:ProgressIndicator?



    override func viewDidLoad()
    {
        super.viewDidLoad()
        getNotificationList(offset:0)
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.gray, indicatorColor: UIColor.black, msg: "Landing within minutes,Please hold tight..")
        self.view.addSubview(indicator!)
         messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        messageLabel.text = "No Notification Found"
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Raleway", size: 18)!
        messageLabel.sizeToFit()
        self.notificationTableView.backgroundView = messageLabel;
        notificationTableView.tableFooterView = UIView()
        messageLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    //MARK:-
    //MARK:- Tableview  Datasources

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if  self.filesFinalArray.count  > 0
        {
        return filesFinalArray.count //notificationFinalArray.count
        }
        else {
          
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"NotificationCell", for: indexPath) as? AllNotificationsTableViewCell else {return UITableViewCell() }

        cell.titleLabel.text = filesFinalArray[indexPath.row].notification
        cell.titleLabel.sizeToFit()
        cell.selectionStyle = .none

        //notificationFinalArray[indexPath.row]

//        let delimiter = " "
//        var newstr = filesFinalArray[indexPath.row].created_at
//        var token = newstr.components(separatedBy: delimiter)
//        print (token[0])
        
        cell.dateLabel.text = filesFinalArray[indexPath.row].created_at //dateFinalArray[indexPath.row]


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        guard let cell1 = tableView.cellForRow(at: indexPath) as? AllNotificationsTableViewCell else {
        //            // couldn't get the cell for some reason
        //            return
        //        }

        //        guard (tableView.cellForRow(at: indexPath) as? AllNotificationsTableViewCell) != nil
        //            else
        //        {
        //            // couldn't get the cell for some reason
        //            return
        //        }


        let vc:SelectedNotificationViewController = self.storyboard?.instantiateViewController(withIdentifier:"SelectedNotificationViewController") as! SelectedNotificationViewController


        //print(notificationIdFinalArray[indexPath.row])
        vc.obj = filesFinalArray[indexPath.row].id
        vc.notificationTitle = filesFinalArray[indexPath.row].notification
            // notificationIdFinalArray[indexPath.row]

        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)


        
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row ==  filesArray.count - 1 //notificationTitleArray.count - 1

        {

            //indicator!.start()
            getNotificationList(offset: 0 + i)
            //


            //
            //            indicator!.stop()


        }

        else if filesArray.count < 10
        {

            print(self.filesArray.count)
        }

    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {


        let deleteaction =  UIContextualAction(style: .normal, title: "Files", handler: { (action,view,completionHandler ) in
            //do stuff
            DispatchQueue.main.async {
                let alert = UIAlertController(title:"Are you sure ?", message: "Once delete , You will not be able to recover", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
                let delete = UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                    self.clearNotification(notificationId: self.filesFinalArray[indexPath.row].id, tag: indexPath.row)
                })
                alert.addAction(cancelAction)
                alert.addAction(delete)
                self.present(alert, animated: true, completion: nil)
            }

            completionHandler(true)
        })
        deleteaction.image = UIImage(named: "delete")
        deleteaction.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        let confrigation = UISwipeActionsConfiguration(actions: [deleteaction])

        return confrigation
    }

    //MARK:-
    //MARK:- IBAction Methods

    @IBAction func backButtonAction(_ sender: Any)
    {
        
        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
        {
            
            if  let role = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
            
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

    @IBAction func allDeleteAction(_ sender: Any)
    {
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

                Alamofire.request(baseURL + ApiMethods.clearallnotification, method: .post,  parameters: nil, encoding: JSONEncoding.default,  headers: headers)
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
                        self.filesFinalArray.removeAll()
                        self.notificationTableView.reloadData()
                        self.messageLabel.isHidden = false
                        self.allDeleteBtn.isHidden = true

                      //  self.getNotificationList(offset: 0)
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

    //MARK:-
    //MARK:- Api's Methods

    func getNotificationList(offset: Int)
    {
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            let parameters:[String : Any] = ["offset":offset]

            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                if i == 10 {
                ProjectManager.sharedInstance.showLoader()
                }
                Alamofire.request(baseURL + ApiMethods.notificationslist, method: .post,  parameters: parameters, encoding: JSONEncoding.default,  headers: headers)
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

                        if let data = json["data"] as? NSArray  //[[String:Any]]
                        {
                            self.i += 10
                            print(data)
                            self.filesArray = ProjectManager.sharedInstance.GetNotificationListObjects(array: data)
                            self.filesFinalArray.append(contentsOf:self.filesArray)
                            print(self.filesFinalArray)
                            self.notificationTableView.isHidden = false
                            self.allDeleteBtn.isHidden = false

                            self.notificationTableView .reloadData()


                            //                self.notificationTitleArray = data.map { $0["notification"]} as! [String]
                            //                print(self.notificationTitleArray)
                            ////                self.dateArray = data.map { $0["updated_at"]} as! [String]
                            ////                print(self.dateArray)
                            //                self.idArray = data.map { $0["id"]} as! [Int]
                            //                print(self.idArray)
                            //
                            //                self.notificationFinalArray.append(contentsOf: self.notificationTitleArray)
                            //                 print(self.notificationFinalArray)
                            //                self.dateFinalArray.append(contentsOf: self.dateArray)
                            //                print(self.dateFinalArray)
                            //
                            //                self.notificationIdFinalArray.append(contentsOf: self.idArray)
                            //                print(self.notificationIdFinalArray)
                            //
                            //                self.notificationTableView .reloadData()
                            DispatchQueue.main.async {
                                if  self.filesFinalArray.count > 0 {
                                    self.messageLabel.isHidden = true
                                    self.allDeleteBtn.isHidden = false

                                } else
                                {
                                    self.messageLabel.isHidden = false
                                    //self.notificationTableView.isHidden = true
                                    self.allDeleteBtn.isHidden = true
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
}

    func clearNotification(notificationId: String ,tag :Int)
    {

        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
        //let todoEndpoint: String = "http://dev.loopleap.com/api/clearnotification"
          let parameters = ["notification_id": notificationId]

          if ProjectManager.sharedInstance.isInternetAvailable()
          {
               ProjectManager.sharedInstance.showLoader()

            Alamofire.request(baseURL + ApiMethods.clearnotification, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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

                    guard status == 1 else {
                        print("didn't get todo object as JSON from API")
                       

                        return
                    }

                    self.filesFinalArray.remove(at: tag)
                    self.notificationTableView.reloadData()

                    let alert = UIAlertController(title: "", message: json["message"] as? String, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                    




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
