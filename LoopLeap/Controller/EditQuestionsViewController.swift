//
//  EditQuestionsViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 04/01/19.
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
import MediaPlayer


protocol RefreshTableDataDelegate {

   func tableDataRefresh()
}


class EditQuestionsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AudioDelegate
{
    func didFindAudioFile(found: URL) {
        print(found)
        audioUrl = found
        
        do{
            guard self.audioUrl != nil  else {return}
            
            self.recordedData = try Data(contentsOf: self.audioUrl!)
            
        }
        catch {
            
            
        }
        self.previewView.isHidden = false
        self.clickToSeePreviewBtn.setTitle("Audio Recorded, Click to listen", for: .normal)
        self.previewLabel.text = "Note: Re-record to change current recorded message "
        updateUI()


    }

    


    @IBOutlet weak var questionView: UIView!

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerlabel: UILabel!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var audioImage: UIImageView!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var textImage: UIImageView!
    @IBOutlet weak var textAnswerTextView: IQTextView!
    @IBOutlet weak var recordAudioRadioBtn: UIButton!
    @IBOutlet weak var recordVideoRadioBtn: UIButton!
    @IBOutlet weak var writeTextRadioBtn: UIButton!
    @IBOutlet weak var recordAudioBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var clickToSeePreviewBtn: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var previewLabel: UILabel!
    
    @IBOutlet weak var storageAlertView: UIView!
    @IBOutlet weak var storageLabel: UILabel!
       @IBOutlet weak var showPlanBtn: UIButton!


    var parameters = [String:Any]()
    var obj = GetAnswersObject()
    var tag = Int()
    var controller = UIImagePickerController()
    var audioPlayer: AVAudioPlayer?
    var moviePlayer:MPMoviePlayerController!
    let videoFileName = "/video.mp4"
    var valueSent: Bool = true
    var videoURL : URL?
    var audioUrl: URL?
    var recordedData: Data?
    var index = Int()
    var assets = [PHAsset]()
    var delegate : RefreshTableDataDelegate?
    var storageObj = GetPlanListObject()




    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        questionTextView.text = "\(obj.question)"
        paymentGeneralApi()

        // Do any additional setup after loading the view.
    }

    func setUI()
    {
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "splash-bg")!)

        answerView.layer.cornerRadius = 10
        answerView.clipsToBounds = true
        answerView.layer.borderWidth = 0.5
        answerView.layer.borderColor = UIColor.lightGray.cgColor

        textAnswerTextView.layer.cornerRadius = 10
        textAnswerTextView.clipsToBounds = true
        textAnswerTextView.layer.borderWidth = 1
        textAnswerTextView.layer.borderColor = UIColor.lightGray.cgColor
        textAnswerTextView.text = obj.text_answer

        saveBtn.layer.cornerRadius = 20
        saveBtn.clipsToBounds = true
        saveBtn.layer.borderWidth = 1
        saveBtn.layer.borderColor = UIColor.clear.cgColor

        recordAudioBtn.layer.cornerRadius = 20
        recordAudioBtn.clipsToBounds = true
        recordAudioBtn.layer.borderWidth = 1
        recordAudioBtn.layer.borderColor = UIColor.clear.cgColor


        if !obj.text_answer.isEmpty {
            textImageButtonAction(UIButton())
        } else {
            if let ext = MimeType(path:obj.recorded_answer).ext {
                
                if let mimeType = mimeTypes[ext]
                {
                    
                    if mimeType.hasPrefix("audio")
                    {
                        
                        audioImageButtonAction(UIButton())
                    }
                    else  if mimeType.hasPrefix("video") {
                         videoImageButtonAction(UIButton())
                    }
                }
                
            }
        }

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
    //MARK:- IB Actions

    @IBAction func backButtonAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func audioImageButtonAction(_ sender: Any)
    {
        self.view.endEditing(true)
       // self.textAnswerTextView.text = nil
        self.audioUrl = nil
        self.videoURL = nil

        audioImage.image = UIImage(named: "radioFill-btn")
        videoImage.image = UIImage(named: "radio-Btn")
        textImage.image = UIImage(named: "radio-Btn")
        // changeRadioBtnImg(tagValue: recordAudioRadioBtn.tag)
         self.previewView.isHidden = true
        textAnswerTextView.isHidden = true
        recordAudioBtn.isHidden = false
        //textAnswerTextView.text = ""
        recordAudioBtn.setTitle("Record Audio",for: .normal)


    }

    func updateUI()
    {

        self.answerlabel.translatesAutoresizingMaskIntoConstraints = true
        self.recordAudioBtn.translatesAutoresizingMaskIntoConstraints = true
        self.selectionView.translatesAutoresizingMaskIntoConstraints = true
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = true

        answerlabel.frame = CGRect(x: answerlabel.frame.origin.x , y: answerlabel.frame.origin.y, width: answerlabel.frame.size.width, height: answerlabel.frame.size.height)

        recordAudioBtn.frame = CGRect(x: recordAudioBtn.frame.origin.x , y:answerlabel.frame.origin.y + answerlabel.frame.size.height + 20  , width: recordAudioBtn.frame.size.width, height: recordAudioBtn.frame.size.height) //recordAudioBtn.frame.origin.y - 10

        previewView.frame = CGRect(x: previewView.frame.origin.x , y:recordAudioBtn.frame.origin.y + recordAudioBtn.frame.size.height + 20  , width: previewView.frame.size.width, height: previewView.frame.size.height)

        selectionView.frame = CGRect(x: selectionView.frame.origin.x , y: previewView.frame.origin.y + previewView.frame.size.height + 20, width: selectionView.frame.size.width, height: selectionView.frame.size.height)

         saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: saveBtn.frame.size.width, height: saveBtn.frame.size.height)

        
    }

    @IBAction func videoImageButtonAction(_ sender: Any)
    {
        self.view.endEditing(true)
        //self.textAnswerTextView.text = nil
        self.audioUrl = nil
        self.videoURL = nil

        audioImage.image = UIImage(named: "radio-Btn")
        videoImage.image = UIImage(named: "radioFill-btn")
        textImage.image = UIImage(named: "radio-Btn")

        // changeRadioBtnImg(tagValue: recordAudioRadioBtn.tag)
        self.previewView.isHidden = true

       
        textAnswerTextView.isHidden = true
        recordAudioBtn.isHidden = false
        recordAudioBtn.setTitle("Record Video",for: .normal)

    }

    @IBAction func textImageButtonAction(_ sender: Any)
    {
        //self.textAnswerTextView.text = nil
        self.audioUrl = nil
        self.videoURL = nil
        
        audioImage.image = UIImage(named: "radio-Btn")
        videoImage.image = UIImage(named: "radio-Btn")
        textImage.image = UIImage(named: "radioFill-btn")
        // changeRadioBtnImg(tagValue: recordAudioRadioBtn.tag)
         self.previewView.isHidden = true

       

        textAnswerTextView.isHidden = false
        recordAudioBtn.isHidden = true
    }

    @IBAction func recordAudioButtonAction(_ sender: Any)
    {
        if audioImage.image == UIImage(named: "radioFill-btn")
        {
            let vc:RecorderViewController = self.storyboard?.instantiateViewController(withIdentifier:"RecorderViewController") as! RecorderViewController
            vc.recievedBool = valueSent
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)

        }

        else
        {

            // 1 Check if project runs on a device with camera available
            if UIImagePickerController.isSourceTypeAvailable(.camera) {

                // 2 Present UIImagePickerController to take video
                controller.sourceType = .camera
                controller.mediaTypes = [kUTTypeMovie as String]
                controller.delegate = self

                present(controller, animated: true, completion: nil)
            }
            else {
                print("Camera is not available")
            }


        }
    }

    @IBAction func ssaveButtonAction(_ sender: Any)
    {
          editQuestionApi()
        
    }


    @IBAction func clickToSeePreviewButtonAction(_ sender: Any)
    {
        if audioImage.image == UIImage(named: "radioFill-btn")
        {
            let alertVC :PreviewAudioVideoPopup = (self.storyboard?.instantiateViewController(withIdentifier: "PreviewAudioVideoPopup") as? PreviewAudioVideoPopup)!

            alertVC.receivedUrl = self.audioUrl
            alertVC.receivedData = self.recordedData! as NSData

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

        else if videoImage.image == UIImage(named: "radioFill-btn")
        {
            let url:NSURL = self.videoURL! as NSURL
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url:url as URL)
            self.present(vc, animated: true) {
                vc.player?.play()
            }
        }

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
    //MARK:- Api Methods


    func editQuestionApi()
    {


  //  let todoEndpoint: String = "http://dev.loopleap.com/api/editquestion"
       // let parameters:[String : Any] = ["user_id": userId, "answer_id":obj.answer_id, "edit_answer":obj.question_id, "answer_by":obj.question_type, "video-blob": ""]
        let text:String = (textAnswerTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        if self.audioUrl != nil || self.videoURL != nil || text != ""
        {


            if textImage.image == UIImage(named: "radioFill-btn") &&  !text.isEmpty
            {

                self.parameters = ["answer_id":obj.id, "edit_answer":text, "answer_by":"write", "video-blob": ""]
            }

            if audioImage.image == UIImage(named: "radioFill-btn") && self.audioUrl != nil
            {

                self.parameters = ["answer_id":obj.id, "edit_answer":text, "answer_by":"record"]
            }

            if videoImage.image == UIImage(named: "radioFill-btn") && self.videoURL != nil
            {

                self.parameters = ["answer_id":obj.id, "edit_answer":text, "answer_by":"record"]
            }


            do{
                if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
                {
                    let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
                    //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
                    let headers = [
                        "Authorization": token_type + accessToken,
                        "Accept": "application/json"
                    ]
                    if self.parameters.count > 0 {

                    if ProjectManager.sharedInstance.isInternetAvailable()
                    {
                        ProjectManager.sharedInstance.showLoader()


                //var audiodata1 = Data()

                if audioImage.image == UIImage(named: "radioFill-btn") && self.audioUrl != nil
                {
                    //recordedData = try Data(contentsOf: self.audioUrl!)
                    print(self.recordedData!)

                    Alamofire.upload(multipartFormData: { (multipartFormData) in

                        multipartFormData.append(self.recordedData ?? Data(), withName: "video-blob", fileName:  "\(Date().ticks).m4a", mimeType: "audio")
                        for (key, value) in self.parameters {
                            // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)

                        }
                    }, to:baseURL + ApiMethods.editquestion, headers:headers)
                    { (result) in

                        //ProjectManager.sharedInstance.stopLoader()



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
                                        ProjectManager.sharedInstance.stopLoader()

                                    }
                                }
                                else {
                                    ProjectManager.sharedInstance.stopLoader()
                                    print(response.result.value)
                                    
                                    
                                    let data = response.result.value as? [String: Any]
                                    
                                    if data  != nil {
                                        let status = data!["status"] as? NSNumber
                                        if status == 1 {
                                            
                                            self.audioUrl = nil
                                            if self.delegate != nil {
                                                self.delegate?.tableDataRefresh()
                                            }
                                            
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                            
                                        else {
                                            
                                            let msg = data!["message"] as? String
                                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                            
                                        }
                                        
                                    }
                                }

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

                else if videoImage.image == UIImage(named: "radioFill-btn") && self.videoURL != nil
                {
                    recordedData = try Data(contentsOf: self.videoURL!)


                    Alamofire.upload(multipartFormData: { (multipartFormData) in

                        multipartFormData.append(self.recordedData ?? Data(), withName: "video-blob", fileName: "\(Date().ticks).mp4", mimeType: "video/mp4")
                        for (key, value) in self.parameters {
                            // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)

                        }
                    }, to:baseURL + ApiMethods.editquestion, headers:headers)
                    { (result) in

                        //ProjectManager.sharedInstance.stopLoader()


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
                                        ProjectManager.sharedInstance.stopLoader()

                                    }
                                }
                                else {
                                    ProjectManager.sharedInstance.stopLoader()
                                    print(response.result.value)
                                    
                                    
                                    let data = response.result.value as? [String: Any]
                                    
                                    if data  != nil {
                                        let status = data!["status"] as? NSNumber
                                        if status == 1 {
                                            
                                            self.videoURL = nil
                                            if self.delegate != nil {
                                                self.delegate?.tableDataRefresh()
                                            }
                                            self.dismiss(animated: true, completion: nil)
                                            
                                        }
                                            
                                        else {
                                            
                                            let msg = data!["message"] as? String
                                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                            
                                        }
                                    }
                                }

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


                //let parametr = ["user_id":"6","question_id":"4","answer":"", "answer_by":"record"]


                //                if self.assets.count > 0{
                //
                //                    if self.index < assets.count {
                // let asset = self.assets[self.index]
//                if audioImage.image == UIImage(named: "radioFill-btn")     //asset.mediaType == .audio
//                {
//
//
//                }

//                else if videoImage.image == UIImage(named: "radioFill-btn")
//                {
//
//
//                }

                else if textImage.image == UIImage(named: "radioFill-btn") && text != ""

                {


                    Alamofire.request(baseURL + ApiMethods.editquestion, method: .post,  parameters: self.parameters, encoding: JSONEncoding.default, headers:headers)
                        .responseJSON { response in
                            // check for errors
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling GET on /todos/1")
                                print(response.result.error!)
                                return
                            }

                            ProjectManager.sharedInstance.stopLoader()
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
                            if status == 1 {
                                
                                self.textAnswerTextView.text = nil
                                if self.delegate != nil {
                                    self.delegate?.tableDataRefresh()
                                }
                                self.dismiss(animated: true, completion: nil)
                            }
                            else {
                                
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                            }
                    }
                }

                else {
                    
                        }
                // }
            }

                    else {
                        DispatchQueue.main.async(execute: {
                            ProjectManager.sharedInstance.stopLoader()
                            ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                        })
                    }
                    }
        }//}
            }
            catch
            {

            }

        }

        else
        {
            //saveBool = true

            let alert = UIAlertController(title: "Error", message: "Please Select one answer.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
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
//                                     self.showPlanBtn.isHidden = false
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
