//
//  SelectedNotificationViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 08/01/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import PopupDialog
import AssetsPickerViewController
import Photos
import SystemConfiguration
import PopupDialog
import AVFoundation
import AVKit
import MediaPlayer


protocol RefreshListDataDelegate {

    func listDataRefresh()
}

class SelectedNotificationViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource, AudioDelegate
{

    func didselectAutoCompleteOption() {
        print("vhjxg")
    }

    func didFindAudioFile(found: URL) {
        print(found)
        audioUrl = found
        self.previewView.isHidden = false
        self.clickToSeePreviewBtn.setTitle("Audio Recorded, Click to listen", for: .normal)
        self.previewLabel.text = "Note: Re-record to change current recorded message "
        updateUI()


    }
    
    @IBOutlet weak var notificationTitl: UILabel!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var enterTagTextField: MultiAutoCompleteTextField!
    @IBOutlet weak var selectDirectroyTextField: UITextField!

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var clickToSeePreviewBtn: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var audioIconImgViw: UIImageView!
    @IBOutlet weak var videoIconImgViw: UIImageView!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak internal var recordViw: UIView!
    @IBOutlet weak var recordIcon: UIImageView!
    @IBOutlet weak var recordViwLbl: UILabel!
    
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var storageAlertView: UIView!
    @IBOutlet weak var storageLabel: UILabel!
    @IBOutlet weak var showPlanBtn: UIButton!



    var delegate : RefreshListDataDelegate?
    var tagsArray = [String]()
    var pickerController = UIImagePickerController()
    let videoFileName = "/video.mp4"
    var audioPlayer: AVAudioPlayer?
    var moviePlayer:MPMoviePlayerController!
    var recordedData: Data?
    var videoURL : URL?
    var valueSent: Bool = true
    var audioUrl: URL?
    var params = [String : Any]()
    var audioBtnValue = Bool()
    var videoBtnValue = Bool()
    var obj = String()
    var notificationTitle = String()
    var directoryArray = [KeyHolderObject]()
    var storageObj = GetPlanListObject()




    override func viewDidLoad()
    {
        super.viewDidLoad()

        selectDirectroyTextField.delegate = self
        
        recordViw.layer.cornerRadius = 5
        recordViw.clipsToBounds = true
        
        cancelBtn.layer.cornerRadius = 22
        cancelBtn.clipsToBounds = true

        saveBtn.layer.cornerRadius = 20
        saveBtn.clipsToBounds = true

        audioBtn.layer.borderColor = UIColor.red.cgColor
        audioBtn.layer.borderWidth = 1

        videoBtn.layer.borderColor = UIColor.black.cgColor
        videoBtn.layer.borderWidth = 1

         notificationTitl.text = notificationTitle

        enterTagTextField.delegate = self

        enterTagTextField.leftViewMode = .always
        let viw =  UIView(frame: CGRect(x:0, y:0,width: 35, height: 60))
        let tagIcon = UIImageView(frame: CGRect(x:10, y:22, width: 15, height: 15))
        tagIcon.image = UIImage(named: "enterTag-Icon")
        viw.addSubview(tagIcon)


        enterTagTextField.leftView = viw //UIImageView(image: UIImage(named: "enterTag-Icon"))

        enterTagTextField.autoCompleteWordTokenizers = [","]
        
        selectDirectroyTextField.leftViewMode = .always
        let viw1 =  UIView(frame: CGRect(x:0, y:0,width: 35, height: 60))
        let tagIcon1 = UIImageView(frame: CGRect(x:10, y:22, width: 15, height: 15))
        tagIcon1.image = UIImage(named: "selectDirectry-Icon")
        viw1.addSubview(tagIcon1)
        
        
        selectDirectroyTextField.leftView = viw1
        
        showPicker()
        getDirectoriesList()


        // Do any additional setup after loading the view.
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)

        //        guard
        //            let mediaType = info[UIImagePickerControllerMediaType] as? String,
        //            mediaType == (kUTTypeMovie as String),
        //           let url = info[UIImagePickerControllerMediaURL] as? URL,
        //            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
        //            else {
        //                return
        //        }

        let mediaType1 = info[UIImagePickerControllerMediaType] as? String
        if mediaType1 == (kUTTypeMovie as String)
        {
            videoURL = info[UIImagePickerControllerMediaURL] as? URL
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoURL!.path)
        }

        // Handle a movie capture
        UISaveVideoAtPathToSavedPhotosAlbum(
            videoURL!.path,
            self,
            #selector(video(_:didFinishSavingWithError:contextInfo:)),
            nil)

        //        // Handle a movie capture
        //        UISaveVideoAtPathToSavedPhotosAlbum(
        //            url.path,
        //            self,
        //            #selector(video(_:didFinishSavingWithError:contextInfo:)),
        //            nil)
    }

    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
//        let title = (error == nil) ? "Success" : "Error"
//        let message = (error == nil) ? "Video was saved" : "Video failed to save"
//
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
        self.previewView.isHidden = false
        self.clickToSeePreviewBtn.setTitle("Video Recorded, Click to see the preview", for: .normal)
        self.previewLabel.text = "Note: Re-record to change current recorded video "
        updateUI()


    }
    
    
    //MARK:-
    //MARK:- Custom methods
    
    @objc func showPicker()
    {
        
        
        selectDirectroyTextField.inputView = pickerInputView
        selectDirectroyTextField.inputAccessoryView = nil
        
        
    }
    
    //MARK:-
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectDirectroyTextField {
            showPicker()
            print("You edit myTextField")
        }
            
        
        
        
    }
    
    
    //MARK:-
    //MARK:- PickerView DataSources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
       
            return directoryArray.count
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
            return directoryArray[row].dir_name
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        //        chooseDirTextField.text = pickerArray[row]
        //        dircollectionArray.append(pickerArray[row])
        //        directoryCollectionView.reloadData()
        
        
    }


    //MARK:-
    //MARK:- IBAction Methods
    @IBAction func backButtonAction(_ sender: Any)
    {
        
        self.dismiss(animated: true, completion: nil)
       // self.navigationController?.popViewController(animated: true)
    }

    @IBAction func audioButtonAction(_ sender: Any)
    {
        
        self.previewView.isHidden = true
        audioBtnValue = true
        videoBtnValue = false
        audioIconImgViw.image = #imageLiteral(resourceName: "audio-Icon")
        audioIconImgViw.tintColor = #colorLiteral(red: 0.768627451, green: 0.146728605, blue: 0.1671561897, alpha: 1)
        audioBtn.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.146728605, blue: 0.1671561897, alpha: 1)
        audioBtn.setTitleColor(#colorLiteral(red: 0.768627451, green: 0.146728605, blue: 0.1671561897, alpha: 1), for: .normal)
        recordViwLbl.text = "Record Audio"
        videoIconImgViw.image = #imageLiteral(resourceName: "video-Icon")
        videoIconImgViw.tintColor = #colorLiteral(red: 0.2550600469, green: 0.2552990317, blue: 0.2506460845, alpha: 1)
        videoBtn.layer.borderColor = #colorLiteral(red: 0.2550600469, green: 0.2552990317, blue: 0.2506460845, alpha: 1)
        videoBtn.setTitleColor(#colorLiteral(red: 0.2550600469, green: 0.2552990317, blue: 0.2506460845, alpha: 1) , for: .normal)
        recordIcon.image = #imageLiteral(resourceName: "audioLight-Icon")
        recordIcon.tintColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        let vc:RecorderViewController = self.storyboard?.instantiateViewController(withIdentifier:"RecorderViewController") as! RecorderViewController
        vc.recievedBool = valueSent
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)



    }

    @IBAction func videoButtonAction(_ sender: Any)
    {
        self.previewView.isHidden = true
        videoBtnValue = true
        audioBtnValue = false
        audioIconImgViw.image = #imageLiteral(resourceName: "audio-Icon")
        audioIconImgViw.tintColor = #colorLiteral(red: 0.2550600469, green: 0.2552990317, blue: 0.2506460845, alpha: 1)
        audioBtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        audioBtn.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        videoIconImgViw.image = #imageLiteral(resourceName: "video-Icon")
        videoIconImgViw.tintColor = #colorLiteral(red: 0.7670186162, green: 0.146728605, blue: 0.1671561897, alpha: 1)
        videoBtn.layer.borderColor = #colorLiteral(red: 0.7670186162, green: 0.146728605, blue: 0.1671561897, alpha: 1)
        videoBtn.setTitleColor(#colorLiteral(red: 0.7670186162, green: 0.146728605, blue: 0.1671561897, alpha: 1), for: .normal)
        recordViwLbl.text = "Record Video"
        recordIcon.image = #imageLiteral(resourceName: "video-Icon")
        recordIcon.tintColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        // 1 Check if project runs on a device with camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            // 2 Present UIImagePickerController to take video
            pickerController.sourceType = .camera
            pickerController.mediaTypes = [kUTTypeMovie as String]
            pickerController.delegate = self

            present(pickerController, animated: true, completion: nil)
        }
        else {
            print("Camera is not available")
        }

    }


    @IBAction func chooseDataButtonAction(_ sender: Any)
    {

        print("abcd")
    }

    @IBAction func enterTagButtonAction(_ sender: Any)
    {

        print("abcde")
    }

    @IBAction func cancelButtonAction(_ sender: Any)
    {

        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func saveButtonAction(_ sender: Any)
    {
        let title = (titleTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let dir = (selectDirectroyTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if title.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Please enter title", vc: self)
        }
            
        else if title.count < 3  {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Please enter atleast 3 characters title", vc: self)
        }
        else if title.count > 50  {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Please enter title", vc: self)
        }
 
        else  if dir.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Please choose directory", vc: self)
        }
            
        else if self.audioUrl == nil && self.videoURL == nil {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Please record Audio/Video first", vc: self)
        }
        
        else {
        saveDailyUpdate()
        }
    }

    @IBAction func clickToSeePreviewButtonAction(_ sender: Any)
    {
        if audioBtnValue == true
        {
            let alertVC :PreviewAudioVideoPopup = (self.storyboard?.instantiateViewController(withIdentifier: "PreviewAudioVideoPopup") as? PreviewAudioVideoPopup)!

            alertVC.receivedUrl = self.audioUrl

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

            UIApplication.topViewController()?.present(popup, animated: true, completion: nil)

        }

        else if videoBtnValue == true
        {
            let url:NSURL = self.videoURL! as NSURL
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url:url as URL)
            self.present(vc, animated: true) {
                vc.player?.play()
            }
        }

    }
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {

            let row = pickerView.selectedRow(inComponent: 0)
            
            selectDirectroyTextField.text = directoryArray[row].dir_name
            
      
        //dismiss date picker dialog
        self.view.endEditing(true)
        
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
    //MARK:- Methods

//    func textFieldDidBeginEditing(_ textField: UITextField)
//    {
//        if textField == chooseDateTextField {
//
//
//        }
//    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = enterTagTextField.text
        {
            getTags()
        }
        return true
    }

    func updateUI()
    {
        self.audioBtn.translatesAutoresizingMaskIntoConstraints = true
        self.videoBtn.translatesAutoresizingMaskIntoConstraints = true
        self.cancelBtn.translatesAutoresizingMaskIntoConstraints = true
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
        self.previewView.translatesAutoresizingMaskIntoConstraints = true

         previewView.frame = CGRect(x: previewView.frame.origin.x , y:audioBtn.frame.origin.y + audioBtn.frame.size.height + 20 , width: previewView.frame.size.width, height: previewView.frame.size.height)

        cancelBtn.frame = CGRect(x: cancelBtn.frame.origin.x , y:previewView.frame.origin.y + previewView.frame.size.height + 20, width:
            cancelBtn.frame.size.width, height: cancelBtn.frame.size.height)

        saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y:previewView.frame.origin.y + previewView.frame.size.height + 20  , width: saveBtn.frame.size.width, height: saveBtn.frame.size.height)
    }

//    func isInternetAvailable() -> Bool
//    {
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
//                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
//            }
//        }
//
//        var flags = SCNetworkReachabilityFlags()
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//            return false
//        }
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        return (isReachable && !needsConnection)
//    }




    //MARK:-
    //MARK:- Api Methods

    @objc func getTags()
    {

        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]

       // let todoEndpoint: String = "http://dev.loopleap.com/api/tags"
        let parameters:[String : Any] = ["term":"tag"]
// isInternetAvailable()
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
               // ProjectManager.sharedInstance.showLoader()


                Alamofire.request(baseURL + ApiMethods.tags, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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

                        if let data = json["data"] as? [String]
                        {
                            print(data)
                            self.tagsArray.append(contentsOf: data)
                            print(self.tagsArray)
                            self.enterTagTextField.maximumAutoCompleteCount = data.count

                            self.enterTagTextField.autoCompleteStrings?.removeAll()
                            self.enterTagTextField.autoCompleteStrings = data
                            self.enterTagTextField.autoCompleteWordTokenizers = [","]


                            //                     {
                            //                         print("done")
                            //
                            //                    }
                            //
                            //                    else
                            //                     {
                            //                          print("Undone")
                            //                          self.enterTagTextField.autoCompleteStrings = [self.enterTagTextField.text] as? [String]
                            //
                            //                    }

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


    func saveDailyUpdate()
    {
//        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.userID) as! String
//
//        let todoEndpoint: String = "http://dev.loopleap.com/api/savedailyupdate"
       


        do{
            if audioBtnValue
            {

                guard self.audioUrl != nil  else {return}
                self.recordedData = try Data(contentsOf: self.audioUrl!)
            }

            else if videoBtnValue
            {
                guard  self.videoURL != nil  else {return}
                self.recordedData = try Data(contentsOf: self.videoURL!)

            }
            //let parametr = ["user_id":"6","question_id":"4","answer":"", "answer_by":"record"]

            if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
            {
                let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
                let headers = [
                    "Authorization": token_type + accessToken,
                    "Accept": "application/json"
                ]

                // isInternetAvailable()
                if ProjectManager.sharedInstance.isInternetAvailable()
                {



                    if audioBtnValue
                    {
                         let row = pickerView.selectedRow(inComponent: 0)
                        
                        params = ["tags":enterTagTextField.text!, "recording_type":"audio","title_text":titleTextField.text!, "notification_id":obj, "dir_id":directoryArray[row].dir_id]
                        ProjectManager.sharedInstance.showLoader()

                        Alamofire.upload(multipartFormData: { (multipartFormData) in

                            multipartFormData.append(self.recordedData ?? Data(), withName: "video-blob", fileName:  "\(Date().ticks).m4a", mimeType: "audio")
                            for (key, value) in self.params {
                                // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)

                            }
                        }, to:baseURL + ApiMethods.savedailyupdate, headers:headers)
                        { (result) in
                             ProjectManager.sharedInstance.stopLoader()

                            switch result {



                            case .success(let upload, _, _):


                                upload.responseJSON { response in
                                    //                        DispatchQueue.main.async {
                                    //                            ProjectManager.sharedInstance.stopLoader()
                                    //                            self.dismiss(animated: true, completion: nil)
                                    //                        }

                                    if response.result.isFailure {
                                        DispatchQueue.main.async {
                                            ProjectManager.sharedInstance.showServerError(viewController:self)
                                        }
                                    }
                                    else {
                                        print(response.result.value!)
                                        //                                if self.delegate != nil {
                                        //                                    self.delegate?.listDataRefresh()
                                        //                                }
                                        
                                        if let response = response.result.value as? [String: Any] {
                                            
                                            if let status = response["status"] as? NSNumber {
                                                
                                                if status == 1 {
                                                    
                                                    
                                                    let alert = UIAlertController(title: "", message: "Saved Successfully", preferredStyle: .alert)
                                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                                        
                                                        
                                                        // ProjectManager.sharedInstance.uploadsFileAudioVideoDelegate?.refreshDir()
                                                        
                                                        
                                                        self.dismiss(animated: true, completion: nil)
                                                        
                                                        
                                                    }
                                                    alert.addAction(OKAction)
                                                    
                                                    
                                                    
                                                    self.present(alert, animated: true, completion: nil)
                                                    
                                                }
                                                
                                                else {
                                                    
                                                    
                                                    let msg = response["message"] as? String
                                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                                    
                                                    
                                                }
                                            }
                                            
                                        }

                                       // self.navigationController?.popViewController(animated: true)

                                    }

                                    //                                let alert = UIAlertController(title: "", message: "Saved Successfully", preferredStyle: .alert)
                                    //                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                                    //                                self.present(alert, animated: true, completion: nil)                            }

                                    //print response.result
                                }

                            case .failure(let _):
                                DispatchQueue.main.async {
                                    ProjectManager.sharedInstance.showServerError(viewController:self)
                                    ProjectManager.sharedInstance.stopLoader()
                                }

                                break
                            }
                        }

                    }

                    else if videoBtnValue
                    {
                         let row = pickerView.selectedRow(inComponent: 0)
                        
                        params = ["tags":enterTagTextField.text!, "recording_type":"video","title_text":titleTextField.text!, "notification_id":obj, "dir_id":directoryArray[row].dir_id]

                              ProjectManager.sharedInstance.showLoader()

                        Alamofire.upload(multipartFormData: { (multipartFormData) in

                            multipartFormData.append(self.recordedData ?? Data(), withName: "video-blob", fileName: "\(Date().ticks).mp4", mimeType: "video/mp4")
                            for (key, value) in self.params {
                                // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)

                            }
                        }, to:baseURL + ApiMethods.savedailyupdate , headers: headers)
                        { (result) in

                           ProjectManager.sharedInstance.stopLoader()
                            switch result {



                            case .success(let upload, _, _):


                                // self.dismiss(animated: false, completion: {
                                upload.responseJSON { response in
                                    //                        DispatchQueue.main.async {
                                    //                            ProjectManager.sharedInstance.stopLoader()
                                    //                            self.dismiss(animated: true, completion: nil)
                                    //                        }

                                    if response.result.isFailure {
                                        DispatchQueue.main.async {
                                            ProjectManager.sharedInstance.showServerError(viewController:self)
                                        }
                                    }
                                    else {
                                        print(response.result.value!)
                                        //                                    if self.delegate != nil {
                                        //                                        self.delegate?.listDataRefresh()
                                        //                                    }

                                        if let response = response.result.value as? [String: Any] {
                                            
                                            if let status = response["status"] as? NSNumber {
                                                
                                                if status == 1 {
                                                    
                                                    
                                                    let alert = UIAlertController(title: "", message: "Saved Successfully", preferredStyle: .alert)
                                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                                        
                                                        
                                                        // ProjectManager.sharedInstance.uploadsFileAudioVideoDelegate?.refreshDir()
                                                        
                                                        
                                                        self.dismiss(animated: true, completion: nil)
                                                        
                                                        
                                                    }
                                                    alert.addAction(OKAction)
                                                    
                                                    
                                                    
                                                    self.present(alert, animated: true, completion: nil)
                                                    
                                                }
                                                
                                                else {
                                                    
                                                    
                                                    let msg = response["message"] as? String
                                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                                    
                                                    
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                        
                                        
                                      //  self.navigationController?.popViewController(animated: true)

                                    }

                                    //print response.result
                                }

                                //                        })



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
        }
        catch {

        }



    }
    
    func getDirectoriesList() {
        
        
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
                
                
                Alamofire.request(baseURL + ApiMethods.getDirectoriesList, method: .get,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
                    .responseJSON { response in
                        
                         ProjectManager.sharedInstance.stopLoader()
                        self.paymentGeneralApi()
                        
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
                            if let data = json["data"] as? NSArray {
                                
                                if data.count > 0 {
                                    print(data)
                                    
                                    self.selectDirectroyTextField.isEnabled = true
                                    
                                    self.directoryArray = ProjectManager.sharedInstance.GetKeyHolderListObjects(array: data)
                                }
                                    
                                else {
                                    
                                    self.selectDirectroyTextField.isEnabled = false
                                    let msg = json["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                }
                                
                                
                                
                            }
                            else{
                                
                                self.selectDirectroyTextField.isEnabled = false
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                            
                        }
                        else {
                            self.selectDirectroyTextField.isEnabled = false
                            let msg = json["message"] as? String
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                            
                        }
                }
            }
                
            else {
                DispatchQueue.main.async(execute: {
                    
                    //ProjectManager.sharedInstance.stopLoader()
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
    
    
    
    
    
}




/*
 // MARK: - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


