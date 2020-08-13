//
//  ViewPublicDirectoryViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 02/04/19.
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

class ViewPublicDirectoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var directoryCollectionView: UICollectionView!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    var publicDirArray = [KeyHolderObject]()
    var obj = KeyHolderObject()
    var pageNumber = 0
    var acceptedInvBool = Bool()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if acceptedInvBool == true {
            
            
            getSharedDirectoriesApi()
        }
        
        else {
            
            
        }
        
       // getPublicDirectoryApi()
        
//        directoryCollectionView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //MARK:-
    //MARK:- CollectionView DataSources
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (directoryCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
        
        
      
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if acceptedInvBool == true {
            
            return self.publicDirArray.count
            
        }
        
        else {
              return obj.user_sub_directories.count
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardCollectionViewCell", for: indexPath) as! DashBoardCollectionViewCell
        
        cell.cellView.layer.borderWidth = 1
        cell.cellView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        cell.cellView.layer.masksToBounds = false
        cell.cellView.layer.cornerRadius = 4 //This will change with corners of image and height/2 will make this circle shape
        cell.cellView.clipsToBounds = true
        
        cell.viewBtn1.contentMode = .scaleAspectFit
        cell.viewBtn1.clipsToBounds = true
        
        if acceptedInvBool == true {
        
            if self.publicDirArray.count > 0 {
                
                cell.categoryLabel.text =  publicDirArray[indexPath.row].dir_name
                
                cell.categoryImageView.sd_setImage(with: URL(string : publicDirArray[indexPath.row].dir_icon), placeholderImage: UIImage(named: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
            }
        
        }
            
    }
        else {
        
        if obj.user_sub_directories.count > 0 {
            
            
            
            cell.categoryLabel.text =  obj.user_sub_directories[indexPath.row].dir_name
            
            cell.categoryImageView.sd_setImage(with: URL(string : obj.user_sub_directories[indexPath.row].dir_icon), placeholderImage: UIImage(named: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
            }
        }
            
        }
            
            
                
                cell.onViewButtonTapped = {
                    
                    let vc:ViewPublicDirFilesViewController = self.storyboard?.instantiateViewController(withIdentifier:"ViewPublicDirFilesViewController") as! ViewPublicDirFilesViewController
                    
                  
                    
                    if self.acceptedInvBool == true {
                        
                        vc.acceptedInvBool = true
                        vc.obj = self.publicDirArray[indexPath.row]
                        
                    }
                    
                    else {
                           vc.obj = self.obj.user_sub_directories[indexPath.row]
                    }
                    
                    self.present(vc, animated: true, completion:nil)
                    
                    
                }
           
            
        
        
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == publicDirArray.count - 1 && publicDirArray.count > 9 {
            
            pageNumber += 1
            self.getPublicDirectoryApi()
        }
    }
    
    
    
    
    //MARK:-
    //MARK:- API Methods
    
    func getPublicDirectoryApi()  {
        
        
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
            parameters = ["user_id":obj.id, "page_number":pageNumber, "per_page_directory":"10"]
            
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.getPublicDirectoryWithPaging, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                                
                                let array = ProjectManager.sharedInstance.GetuserDirListObjects(array: data)
                                
                                self.publicDirArray.append(contentsOf: array)
                                
                            //    self.publicDirArray = ProjectManager.sharedInstance.GetuserDirListObjects(array: data)
//                                self.finalPublicDirArray.append(contentsOf:self.publicDirArray)
//
//                                self.messagImgView.isHidden = true
//                                self.directoriesTableView .isHidden = false
                               self.directoryCollectionView.reloadData()
                                
                            }
                                
                            else {
                                
                              
                            }
                        }
                        else {
                            
   
                            let msg = json["message"] as? String
                            
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc:UIApplication.topViewController()!)
                            
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
    
    
    
    
    func getSharedDirectoriesApi() {
        
        
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
            parameters = ["sender_id":obj.sender_id, "page_number":pageNumber, "per_page_directory":"10"]
            
            
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.getSharedDirectoriesWithPagination, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? NSArray , data.count > 0 {
                                
                                
                               // self.statusLabel.isHidden = true

                                let array = ProjectManager.sharedInstance.GetuserDirListObjects(array: data)
                                
                                self.publicDirArray.append(contentsOf: array)
                                
                                //    self.publicDirArray = ProjectManager.sharedInstance.GetuserDirListObjects(array: data)
                                //                                self.finalPublicDirArray.append(contentsOf:self.publicDirArray)
                                //
                                //                                self.messagImgView.isHidden = true
                                //                                self.directoriesTableView .isHidden = false
                                self.directoryCollectionView.reloadData()
                                
                            }
                                
                            else {
                                
                                
                                
                                let msg = json["message"] as? String
                               // self.statusLabel.isHidden = false
                                 // self.statusLabel.text = msg

                                
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc:UIApplication.topViewController()!)
                                
                                
                            }
                        }
                        else {
                            
                            let msg = json["message"] as? String
                            
                            
                                 // self.statusLabel.isHidden = false
                                 // self.statusLabel.text = msg
                            
                            
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc:UIApplication.topViewController()!)
                            
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
