//
//  MenuViewController.swift
//  SideMenuExample
//
//  Created by kukushi on 11/02/2018.
//  Copyright © 2018 kukushi. All rights reserved.
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

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class MenuViewController: UIViewController {
    var isDarkModeEnabled = false
    var role = Int()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
           tableView.separatorStyle = .singleLine
            tableView.tableFooterView = UIView()

        }
    }
    @IBOutlet weak var selectionTableViewHeader: UILabel!

    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    private var themeColor = UIColor.white
    
    var categoryArray = ["Key Holders", "Public","Folders","Child", "About", "Invite", "Security", "Investors", "FAQ", "Notifications", "Questionnaire", "Storage", "Settings", "Logout"]
    var categoryImageArray = [UIImage(named: "keyholder"), UIImage(named: "Public"),UIImage(named: "folders"), UIImage(named: "child-1"), UIImage(named: "About"), UIImage(named: "Invite"), UIImage(named: "security"), UIImage(named: "Investors"), UIImage(named: "FAQ"), UIImage(named: "notification-1"),UIImage(named: "questons"),UIImage(named: "menuStorage"),  UIImage(named: "Settings"), UIImage(named: "Logout-1")]
    
     var categoryChildArray = ["Public","Folders", "About", "Invite", "Security", "Investors", "FAQ","Questionnaire", "Storage","Settings", "Logout"]
    var categoryChildImageArray = [UIImage(named: "Public"),UIImage(named: "folders"), UIImage(named: "About"), UIImage(named: "Invite"), UIImage(named: "security"), UIImage(named: "Investors"), UIImage(named: "FAQ"),UIImage(named: "questons"),UIImage(named: "menuStorage"), UIImage(named: "Settings"), UIImage(named: "Logout-1")]

    override func viewDidLoad() {
        super.viewDidLoad()

        isDarkModeEnabled = SideMenuController.preferences.basic.position == .under
        configureView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isDarkModeEnabled = SideMenuController.preferences.basic.position == .under
        configureView()
        
        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
        {
            
            if let userRole = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
            
            role = userRole
            
            if role  == 6 {
                

                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "PublicDirectoriesViewController")
                }, with: "0")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController")
                }, with: "1")
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController")
                }, with: "2")
                
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "InviteViewController")
                }, with: "3")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "SecurityViewController")
                }, with: "4")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "InvestorsViewController")
                }, with: "5")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController")
                }, with: "6")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "AnsweredQuestionsListViewController")
                }, with: "7")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdatePlanViewController")
                }, with: "8")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController")
                }, with: "9")
                
//                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController")
//                }, with: "7")
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: "TimeLineHistoryViewController")
                }, with: "11")
            }
                
            else {
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController")
                }, with: "0")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "PublicDirectoriesViewController")
                }, with: "1")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController")
                }, with: "2")
                
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: "ChildListViewController")
                }, with: "3")
                
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController")
                }, with: "4")
                
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "InviteViewController")
                }, with: "5")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "SecurityViewController")
                }, with: "6")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "InvestorsViewController")
                }, with: "7")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController")
                }, with: "8")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "AllNotificationsViewController")
                }, with: "9")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "AnsweredQuestionsListViewController")
                }, with: "10")

                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdatePlanViewController")
                }, with: "11")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController")
                }, with: "12")
                
//                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController")
//                }, with: "10")
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: "TimeLineHistoryViewController")
                }, with: "14")
                
            }
            
        }
            
            else {
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController")
                }, with: "0")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "PublicDirectoriesViewController")
                }, with: "1")
                
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController")
                }, with: "2")
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: "ChildListViewController")
                }, with: "3")
                
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController")
                }, with: "4")
                
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "InviteViewController")
                }, with: "5")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "SecurityViewController")
                }, with: "6")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "InvestorsViewController")
                }, with: "7")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController")
                }, with: "8")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "AllNotificationsViewController")
                }, with: "9")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "AnsweredQuestionsListViewController")
                }, with: "10")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdatePlanViewController")
                }, with: "11")
                
                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController")
                }, with: "12")
                
                //                sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController")
                //                }, with: "10")
                
                sideMenuController?.cache(viewControllerGenerator: {
                    self.storyboard?.instantiateViewController(withIdentifier: "TimeLineHistoryViewController")
                }, with: "14")
                
            }
                
        }
            
 
        else {
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController")
        }, with: "0")
        
        sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "PublicDirectoriesViewController")
        }, with: "1")
            
            sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "DashBoardViewController")
            }, with: "2")
        
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ChildListViewController")
        }, with: "3")
        
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController")
        }, with: "4")
        
        
        sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "InviteViewController")
        }, with: "5")
        
        sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "SecurityViewController")
        }, with: "6")
        
        sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "InvestorsViewController")
        }, with: "7")
        
        sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController")
        }, with: "8")
        
        sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "AllNotificationsViewController")
        }, with: "9")
            
            sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "AnsweredQuestionsListViewController")
            }, with: "10")
        
        sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdatePlanViewController")
        }, with: "11")
            
        sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController")
            }, with: "12")
        
//        sideMenuController?.cache(viewControllerGenerator: {            self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController")
//        }, with: "10")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "TimeLineHistoryViewController")
        }, with: "14")
        
        }
        
        sideMenuController?.delegate = self
        tableView.reloadData()
        
        
        
    }

    private func configureView() {
        if isDarkModeEnabled {
            themeColor = UIColor(red: 0.03, green: 0.04, blue: 0.07, alpha: 1.00)
            selectionTableViewHeader.textColor = .white
        } else {
            selectionMenuTrailingConstraint.constant = 0 //0
            themeColor = UIColor(red: 0.98, green: 0.97, blue: 0.96, alpha: 1.00)
        }

        let sidemenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
        if showPlaceTableOnLeft {
            selectionMenuTrailingConstraint.constant = SideMenuController.preferences.basic.menuWidth - view.frame.width
            print("**************", SideMenuController.preferences.basic.menuWidth - view.frame.width)
        }

        view.backgroundColor = themeColor
        tableView.backgroundColor = themeColor
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let sidemenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
        selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        view.layoutIfNeeded()
    }
}

extension MenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }

    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }

    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }

    func sideMenuWillHide(_ sideMenu: SideMenuController) {
        print("[Example] Menu will hide")
    }

    func sideMenuDidHide(_ sideMenu: SideMenuController) {
        print("[Example] Menu did hide.")
    }

    func sideMenuWillReveal(_ sideMenu: SideMenuController) {
        print("[Example] Menu will show.")
    }

    func sideMenuDidReveal(_ sideMenu: SideMenuController) {
        print("[Example] Menu did show.")
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if role == 6 {
            
           return categoryChildArray.count
        }
            
        else {
            
            return categoryArray.count
            
        }
        
        
    }

    // swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectionCell
        cell.contentView.backgroundColor = themeColor
        cell.sideMenuCellImg.tintColor = #colorLiteral(red: 0.7130157351, green: 0.008198360913, blue: 0, alpha: 1)
        let row = indexPath.row
        if role == 6 {
            
            cell.titleLabel?.text = categoryChildArray[row]
            cell.sideMenuCellImg.image = categoryChildImageArray[row]
            
        }
        
        else {
        
        cell.titleLabel?.text = categoryArray[row]
        cell.sideMenuCellImg.image = categoryImageArray[row]
            
        }
        
//        if row == 0 {
//            cell.titleLabel?.text = "Preferences"
//        } else if row == 1 {
//            cell.titleLabel?.text = "Scroll View and Others"
//        } else if row == 2 {
//            cell.titleLabel?.text = "IB / Code"
//        }
        cell.titleLabel?.textColor = isDarkModeEnabled ? .white : .black
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row

        
        
        if role == 6 {
            
            if row == 10 {
                
                
                let alertController = UIAlertController(title: "", message:"Are you sure you want to logout?", preferredStyle: .alert)
                
                // Create OK button
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    
                    self.logoutApi()
                    
                }
                alertController.addAction(OKAction)
                
                // Create Cancel button
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                    print("Cancel button tapped");
                }
                alertController.addAction(cancelAction)
                
                // Present Dialog message
                self.present(alertController, animated: true, completion:nil)
                
                
                sideMenuController?.hideMenu()
                
            }
            
            else {
                
                sideMenuController?.setContentViewController(with: "\(row)", animated: Preferences.shared.enableTransitionAnimation)
                sideMenuController?.hideMenu()
                
                if let identifier = sideMenuController?.currentCacheIdentifier() {
                    print("[Example] View Controller Cache Identifier: \(identifier)")
                }

            
         
                
        }
            
    }
      
        else {
            
         if  row == 13 {
            
            
            let alertController = UIAlertController(title: "", message:"Are you sure you want to logout?", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
                self.logoutApi()
                
            }
            alertController.addAction(OKAction)
            
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
            
           
            self.sideMenuController?.hideMenu()
     
        }
            
         else {
            
            self.sideMenuController?.setContentViewController(with: "\(row)", animated: Preferences.shared.enableTransitionAnimation)
            self.sideMenuController?.hideMenu()
            
            if let identifier = self.sideMenuController?.currentCacheIdentifier() {
                print("[Example] View Controller Cache Identifier: \(identifier)")
            }

            
        }
    
        
        
//        sideMenuController?.cache(viewController: KeyHolderItemViewController, with: "third")
//        sideMenuController?.setContentViewController(with: "third")

//        let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController")
//        let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
//        let sideMenuController = SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
//        UIApplication.shared.keyWindow?.rootViewController = sideMenuController
        
        }
    
        
    }
        


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func logoutApi() {
        
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            //            var parameters = [String: Any]()
            //
            //                parameters = ["sender_id":obj.sender_id,]
            
            
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
                            
                            UserDefaults.standard.set("logout", forKey:DefaultsIdentifier.login)
                            
                             UserDefaults.standard.set("0", forKey:DefaultsIdentifier.role)
                            
                             UserDefaults.standard.set(nil, forKey: DefaultsIdentifier.plan_order)
                             UserDefaults.standard.set("", forKey: DefaultsIdentifier.parent_id)
                            activeStatus = false
                           
                            
                            UserDefaults.standard.synchronize()
                            
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            let storyBoard = UIStoryboard(name:"Main", bundle: nil)
                            let vc:LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
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
    
    
}



class SelectionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sideMenuCellImg: UIImageView!
    
}
