//
//  PublicDirectoriesViewController.swift
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


class PublicDirectoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var directoriesTableView: UITableView!
    @IBOutlet weak var messagImgView: UIImageView!
    
    
    var publicDirArray = [KeyHolderObject]()
    var finalPublicDirArray = [KeyHolderObject]()
    var searchPublicDirArray = [KeyHolderObject]()
    var searchFinalPublicDirArray = [KeyHolderObject]()
    
    var pageNumber : Int = 0
    var searchPageNumber : Int = 0
    var btnTagValue = Int()

    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        searchView.setBorder(width: 1, color: #colorLiteral(red: 0.8022919297, green: 0.8022919297, blue: 0.8022919297, alpha: 1), cornerRaidus: searchView.frame.height/2)
        searchBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus:searchBtn.frame.height/2)
        getPublicUsersList()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
//        pageNumber = 0
//        searchPageNumber = 0
//        self.publicDirArray.removeAll()
//        self.finalPublicDirArray.removeAll()
        
        
    }
    
    //MARK:-
    //MARK:- IB Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        
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
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
        
        searchPageNumber = 0
        self.publicDirArray.removeAll()
        self.finalPublicDirArray.removeAll()
        self.directoriesTableView.reloadData()
        searchBtn.tag = 1
        btnTagValue = searchBtn.tag
        
        searchApi()
    }
    
    
    //MARK:-
    //MARK:- TableView DataSources
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return publicDirArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PublicDirectoriesTableViewCell", for: indexPath) as! PublicDirectoriesTableViewCell
        
        if publicDirArray.count > 0 {
            
            cell.nameLabel.text = publicDirArray[indexPath.row].name
            cell.mailLabel.text = publicDirArray[indexPath.row].email
            cell.locationLabel.text = publicDirArray[indexPath.row].address_line_1
            
            let phoneNumber = publicDirArray[indexPath.row].country_code + "-" + publicDirArray[indexPath.row].phone
            
            cell.phoneNumberLabel.text = phoneNumber
            cell.profileImgView.sd_setImage(with: URL(string : publicDirArray[indexPath.row].pro_pic), placeholderImage: UIImage(named: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                
            }
            
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == finalPublicDirArray.count - 1 && finalPublicDirArray.count  > 9 {
            
            
            if btnTagValue == 1{
                
                searchPageNumber += 1
                self.searchApi()
            }
            else {
            pageNumber += 1
            self.getPublicUsersList()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc:ViewPublicDirectoryViewController = self.storyboard?.instantiateViewController(withIdentifier:"ViewPublicDirectoryViewController") as! ViewPublicDirectoryViewController
        
        vc.obj = self.finalPublicDirArray[indexPath.row]
        // vc.delegate = self
        self.present(vc, animated: true, completion:nil)
        
        
    }
    
    //MARK:-
    //MARK:- API Methods
    
    func getPublicUsersList() {
        
        
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
            parameters = ["page_number":"\(pageNumber)", "per_page_profile":"10"]
            
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.publicProfile, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? NSArray {
                                
                                self.publicDirArray = ProjectManager.sharedInstance.GetPublicDirObjects(array: data)
                                self.finalPublicDirArray.append(contentsOf:self.publicDirArray)
                                
                                self.messagImgView.isHidden = true
                                self.directoriesTableView .isHidden = false
                                self.directoriesTableView.reloadData()
                                
                            }
                                
                            else {
                                
                                if self.pageNumber == 0 {
                                    
                                    self.messagImgView.isHidden = false
                                    self.directoriesTableView .isHidden = true
                                    
                                }
                            }
                        }
                        else {
                            
                            if self.pageNumber == 0 {
                                
                                self.messagImgView.isHidden = false
                                self.directoriesTableView .isHidden = true
                                
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
            parameters = ["page_number":"\(searchPageNumber)", "per_page_profile":"10", "search":searchStr]
            
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.publicProfile, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? NSArray {
                              
                                self.publicDirArray = ProjectManager.sharedInstance.GetPublicDirObjects(array: data)
                                self.finalPublicDirArray.append(contentsOf:self.publicDirArray)
                                
                                self.messagImgView.isHidden = true
                                self.directoriesTableView .isHidden = false
                                self.directoriesTableView.reloadData()
                                
                            }
                                
                            else {
                                
                                if self.searchPageNumber == 0 {
                                   
                                    self.messagImgView.isHidden = false
                                    self.directoriesTableView .isHidden = true
    
                                }
                            }
                        }
                        else {
                            
                            if self.searchPageNumber == 0 {
                            
                                self.messagImgView.isHidden = false
                                self.directoriesTableView .isHidden = true
                                
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
