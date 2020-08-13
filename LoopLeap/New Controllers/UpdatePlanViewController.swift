//
//  UpdatePlanViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 14/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog



class UpdatePlanViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, CardAction, ActiveStatusDelegate, cancelStatusDelegate {
    
    func getCancelStatus() {
        
        backBtn.setImage(#imageLiteral(resourceName: "Logout-1"), for: .normal)
        cancelStatusBool = true
        UserDefaults.standard.set(nil, forKey: DefaultsIdentifier.plan_order)
        carousel.reloadData()
        
        
    }
    
    
    func getActiveStatus(status: String) {
        
        
          UserDefaults.standard.set(status, forKey: DefaultsIdentifier.plan_order)

        
    }
    
  
    
    func buyBtnClicked() {
        
        let vc:StripeCardViewController = self.storyboard?.instantiateViewController(withIdentifier:"StripeCardViewController") as! StripeCardViewController
        
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    var imageArray = [UIImage(named: "blueCard"), UIImage(named: "greenCard"), UIImage(named: "pinkCard"), UIImage(named: "blueCard"), UIImage(named: "greenCard"), UIImage(named: "pinkCard"), UIImage(named: "greenCard"), UIImage(named: "pinkCard")]
    var amountArray = ["1", "9", "99", "19", "99", "990" ]
    var decimalArray = [".99", ".99", ".00", ".9", ".9", ".00"]
    var colorArray = [#colorLiteral(red: 0.359110117, green: 0.7624588609, blue: 0.8323337436, alpha: 1), #colorLiteral(red: 0.7064456344, green: 0.8312065005, blue: 0.5807609558, alpha: 1), #colorLiteral(red: 0.9670340419, green: 0.7922397852, blue: 0.8196813464, alpha: 1),#colorLiteral(red: 0.359110117, green: 0.7624588609, blue: 0.8323337436, alpha: 1), #colorLiteral(red: 0.7064456344, green: 0.8312065005, blue: 0.5807609558, alpha: 1), #colorLiteral(red: 0.9670340419, green: 0.7922397852, blue: 0.8196813464, alpha: 1),#colorLiteral(red: 0.7064456344, green: 0.8312065005, blue: 0.5807609558, alpha: 1), #colorLiteral(red: 0.9670340419, green: 0.7922397852, blue: 0.8196813464, alpha: 1)]
    var storageArray = ["100 gb Storage", "1 tb Storage", "10 tb Storage", "1200 gb Storage", "12 tb Storage", "120 tb Storage" ]
    var planArray = ["Monthly Plan","Monthly Plan","Monthly Plan","Annual Plan","Annual Plan","Annual Plan"]
    var card = Card()
    var plansArray = [GetPlanListObject]()
    var fromHomeScreen = Bool()
    var cancelStatusBool = Bool()
    var loginPaymentStatus = Bool()



    @IBOutlet var carousel: iCarousel!
    
    @IBOutlet weak var buyPlanView: UIView!
    @IBOutlet weak var amountImgView: UIImageView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var decimalAmountLabel: UILabel!
    
    @IBOutlet weak var buyNowBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        for i in 0 ... 2 {
//            items.append(i)
//        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cancelStatusBool {
            
             backBtn.setImage(#imageLiteral(resourceName: "Logout-1"), for: .normal)
             //UserDefaults.standard.set(nil, forKey: DefaultsIdentifier.plan_order)

            
        }
        
        self.carousel.delegate = self;
        self.carousel.dataSource = self;
        self.carousel.isUserInteractionEnabled = true
        carousel.type = .rotary
        getPlanApi()
        
        
    
        
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return plansArray.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIView
        
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
            label = itemView.viewWithTag(1) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 260, height: 200))
//            itemView.image = UIImage(named: "page.png")
//            itemView.contentMode = .center
//
//            label = UILabel(frame: itemView.bounds)
//            label.backgroundColor = .clear
//            label.textAlignment = .center
//            label.font = label.font.withSize(50)
//            label.tag = 1
            
            card = Card.init(frame: itemView.bounds)
           // card.delegate = self
            card.amountImgView.image = imageArray[index]
            
            if UserDefaults.standard.value(forKey: DefaultsIdentifier.plan_order) is String {
            
            if  plansArray[index].plan_order == UserDefaults.standard.value(forKey: DefaultsIdentifier.plan_order) as! String
            {
                
                card.statusLabel.text = "Active"
            }
            
            else {
                
                card.statusLabel.text = ""
            }
                
        }
            
            else {
                
                card.statusLabel.text = ""
            }
            
            let delimiter = "."
            let newstr = plansArray[index].price
            var price = newstr.components(separatedBy: delimiter)
            print (price[0])
            card.amountLabel.text = price[0]
            
            let snippet =  plansArray[index].price
            var decimalPrice = String()
            if let range = snippet.range(of: ".") {
              decimalPrice = "." + snippet[range.upperBound...].trimmingCharacters(in: .whitespaces)
                print(decimalPrice) // prints "123.456.7891"
            }
            card.decimalAmountLabel.text = decimalPrice
            card.buyNowView.backgroundColor = colorArray[index]
            card.storageLabel.text = plansArray[index].dir_size
            card.planLabel.text = plansArray[index].plan_duration + "ly"
            card.planTypeLabel.text = plansArray[index].plan_type
           // card.buyPlanView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 8)
            card.buyNowBtn.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 8)
            card.buyNowView.setBorder(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), cornerRaidus: 8)
 
           // let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
           
           // card.buyNowView.addGestureRecognizer(tap)
            
            
            card.buyNowBtn.tag = index
            
            card.buyNowBtn.addTarget(self, action: #selector(buybuttonClicked), for: .touchUpInside)
            
            card.isUserInteractionEnabled =  true
           // card.buyNowView.isUserInteractionEnabled = true
            
           
//            card.buyNowBtn.clipsToBounds =  true
////
//            card.buyNowBtn.addTarget(self,action:#selector(buybuttonClicked),
//                                     for:.touchUpInside)
            //itemView.clipsToBounds = true
            itemView.isUserInteractionEnabled =  true
            itemView.addSubview(card)
            //card.buyNowView.bringSubview(toFront: itemView)
            
            
//
//            let customBtnView = UIView()
//            customBtnView.frame = CGRect(x: 129, y:  479 , width: 156, height: 47)
//
//            customBtnView.backgroundColor = UIColor.red
//
//
//            let button = UIButton(type: .custom)
//            button.frame = CGRect(x: 0, y: 0, width: 156, height: 47)
//            button.backgroundColor = UIColor.clear
//            button.tag = carousel.currentItemIndex
//            button.addTarget(self, action: #selector(buybuttonClicked(sender:)), for: .touchUpInside)
//            customBtnView.addSubview(button)
//
//            carousel.addSubview(customBtnView)
            
           //self.view.bringSubview(toFront: itemView)

        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
      //  label.text = "\(items[index])"
        
       
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    

    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
        if UserDefaults.standard.value(forKey: DefaultsIdentifier.plan_order) is String {
            
            if  plansArray[index].plan_order == UserDefaults.standard.value(forKey: DefaultsIdentifier.plan_order) as! String {
                
                
                
                let alert = UIAlertController(title: "", message: "Plan is already active!", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil )
                
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }
                
            else {
                
                if UserDefaults.standard.value(forKey: DefaultsIdentifier.plan_order)  as! String == "" {
                    
                    let vc:PaymentScreenViewController = self.storyboard?.instantiateViewController(withIdentifier:"PaymentScreenViewController") as! PaymentScreenViewController
                    
                    vc.planId = self.plansArray[index].id
                    vc.planOrder = self.plansArray[index].plan_order
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                    
                    
                }
                
                else {
                
                
                let alert = UIAlertController(title: "", message: "Your current plan will be canceled!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    let vc:PaymentScreenViewController = self.storyboard?.instantiateViewController(withIdentifier:"PaymentScreenViewController") as! PaymentScreenViewController
                    
                    vc.planId = self.plansArray[index].id
                    vc.planOrder = self.plansArray[index].plan_order
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                    
                }
                alert.addAction(cancelAction)
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
                    
            }
                
            }
        }
        
        else {
                let vc:PaymentScreenViewController = self.storyboard?.instantiateViewController(withIdentifier:"PaymentScreenViewController") as! PaymentScreenViewController
                
                vc.planId = self.plansArray[index].id
                vc.planOrder = self.plansArray[index].plan_order
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
        }

}
    
       @objc func buybuttonClicked(sender: UIButton)
    {
        
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code

    
}
    //MARK:-
    //MARK:- IB Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        
        if fromHomeScreen {
            
            self.dismiss(animated: true, completion: nil)
        }
            
        else if cancelStatusBool {
            
            let alert = UIAlertController(title: "", message: "Are you sure? you want to logout.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                self.logoutApi()
                
            }
            alert.addAction(cancelAction)
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        else {
        
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
        
    }
    
    
    @IBAction func infoBtnAction(_ sender: Any) {
        
        
        paymentGeneralApi()
        
    }
    
    @IBAction func historyBtnAction(_ sender: Any) {
        
        let vc:PaymentHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier:"PaymentHistoryViewController") as! PaymentHistoryViewController
        
        self.present(vc, animated: true, completion: nil)

        
        
    }
    
    //MARK:-
    //MARK:- API Methods
    
    func getPlanApi() {
        
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
                
                
                Alamofire.request(baseURL + ApiMethods.createplan, method: .post,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
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
                                
                                
                                let array = ProjectManager.sharedInstance.GetPlanListObjects(array: data)
                                
                                self.plansArray.append(contentsOf: array)
                                
                                self.carousel.reloadData()
                                
                            }
                            
                            else {
                                
                                
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
                                
                                
                                if object.payment_status == "1" || object.payment_status == "2" {
                                    
//                                    UserDefaults.standard.set(object.plan_order, forKey: DefaultsIdentifier.plan_order)
                                    
                                    UserDefaults.standard.synchronize()
                                    
                                    
                                    let alertVC :ActivePlanDetailPopup = (self.storyboard?.instantiateViewController(withIdentifier: "ActivePlanDetailPopup") as? ActivePlanDetailPopup)!
                                    
                                    alertVC.obj = object
                                    alertVC.titleStr = true
                                    alertVC.delegate = self
                                    
                                    let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                    , tapGestureDismissal: true, panGestureDismissal: false) {
                                        let overlayAppearance = PopupDialogOverlayView.appearance()
                                        overlayAppearance.blurRadius  = 30
                                        overlayAppearance.blurEnabled = true
                                        overlayAppearance.liveBlur    = false
                                        overlayAppearance.opacity     = 0.4
                                    }
                                    
                                    alertVC.okAction = {
                                        
                                        popup.dismiss({
                                            
                                            // self.navigationController?.popViewController(animated: true)
                                            
                                        })
                                        
                                        
                                    }
                                    
                                    UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                                    
                                }
                                else {
                                    
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "No Active Plan", vc: UIApplication.topViewController()!)
                                    
                                    
                                }
                                
                            }
                                
                            else {
                                
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


