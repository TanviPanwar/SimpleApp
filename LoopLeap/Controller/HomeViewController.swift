//
//  HomeViewController.swift
//  LoopLea0p
//
//  Created by IOS3 on 04/10/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit
import AssetsPickerViewController
import Photos
import Alamofire
import PopupDialog
import CoreServices
import MobileCoreServices
import AVFoundation
import AVKit
import MediaPlayer


class HomeViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIDocumentPickerDelegate{
    
    @IBOutlet weak var topViw: UIView!
    @IBOutlet weak var scrollViw: UIScrollView!
    @IBOutlet var viewCollection: [UIView]!
     var myPickerController = UIImagePickerController()
    var index = Int()
    var assets = [PHAsset]()
    var urlsAarray = [URL]()

    let videoFileName = "/video.mp4"
    var audioPlayer: AVAudioPlayer?
    var moviePlayer: MPMoviePlayerController!
    var recordedData: Data?
    var videoURL : URL?


    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
        print("Home Screen")
       
        
        
        // Do any additional setup after loading the view.
    }
    
    func SetUI()  {
        self.navigationController?.isNavigationBarHidden = true
        for viw in viewCollection {
            viw.layer.cornerRadius = 5.0
            viw.layer.masksToBounds = true
        }
//        scrollViw.contentSize =  CGSize(width:UIScreen.main.bounds.size.width, height: 900)
//        self.topViw.translatesAutoresizingMaskIntoConstraints = true
//        self.topViw.frame = CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height: 900)
    }

//    override func viewWillAppear(_ animated: Bool) {
//
//        showPopups()
//    }

    
  
    //MARK:-
    //MARK:- ImagePicker Delegate
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.mediaTypes = [kUTTypeImage] as [String]
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

    

        let mediaType1 = info[UIImagePickerControllerMediaType] as? String

            if mediaType1 == (kUTTypeMovie as String)
            {
                videoURL = info[UIImagePickerControllerMediaURL] as? URL
                UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoURL!.path)


            // Handle a movie capture
            UISaveVideoAtPathToSavedPhotosAlbum(
                videoURL!.path,
                self,
                #selector(video(_:didFinishSavingWithError:contextInfo:)),
                nil)
             print(videoURL!)
//             self.dismiss(animated: false)
//             {
                  self.uplaodVideo()

             //}
            }



        else
        {

        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.dismiss(animated: false) {
            let vc:PreviewController = self.storyboard?.instantiateViewController(withIdentifier:"PreviewController") as! PreviewController
            vc.selectedImg = image
            self.present(vc, animated: true, completion:nil)
        }
    }
        
    }


    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        //        let title = (error == nil) ? "Success" : "Error"
        //        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        //
        //        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        //        present(alert, animated: true, completion: nil)

    }

    
    
    //MARK:-
    //MARK:- IBAction Methods
    
    
    @IBAction func logoutAction(_ sender: Any) {
        let alert = UIAlertController(title:"Logout", message:"Are you sure you want to logout?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title:"OK", style: .default) { (action) in
            
            self.LogoutApi()
//            UserDefaults.standard.set("logout", forKey:DefaultsIdentifier.login)
//            UserDefaults.standard.synchronize()
//
//            let appdelegate = UIApplication.shared.delegate as! AppDelegate
//            let vc:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            let nav = UINavigationController(rootViewController: vc)
//            appdelegate.window?.rootViewController = nav
        }
        let cancelAction = UIAlertAction(title:"Cancel", style:.cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }


    func LogoutApi()
    {

        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]


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
                            if response != nil {
                            let alert = UIAlertController(title: "", message: response.result.error! as! String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            }
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
                         let status = json["status"] as? NSNumber
                        guard status == 1 else{
                            return

                        }


                        UserDefaults.standard.set("logout", forKey:DefaultsIdentifier.login)
                        UserDefaults.standard.synchronize()

                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                        let vc:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        let nav = UINavigationController(rootViewController: vc)
                        appdelegate.window?.rootViewController = nav

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
    
    
    @IBAction func uploadPhotoAction(_ sender: Any) {
       
      
        let alertController = UIAlertController(title:"", message:"", preferredStyle: .actionSheet)
        let cameraAction =  UIAlertAction(title:"Camera", style:.default) { (action) in
        self.openCamera()
        }
        let galleryAction = UIAlertAction(title:"Gallery", style:.default) { (action) in
            self.photoLibrary()
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func recordAudioAction(_ sender: Any) {
        
        let vc:RecorderViewController = self.storyboard?.instantiateViewController(withIdentifier:"RecorderViewController") as! RecorderViewController
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func recordVideoAction(_ sender: Any)
    {

        // 1 Check if project runs on a device with camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            // 2 Present UIImagePickerController to take video
            myPickerController.sourceType = .camera
            myPickerController.mediaTypes = [kUTTypeMovie as String]
            myPickerController.delegate = self

            present(myPickerController, animated: true, completion: nil)
        }
        else {
            print("Camera is not available")
        }

    }
    
    
    @IBAction func transferFileAction(_ sender: Any) {


        let vc:UploadFileViewController = self.storyboard?.instantiateViewController(withIdentifier:"UploadFileViewController") as! UploadFileViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let alertController = UIAlertController(title:"", message:"", preferredStyle: .actionSheet)
//        let cameraAction =  UIAlertAction(title:"Photos And Videos", style:.default) { (action) in
//            let picker = AssetsPickerViewController()
//            picker.pickerDelegate = self
//            self.present(picker, animated: true, completion: nil)
//        }
//        let browseAction = UIAlertAction(title:"Browse", style:.default) { (action) in
//
//
//            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeWaveformAudio) , String(kUTTypeAudio), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
//            documentPicker.allowsMultipleSelection = true
//            documentPicker.delegate = self
//            documentPicker.modalPresentationStyle = .formSheet
//            self.present(documentPicker, animated: true, completion: nil)
//
//
//        }
//        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cameraAction)
//        alertController.addAction(browseAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func audioTrailAction(_ sender: Any) {
        
        let vc:UploadedFilesViewController = self.storyboard?.instantiateViewController(withIdentifier:"UploadedFilesViewController") as! UploadedFilesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func allNotificationsAction(_ sender: Any)
    {
//        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TellAboutYourselfViewController") as! TellAboutYourselfViewController
//        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//
//        tabBarController?.present(popOverVC, animated: true)
//
//
//
//
//
//        let alertVC :TellAboutYourselfPopup = (self.storyboard?.instantiateViewController(withIdentifier: "TellAboutYourselfPopup") as? TellAboutYourselfPopup)!
//
//        let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
//        , tapGestureDismissal: false) {
//            let overlayAppearance = PopupDialogOverlayView.appearance()
//            overlayAppearance.blurRadius  = 30
//            overlayAppearance.blurEnabled = true
//            overlayAppearance.liveBlur    = false
//            overlayAppearance.opacity     = 0.4
//        }
//
//        alertVC.noAction = {
//
//                        popup.dismiss({
//
//
//                        })
//                    }
//
//                    alertVC.yesAcion = {
//
//                        popup.dismiss({
//
//                            let vc:TellAboutYourselfViewController = self.storyboard?.instantiateViewController(withIdentifier:"TellAboutYourselfViewController") as! TellAboutYourselfViewController
//                            self.navigationController?.pushViewController(vc, animated: true)
//
//
//                        })
//                    }
//
//        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)


//                let vc:AnsweredQuestionsListViewController = self.storyboard?.instantiateViewController(withIdentifier:"AnsweredQuestionsListViewController") as! AnsweredQuestionsListViewController
//                self.navigationController?.pushViewController(vc, animated: true)

        let vc:AllNotificationsViewController = self.storyboard?.instantiateViewController(withIdentifier:"AllNotificationsViewController") as! AllNotificationsViewController
                        self.navigationController?.pushViewController(vc, animated: true)

//        let vc:AnsweredQuestionsListViewController = self.storyboard?.instantiateViewController(withIdentifier:"AnsweredQuestionsListViewController") as! AnsweredQuestionsListViewController
//        self.navigationController?.pushViewController(vc, animated: true)






        
    }
    
    @IBAction func timelineHistoryAction(_ sender: Any)
    {
//         let alertVC :QuestionnairePopup = (self.storyboard?.instantiateViewController(withIdentifier: "QuestionnairePopup") as? QuestionnairePopup)!
//
//       let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
//        , tapGestureDismissal: false) {
//            let overlayAppearance = PopupDialogOverlayView.appearance()
//            overlayAppearance.blurRadius  = 30
//            overlayAppearance.blurEnabled = true
//           overlayAppearance.liveBlur    = false
//            overlayAppearance.opacity     = 0.4
//       }
//
//        alertVC.noAction = {
//
//            popup.dismiss({
//
//
//           })
//       }
//
//        alertVC.yesAcion = {
//
//           popup.dismiss({
//
//                let vc:NumberOfQuestionsViewController = self.storyboard?.instantiateViewController(withIdentifier:"NumberOfQuestionsViewController") as! NumberOfQuestionsViewController
//               self.navigationController?.pushViewController(vc, animated: true)
//
//
//            })
//        }
//
//        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)

        let vc:TimeLineHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier:"TimeLineHistoryViewController") as! TimeLineHistoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
//
//                let vc:AnsweredQuestionsListViewController = self.storyboard?.instantiateViewController(withIdentifier:"AnsweredQuestionsListViewController") as! AnsweredQuestionsListViewController
//                self.navigationController?.pushViewController(vc, animated: true)


        
    }




    //MARK:-
    //MARK:- Api Methods
    
    func sendData()
    {
        
        
        if self.assets.count > 0{
        
        if self.index < assets.count {
        let asset = self.assets[self.index]
        if ProjectManager.sharedInstance.isInternetAvailable() {
            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]
            
            
            let requestImageOption = PHImageRequestOptions()
            requestImageOption.resizeMode = PHImageRequestOptionsResizeMode.exact
            requestImageOption.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            requestImageOption.isNetworkAccessAllowed = true
            // this one is key
       
        let url = baseURL + ApiMethods.uploadFileAPI
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let imgParam = "files"
        var fileSize =  Int()
       let manager = PHImageManager.default()
            
        if asset.mediaType == .image {
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode:PHImageContentMode.default, options: requestImageOption) { image , dict in
        fileSize = UIImageJPEGRepresentation(image!, 1.0)!.count / 1024
            let  params = ["file_date":  dateFormatter.string(from:Date()) as String , "file_size": String(fileSize), "tags":""]
        print(url , params)
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(image!, 1.0)!, withName: imgParam, fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
                for (key, value) in params {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to:url, headers:headers)
            { (result) in
                
                
                switch result {
                    
                    
                    
                case .success(let upload, _, _):
                    if self.assets.count == 1 {
                    upload.uploadProgress(closure: { (progress) in
                        
                           NotificationCenter.default.post(name:.uploadProgress, object:progress )
                        
                    })
                    }
                        upload.responseJSON { response in
                           
                            self.index = self.index + 1
                            let obj = ImageObject()
                            obj.TotalImages = self.assets.count
                            obj.CurrentImageNo = self.index
                            if self.assets.count > 1 {
                            NotificationCenter.default.post(name:.uploadMultipleImages, object:obj )
                            }
                           
                            self.sendData( )
                            if response.result.isFailure {
                                DispatchQueue.main.async {
                                   
//                                    ProjectManager.sharedInstance.showServerError(viewController:self)
                                }
                            }
                            else {
                               print("cancel Request")
                                print(response.result.value)
                            }
                            
                            //print response.result
                        }
                        
                case .failure(let _):
                    
                    print("cancel Request")
                    break
                }
            }
            }
            
            }


        else {
           
            let options = PHVideoRequestOptions()
            options.version = .original
            options.deliveryMode = .automatic
            options.isNetworkAccessAllowed = true
            
            manager.requestAVAsset(forVideo: asset, options: options) { (asset, audiomix, dict) in
                if let avassetURL = asset as? AVURLAsset {
                    guard let videoData = try? Data(contentsOf: avassetURL.url) else {
                        return
                    }
                    
                
                    fileSize = videoData.count / 1024
                     let  params = ["file_date":  dateFormatter.string(from:Date()) as String , "file_size": String(fileSize), "tags":""]
                    print(url , params)
                    
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                        multipartFormData.append(videoData, withName: imgParam, fileName: "\(Date().ticks).mp4", mimeType: "video/mp4")
                        for (key, value) in params {
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                        }
                    }, to:url, headers:headers)
                    { (result) in
                        
                        
                        switch result {
                            
                            
                            
                        case .success(let upload, _, _):
                            if self.assets.count == 1 {
                                upload.uploadProgress(closure: { (progress) in
                                    
                                    NotificationCenter.default.post(name:.uploadProgress, object:progress )
                                    
                                })
                            }
                            upload.responseJSON { response in
                                
                                self.index = self.index + 1
                                let obj = ImageObject()
                                obj.TotalImages = self.assets.count
                                obj.CurrentImageNo = self.index
                                if self.assets.count  > 1 {
                                NotificationCenter.default.post(name:.uploadMultipleImages, object:obj )
                                }
                                self.sendData( )
                                if response.result.isFailure {
                                     print("cancel Request")
                                }
                                else {
                                    
                                    print(response.result.value)
                                }
                                
                                //print response.result
                            }
                            
                        case .failure(let _):
                            DispatchQueue.main.async {
                                
                            }
                            
                            break
                        }
                    }
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
        else {
            if self.index < urlsAarray.count {
                let mediaURL = self.urlsAarray[self.index]
                if ProjectManager.sharedInstance.isInternetAvailable() {

                    if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
                    {
                        let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                        let headers = [
                            "Authorization": token_type + accessToken,
                            "Accept": "application/json"
                        ]
                  
               
                    let url = baseURL + ApiMethods.uploadFileAPI
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let imgParam = "files"
                    var fileSize =  Int()
                    do {
                    let attr: NSDictionary = try FileManager.default.attributesOfItem(atPath:mediaURL.path) as NSDictionary
                    print(attr.fileSize())
                    
                        fileSize = Int(attr.fileSize()/1024)
                        let  params = ["file_date":  dateFormatter.string(from:Date()) as String , "file_size": String(fileSize), "tags":""]
                            print(url , params)
                        
                        let data = try Data(contentsOf:mediaURL )
                        
                            Alamofire.upload(multipartFormData: { (multipartFormData) in
                                multipartFormData.append(data, withName: imgParam, fileName: "\(Date().ticks).\(MimeType(url:mediaURL).ext!)", mimeType: "\(MimeType(url:mediaURL).value)")
                                for (key, value) in params {
                                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                                }
                            }, to:url, headers:headers)
                            { (result) in
                                
                                
                                switch result {
                                    
                                    
                                    
                                case .success(let upload, _, _):
                                    if self.urlsAarray.count == 1 {
                                        upload.uploadProgress(closure: { (progress) in
                                            
                                            NotificationCenter.default.post(name:.uploadProgress, object:progress )
                                            
                                        })
                                    }
                                    upload.responseJSON { response in
                                        
                                        self.index = self.index + 1
                                        let obj = ImageObject()
                                        obj.TotalImages = self.urlsAarray.count
                                        obj.CurrentImageNo = self.index
                                        if self.urlsAarray.count > 1 {
                                            NotificationCenter.default.post(name:.uploadMultipleImages, object:obj )
                                        }
                                        
                                        self.sendData( )
                                        if response.result.isFailure {
                                            DispatchQueue.main.async {
                                                
                                                //                                    ProjectManager.sharedInstance.showServerError(viewController:self)
                                            }
                                        }
                                        else {
                                            print("cancel Request")
                                            print(response.result.value)
                                        }
                                        
                                        //print response.result
                                    }
                                    
                                case .failure(let _):
                                    
                                    print("cancel Request")
                                    break
                                }
                            }
                        }
                    catch {
                        
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

    func showPopups()
    {

        if ProjectManager.sharedInstance.isInternetAvailable()
        {
            //ProjectManager.sharedInstance.showLoader()
            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]
                //let parameters = ["user_id": userId]

                Alamofire.request(baseURL + ApiMethods.startquestionnaire, method: .post,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
                    .responseJSON { response in

                        //ProjectManager.sharedInstance.stopLoader()

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

                        let status = json["status"] as? Bool
                        if status == true
                        {
                          
                            DispatchQueue.main.async {
                                let alertVC :QuestionnairePopup = (self.storyboard?.instantiateViewController(withIdentifier: "QuestionnairePopup") as? QuestionnairePopup)!
                                
                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                , tapGestureDismissal: false, panGestureDismissal: false) {
                                    let overlayAppearance = PopupDialogOverlayView.appearance()
                                    overlayAppearance.blurRadius  = 30
                                    overlayAppearance.blurEnabled = true
                                    overlayAppearance.liveBlur    = false
                                    overlayAppearance.opacity     = 0.4
                                }
                                
                                alertVC.noAction = {
                                    
                                    popup.dismiss({
                                        
                                        
                                    })
                                }
                                
                                alertVC.yesAcion = {
                                    
                                    popup.dismiss({
                                        
                                        let vc:NumberOfQuestionsViewController = self.storyboard?.instantiateViewController(withIdentifier:"NumberOfQuestionsViewController") as! NumberOfQuestionsViewController
                                        self.navigationController?.pushViewController(vc, animated: true)
                                        
                                        
                                    })
                                }
                                
                                        self.present(popup, animated: true, completion: nil)
                                
                               
                                
                                
                            }
              
                        }

                        else
                        {
                           let statusCode = json["statusCode"] as? Int
                            if statusCode == 1
                            {

                                let alertVC :TellAboutYourselfPopup = (self.storyboard?.instantiateViewController(withIdentifier: "TellAboutYourselfPopup") as? TellAboutYourselfPopup)!


                                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                , tapGestureDismissal: false, panGestureDismissal: false) {
                                    let overlayAppearance = PopupDialogOverlayView.appearance()
                                    overlayAppearance.blurRadius  = 30
                                    overlayAppearance.blurEnabled = true
                                    overlayAppearance.liveBlur    = false
                                    overlayAppearance.opacity     = 0.4
                                }

                                alertVC.noAction = {

                                    popup.dismiss({


                                    })
                                }

                                alertVC.yesAcion = {

                                    popup.dismiss({

                                        let vc:TellAboutYourselfViewController = self.storyboard?.instantiateViewController(withIdentifier:"TellAboutYourselfViewController") as! TellAboutYourselfViewController
                                        self.navigationController?.pushViewController(vc, animated: true)


                                    })
                                }

                                UIApplication.topViewController()?.present(popup, animated: true, completion: nil)

                            }

                            else if statusCode == 4
                            {
                                 self.LogoutApi()
                                 let alert = UIAlertController(title: "", message:"Your account is deactivated" , preferredStyle: .alert)
                                 alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                                 self.present(alert, animated: true, completion: nil)

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


    func uplaodVideo()
    {


        let url = baseURL + ApiMethods.uploadFileAPI

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let imgParam = "files"
        do {

        guard self.videoURL != nil  else {return}
        self.recordedData = try Data(contentsOf: self.videoURL!)

        let fileSize = self.recordedData!.count / 1024
        let  params = ["file_date":  dateFormatter.string(from:Date()) as String , "file_size": String(fileSize) , "tags":""]
        print(url , params)
        if ProjectManager.sharedInstance.isInternetAvailable() {
            ProjectManager.sharedInstance.showLoader()

            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]

                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(self.recordedData ?? Data(), withName: imgParam, fileName: "\(Date().ticks).mp4", mimeType: "video/mp4")
                    for (key, value) in params {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }, to:url, headers:headers)
                { (result) in
                    ProjectManager.sharedInstance.stopLoader()

                    switch result {



                    case .success(let upload, _, _):


                        self.dismiss(animated: false, completion: {

                            self.uploadPopupVideo()
                            upload.uploadProgress(closure: { (progress) in

                                NotificationCenter.default.post(name:.uploadProgress, object:progress )


                                print(progress.fractionCompleted)
                                //Print progress
                            })


                            upload.responseJSON { response in
                                DispatchQueue.main.async {
                                    ProjectManager.sharedInstance.stopLoader()
                                    self.dismiss(animated: true, completion: nil)
                                }

                                if response.result.isFailure {
                                    DispatchQueue.main.async {
                                     //   ProjectManager.sharedInstance.showServerError(viewController:self)
                                    }
                                }
                                else {
                                    print(response.result.value)
                                }

                                //print response.result
                            }




                        })





                    case .failure(let _):
                        DispatchQueue.main.async {
                            ProjectManager.sharedInstance.showServerError(viewController:self)
                            ProjectManager.sharedInstance.stopLoader()
                        }

                        break
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

        catch
        {
            
        }

}

    //MARK:-
    //MARK:- Methods
    
    func uploadPopup() {
        
        let alertVC :UploadingPopUp = (self.storyboard?.instantiateViewController(withIdentifier: "UploadingPopUp") as? UploadingPopUp)!
        alertVC.multipleImage = true
        let obj = ImageObject()
        if self.assets.count > 0 {
        obj.TotalImages = self.assets.count
        }
        else {
           obj.TotalImages = self.urlsAarray.count
        }
        alertVC.obj =  obj
        let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
        , tapGestureDismissal: false, panGestureDismissal: false) {
            let overlayAppearance = PopupDialogOverlayView.appearance()
            overlayAppearance.blurRadius  = 30
            overlayAppearance.blurEnabled = true
            overlayAppearance.liveBlur    = false
            overlayAppearance.opacity     = 0.4
        }
        
        alertVC.cancelBtnClick = {
            let sessionManager = Alamofire.SessionManager.default
            
            sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in dataTasks.forEach {
                $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() } }
            if self.assets.count == 1 {
                popup.dismiss(animated: true, completion: {
                    
                })
                
            }
            
         
           
        }
        
        alertVC.cancelAllBtnClick = {
            
            popup.dismiss(animated:true , completion: {
                if self.assets.count > 0 {
                     self.index = self.assets.count
                }
                else {
                     self.index = self.urlsAarray.count
                }
               
                let sessionManager = Alamofire.SessionManager.default
                
                sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in dataTasks.forEach {
                    $0.cancel() }
                    uploadTasks.forEach { $0.cancel() }
                    downloadTasks.forEach { $0.cancel() } }
            })
        }
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
    }


    func uploadPopupVideo()
    {

        let alertVC :UploadingPopUp = (self.storyboard?.instantiateViewController(withIdentifier: "UploadingPopUp") as? UploadingPopUp)!
        let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
        , tapGestureDismissal: false, panGestureDismissal: false) {
            let overlayAppearance = PopupDialogOverlayView.appearance()
            overlayAppearance.blurRadius  = 30
            overlayAppearance.blurEnabled = true
            overlayAppearance.liveBlur    = false
            overlayAppearance.opacity     = 0.4
        }

        alertVC.cancelBtnClick = {

            popup.dismiss(animated:true , completion: {
                let sessionManager = Alamofire.SessionManager.default

                sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in dataTasks.forEach {
                    $0.cancel() }
                    uploadTasks.forEach { $0.cancel() }
                    downloadTasks.forEach { $0.cancel() } }
            })

        }

        alertVC.cancelAllBtnClick = {

            popup.dismiss(animated:true , completion: {
                let sessionManager = Alamofire.SessionManager.default
                sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in dataTasks.forEach {
                    $0.cancel() }
                    uploadTasks.forEach { $0.cancel() }
                    downloadTasks.forEach { $0.cancel() } }
            })
        }
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK:-
     // MARK:- UIDocumentPickerViewController Delegates
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        self.index = 0
        self.assets.removeAll()
        self.urlsAarray.removeAll()
        var getSizeChk = Bool()
        if urls.count > 0 {
            
            
            for i in urls {
                
                do {
                    let attr: NSDictionary = try FileManager.default.attributesOfItem(atPath:i.path) as NSDictionary
                    print(attr.fileSize())
                    let sizeInMb:Float = (Float(attr.fileSize())/Float(1024))/Float(1024)
                    if sizeInMb < 20 || sizeInMb == 20 {
                        self.urlsAarray.append(i)
                    }
                    else {
                        getSizeChk = true
                    }
                    
                } catch {
                    print(error)
                }
            }
            if getSizeChk {
                
                let alertController = UIAlertController(title:"Message", message:"Some of the files size is greater than 20 MB", preferredStyle: .alert)
                let okAction =  UIAlertAction(title:"OK", style:.default) { (action) in
                    
                    if self.urlsAarray.count > 0
                    {
                        self.uploadPopup()
                        self.sendData()
                   
                        
                    }
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
                
            else {
                if self.urlsAarray.count > 0
                {
                    
                        self.uploadPopup()
                        self.sendData()
                    
                }
            }
            
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Cancel")
    }
}
extension HomeViewController: AssetsPickerViewControllerDelegate {
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        
    }
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        
    }

    func assetsPicker(controller: AssetsPickerViewController, didDismissByCancelling byCancel: Bool) {
        print("dismiss \(byCancel)")
        if !byCancel {
            let assets = self.assets
            self.urlsAarray.removeAll()
            self.assets.removeAll()
            var getSizeChk = Bool()
            for i in assets {
                
                let resources = PHAssetResource.assetResources(for: i) // your PHAsset
                
                var sizeOnDisk: Int64? = 0
                
                if let resource = resources.first {
                    let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                    sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
                    print(sizeOnDisk!)
                    let sizeInMb:Float = (Float(sizeOnDisk!)/Float(1024))/Float(1024)
                    if sizeInMb < 20 || sizeInMb == 20 {
                        self.assets.append(i)
                    }
                    else {
                        getSizeChk = true
                    }
                    print(sizeInMb)
                }
            }
            
            if getSizeChk {
                
                let alertController = UIAlertController(title:"Message", message:"Some of the files size is greater than 20 MB", preferredStyle: .alert)
                let okAction =  UIAlertAction(title:"OK", style:.default) { (action) in
                   
                   if self.assets.count > 0
                    {
                        self.uploadPopup()
                        self.sendData()
                    }
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            
            else {
               if self.assets.count > 0
                {
                self.uploadPopup()
                self.sendData()
                }
            }
           //  self.uploadPopup()
            //  self.sendData()
        }
        
    }
    
    func dismissTORootView()  {
        
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        
    }
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        // do your job with selected assets
      self.index = 0
      self.assets = assets
      print(assets.count)
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
        
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {}
}



class ImageObject: NSObject {
    var TotalImages = Int()
    var CurrentImageNo = Int()
}
