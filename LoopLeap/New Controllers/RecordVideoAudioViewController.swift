//
//  RecordVideoAudioViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 18/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import PopupDialog
import AssetsPickerViewController
import Photos
import AVFoundation
import AVKit
import MediaPlayer

class RecordVideoAudioViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, AudioDelegate {
    func didselectAutoCompleteOption() {
        print("vhjxg")
    }
    
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
    
    @IBOutlet weak var contentView1: UIView!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var dateview:UIView!
     @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var selectDirectoryView: UIView!
    @IBOutlet weak var selectDirectroyTextField: UITextField!
    @IBOutlet weak var selectDirBtn: UIButton!
    
    
    @IBOutlet weak var selectChildTextField: UITextField!
    @IBOutlet weak var enterTagTextField: MultiAutoCompleteTextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var pickerInputView: UIView!
    @IBOutlet weak var chooseDatePicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var clickToSeePreviewBtn: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var audioIconImgViw: UIImageView!
    @IBOutlet weak var videoIconImgViw: UIImageView!
    @IBOutlet weak internal var recordViw: UIView!
    @IBOutlet weak var recordIcon: UIImageView!
    @IBOutlet weak var recordViwLbl: UILabel!
    
    @IBOutlet weak var selectChildView: UIView!
    @IBOutlet weak var adminView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var adminBtn: UIButton!
    @IBOutlet weak var childBtn: UIButton!
    @IBOutlet weak var adminRoundView: UIView!
    @IBOutlet weak var adminFillView: UIView!
    @IBOutlet weak var childRoundView: UIView!
    @IBOutlet weak var childFillView: UIView!
    
    
    
    
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
    var activeField: UITextField?
    var textFieldPressedValue = Int()
    var directoryArray = [KeyHolderObject]()
    var childArray = [KeyHolderObject]()
    var childDirArray = [KeyHolderObject]()
    var adminArray = [KeyHolderObject]()


    var type = String()
    var role = Int()

    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
         type = "admin"
        
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
        
        // chooseDateTextField.delegate = self
        enterTagTextField.delegate = self
        
        enterTagTextField.leftViewMode = .always
        let viw =  UIView(frame: CGRect(x:0, y:0, width: 60, height: 60))
        let tagIcon = UIImageView(frame: CGRect(x:17, y:22, width: 16, height: 16))
        tagIcon.image = UIImage(named: "enterTag-Icon")
        viw.addSubview(tagIcon)
        enterTagTextField.leftView = viw
        
        titleTextField.delegate = self
        titleTextField.leftViewMode = .always
        let viw1 =  UIView(frame: CGRect(x:0, y:0, width: 60, height: 60))
        let titleIcon = UIImageView(frame: CGRect(x:17, y:22, width: 16, height: 16))
        titleIcon.image = UIImage(named: "enterTag-Icon")
        viw1.addSubview(titleIcon)
        titleTextField.leftView = viw1
        
        selectDirectroyTextField.delegate = self
        selectDirectroyTextField.leftViewMode = .always
        let viw2 =  UIView(frame: CGRect(x:0, y:0, width: 60, height: 60))
        let directoryIcon = UIImageView(frame: CGRect(x:17, y:22, width: 16, height: 16))
        directoryIcon.image = UIImage(named: "selectDirectry-Icon")
        viw2.addSubview(directoryIcon)
        selectDirectroyTextField.leftView = viw2
        
        selectChildTextField.delegate = self
        selectChildTextField.leftViewMode = .always
        let viw3 =  UIView(frame: CGRect(x:0, y:0, width: 60, height: 60))
        let dateIcon = UIImageView(frame: CGRect(x:17, y:22, width: 16, height: 16))
        dateIcon.image = UIImage(named: "child")
        viw3.addSubview(dateIcon)
        selectChildTextField.leftView = viw3
        
        
        showDatePicker()
        showPicker()
        
        enterTagTextField.autoCompleteWordTokenizers = [","]
        
        adminRoundView.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: adminRoundView.frame.height/2)
        adminFillView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: adminFillView.frame.height/2)
        
        childRoundView.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: adminRoundView.frame.height/2)
        childFillView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: childFillView.frame.height/2)
        
        
        getDirectoriesList()
        
        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil) {
            
            if let userRole = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
                
                role = userRole
            
             if role == 6 {
                
                selectionView.isHidden = true
                selectChildView.isHidden = true
                
               selectionView.translatesAutoresizingMaskIntoConstraints = true
               titleTextField.translatesAutoresizingMaskIntoConstraints = true
               adminView.translatesAutoresizingMaskIntoConstraints = true
               selectDirectoryView.translatesAutoresizingMaskIntoConstraints = true
                
                titleTextField.frame = CGRect(x: selectionView.frame.origin.x , y: selectionView.frame.origin.y + 20
                    , width: UIScreen.main.bounds.size.width - 70, height: titleTextField.frame.size.height)
                
                adminView.frame = CGRect(x: 0 , y: titleTextField.frame.origin.y + 60
                    , width: adminView.frame.size.width, height: adminView.frame.size.height)
                
                selectDirectoryView.frame = CGRect(x:selectDirectoryView.frame.origin.x , y: selectDirectoryView.frame.origin.y
                    , width: UIScreen.main.bounds.size.width - 70, height: selectDirectoryView.frame.size.height)
                
            }
                
            else {
                
                selectionView.isHidden = false
                selectChildView.isHidden = false
                
                if type == "child" {
                    
                    getChildList()
                }

                
            }
                
            }
            
            else {
                
                if type == "child" {
                    
                    getChildList()
                }
                
            }
            
        }
        
        else {
            
            if type == "child" {
                
                getChildList()
            }

        }
        
        self.parent?.view.endEditing(true)
        
        
        
        // Do any additional setup after loading the view.
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // self.previewView.isHidden = false
        
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
        self.previewLabel.text = "Note: Re-record to change current recorded video"
        updateUI()
    }
    
    
    //MARK:-
    //MARK:- IBAction Methods
    @IBAction func backButtonAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func audioButtonAction(_ sender: Any)
    {
       // self.previewView.isHidden = true
        audioBtn.layer.borderColor = UIColor.red.cgColor
        videoBtn.layer.borderColor = UIColor.black.cgColor
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
        
        audioBtnValue = true
        videoBtnValue = false
        let vc:RecorderViewController = self.storyboard?.instantiateViewController(withIdentifier:"RecorderViewController") as! RecorderViewController
        vc.recievedBool = valueSent
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func videoButtonAction(_ sender: Any)
    {
       // self.previewView.isHidden = true
        videoBtn.layer.borderColor = UIColor.red.cgColor
        audioBtn.layer.borderColor = UIColor.black.cgColor
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
        
        
        
        videoBtnValue = true
        audioBtnValue = false
        
        
        
        
        
        
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
    
    @IBAction func adminRadioBtnAction(_ sender: Any) {
        
         type = "admin"
         self.view.endEditing(true)

        
        selectDirectroyTextField.isEnabled = true
        selectDirectroyTextField.isUserInteractionEnabled = true
        
        titleTextField.text = ""
        selectDirectroyTextField.text = ""
        selectChildTextField.text = ""
        enterTagTextField.text = ""
        
        directoryArray = adminArray
        
       
        adminFillView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        childFillView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        selectChildView.isHidden = true
        
       
        
        
        previewView.translatesAutoresizingMaskIntoConstraints = true
        selectionView.translatesAutoresizingMaskIntoConstraints = true
        titleTextField.translatesAutoresizingMaskIntoConstraints = true

        adminView.translatesAutoresizingMaskIntoConstraints = true
        selectChildView.translatesAutoresizingMaskIntoConstraints = true

        
        
        if previewView.isHidden == false {
            
            previewView.frame = CGRect(x: previewView.frame.origin.x , y: previewView.frame.origin.y
                , width: previewView.frame.size.width, height: previewView.frame.size.height)
            
            selectionView.frame = CGRect(x: selectionView.frame.origin.x , y:previewView.frame.origin.y + previewView.frame.size.height + 20 , width: selectionView.frame.size.width, height: selectionView.frame.size.height)
            
            titleTextField.frame = CGRect(x: titleTextField.frame.origin.x , y:selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: titleTextField.frame.size.width, height: titleTextField.frame.size.height)
            
            adminView.frame = CGRect(x: adminView.frame.origin.x , y:titleTextField.frame.origin.y + titleTextField.frame.size.height + 20 , width: adminView.frame.size.width, height: adminView.frame.size.height)
            
       
            
        }
        
        else {
        
        titleTextField.frame = CGRect(x: titleTextField.frame.origin.x , y: titleTextField.frame.origin.y
            , width: titleTextField.frame.size.width, height: titleTextField.frame.size.height)
        
        selectChildView.frame = CGRect(x: selectChildView.frame.origin.x , y: selectChildView.frame.origin.y
            , width: selectChildView.frame.size.width, height: selectChildView.frame.size.height)
        
        adminView.frame = CGRect(x: adminView.frame.origin.x , y: selectChildView.frame.origin.y
            , width: adminView.frame.size.width, height: adminView.frame.size.height)

        }
        
    }
    
    
    @IBAction func childRadioBtnAction(_ sender: Any) {
        
        type = "child"
        
        childArray.removeAll()
        childDirArray.removeAll()
        
        getChildList()
        self.view.endEditing(true)
        
        selectChildTextField.isEnabled = true
        selectChildTextField.isUserInteractionEnabled = true
        
        selectDirectroyTextField.isEnabled = false
        selectDirectroyTextField.isUserInteractionEnabled = false
        
        titleTextField.text = ""
        selectDirectroyTextField.text = ""
        selectChildTextField.text = ""
        enterTagTextField.text = ""
        
        directoryArray.removeAll()

        
        
        childFillView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1)
        adminFillView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        selectChildView.isHidden = false
        
        previewView.translatesAutoresizingMaskIntoConstraints = true
        selectionView.translatesAutoresizingMaskIntoConstraints = true
        titleTextField.translatesAutoresizingMaskIntoConstraints = true

        adminView.translatesAutoresizingMaskIntoConstraints = true
        selectChildView.translatesAutoresizingMaskIntoConstraints = true
        
        
        if previewView.isHidden == false {
            
            
            previewView.frame = CGRect(x: previewView.frame.origin.x , y: previewView.frame.origin.y
                , width: previewView.frame.size.width, height: previewView.frame.size.height)
            
            
            selectionView.frame = CGRect(x: selectionView.frame.origin.x , y:previewView.frame.origin.y + previewView.frame.size.height + 20 , width: selectionView.frame.size.width, height: selectionView.frame.size.height)
            
            titleTextField.frame = CGRect(x: titleTextField.frame.origin.x , y:selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: titleTextField.frame.size.width, height: titleTextField.frame.size.height)
            
            
            selectChildView.frame = CGRect(x: selectChildView.frame.origin.x , y:titleTextField.frame.origin.y + titleTextField.frame.size.height + 20 , width: selectChildView.frame.size.width, height: selectChildView.frame.size.height)
            
            adminView.frame = CGRect(x: adminView.frame.origin.x , y:selectChildView.frame.origin.y + selectChildView.frame.size.height + 20 , width: adminView.frame.size.width, height: adminView.frame.size.height)
    
            
        }
        
        else {
        
        
        titleTextField.frame = CGRect(x: titleTextField.frame.origin.x , y: titleTextField.frame.origin.y
            , width: titleTextField.frame.size.width, height: titleTextField.frame.size.height)
        
        selectChildView.frame = CGRect(x: selectChildView.frame.origin.x , y: selectChildView.frame.origin.y
            , width: selectChildView.frame.size.width, height: selectChildView.frame.size.height)
        
        adminView.frame = CGRect(x: adminView.frame.origin.x , y: selectChildView.frame.origin.y + selectChildView.frame.size.height + 5
            , width: adminView.frame.size.width, height: adminView.frame.size.height)
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
        let dir = (selectDirectroyTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if dir.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Please choose directory", vc: self)
        }
            
       else  if self.audioUrl == nil && self.videoURL == nil {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Please record Audio/Video first", vc: self)
        }
        else {
            saveIntro()
        }
        
    }
    
    @IBAction func cancelToolButtonAction(_ sender: Any)
    {
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneToolButtonAction(_ sender: Any)
    {
        
    }
    
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        
        let row = pickerView.selectedRow(inComponent: 0)
        
        if textFieldPressedValue == 1 {
     
                if type == "child" {
                    
                    if childDirArray.count > 0 {
                        
                        selectDirectroyTextField.text = childDirArray[row].dir_name
                        
                    }
                }
                    
                    
                else {
                    
                    if directoryArray.count > 0 {
                        
                        selectDirectroyTextField.text = directoryArray[row].dir_name
                    }
                    
                }
                
            }
            
   
            
        else if textFieldPressedValue == 2 {
            
            if childArray.count > 0 {
            selectChildTextField.text = childArray[row].name
                
                selectDirectroyTextField.text = ""
                
                self.childDirArray.removeAll()
                self.getChildDirectoriesList()
                
            }
            
        }
        
        
                self.view.endEditing(true)
        
    }
    
    
    @IBAction func clickToSeePreviewButtonAction(_ sender: Any)
    {
        if audioBtnValue == true
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
    
    //MARK:-
    //MARK:- Methods
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == selectDirectroyTextField && type == "child" && (selectChildTextField.text?.isEmpty)! {
            
            selectDirectroyTextField.isEnabled = false
            selectDirectroyTextField.isUserInteractionEnabled = false
            
            
            
        }
            
         else {
            
            selectDirectroyTextField.isEnabled = true
            selectDirectroyTextField.isUserInteractionEnabled = true
            
        }
        
        
        if textField == selectChildTextField {
            
            textFieldPressedValue = 2
            type = "child"
            
            
        }
        if textField == selectDirectroyTextField && type == "admin" {
            
            textFieldPressedValue = 1
            
        }
        
        pickerView.reloadAllComponents()
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        activeField = textField
        
        if textField == selectDirectroyTextField {
            textFieldPressedValue = textField.tag
            showPicker()
            print("You edit myTextField")
        }
            
        else if textField == selectChildTextField {
            textFieldPressedValue = textField.tag
            showPicker()
            print("You edit myTextField")
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == enterTagTextField {
            activeField = nil
        }
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = enterTagTextField.text
        {
            getTags()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:-
    //MARK:- Picker Method
    
    @objc func showPicker()
    {
        
        selectDirectroyTextField.inputView = pickerInputView
        selectDirectroyTextField.inputAccessoryView = nil
        selectChildTextField.inputView = pickerInputView
        selectChildTextField.inputAccessoryView = nil
        
        
    }
    
    
    @objc func showDatePicker()
    {
        //Formate Date
//                chooseDatePicker.datePickerMode = .date
//                chooseDateTextField.inputView = pickerInputView
//                chooseDateTextField.inputAccessoryView = nil
//                chooseDatePicker.maximumDate = Date()
        
        
    }
    
    func updateUI()
    {
        
        self.adminView.translatesAutoresizingMaskIntoConstraints = true
        self.selectionView.translatesAutoresizingMaskIntoConstraints = true
        self.titleTextField.translatesAutoresizingMaskIntoConstraints = true
        self.selectChildView.translatesAutoresizingMaskIntoConstraints = true
        self.selectDirectroyTextField.translatesAutoresizingMaskIntoConstraints = true

        self.audioBtn.translatesAutoresizingMaskIntoConstraints = true
        self.videoBtn.translatesAutoresizingMaskIntoConstraints = true
        self.cancelBtn.translatesAutoresizingMaskIntoConstraints = true
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
        self.previewView.translatesAutoresizingMaskIntoConstraints = true
        // self.dateview.translatesAutoresizingMaskIntoConstraints = true
        self.enterTagTextField.translatesAutoresizingMaskIntoConstraints = true
        
       // previewView.frame = CGRect(x: previewView.frame.origin.x , y:audioBtn.frame.origin.y + audioBtn.frame.size.height + 20 , width: previewView.frame.size.width, height: previewView.frame.size.height)
        
        
        
        // dateview.frame = CGRect(x: dateview.frame.origin.x , y:previewView.frame.origin.y + previewView.frame.size.height + 20 , width: dateview.frame.size.width, height: dateview.frame.size.height)
        
//        audioBtn.frame = CGRect(x: audioBtn.frame.origin.x , y:audioBtn.frame.origin.y , width: audioBtn.frame.size.width, height: audioBtn.frame.size.height)
//
//         audioIconImgViw.frame = CGRect(x: audioIconImgViw.frame.origin.x , y:audioIconImgViw.frame.origin.y , width: audioIconImgViw.frame.size.width, height: audioIconImgViw.frame.size.height)
        
        if type == "admin" {
            
            
            
            if role == 6 {
                
                
                previewView.frame = CGRect(x: previewView.frame.origin.x , y: previewView.frame.origin.y , width: previewView.frame.size.width, height: previewView.frame.size.height)
                
                
                titleTextField.frame = CGRect(x: selectionView.frame.origin.x , y: previewView.frame.origin.y + 60
                    , width: UIScreen.main.bounds.size.width - 70, height: titleTextField.frame.size.height)
                
                adminView.frame = CGRect(x: 0 , y: titleTextField.frame.origin.y + 60
                    , width: adminView.frame.size.width, height: adminView.frame.size.height)
                
                selectDirectoryView.frame = CGRect(x:selectDirectoryView.frame.origin.x , y: selectDirectoryView.frame.origin.y
                    , width: UIScreen.main.bounds.size.width - 70, height: selectDirectoryView.frame.size.height)
                
                
            }
            
            else {
                
                selectChildView.isHidden = true
            
            selectionView.frame = CGRect(x: selectionView.frame.origin.x , y:previewView.frame.origin.y + previewView.frame.size.height + 20 , width: selectionView.frame.size.width, height: selectionView.frame.size.height)
            
            titleTextField.frame = CGRect(x: titleTextField.frame.origin.x , y:selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: titleTextField.frame.size.width, height: titleTextField.frame.size.height)
            
            adminView.frame = CGRect(x: adminView.frame.origin.x , y:titleTextField.frame.origin.y + titleTextField.frame.size.height + 20 , width: adminView.frame.size.width, height: adminView.frame.size.height)
            
            }
            
        }
        
        else if type == "child" {
            
            
            selectionView.frame = CGRect(x: selectionView.frame.origin.x , y:previewView.frame.origin.y + previewView.frame.size.height + 20 , width: selectionView.frame.size.width, height: selectionView.frame.size.height)
            
            titleTextField.frame = CGRect(x: titleTextField.frame.origin.x , y:selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: titleTextField.frame.size.width, height: titleTextField.frame.size.height)
            
            
            selectChildView.frame = CGRect(x: selectChildView.frame.origin.x , y:titleTextField.frame.origin.y + titleTextField.frame.size.height + 20 , width: selectChildView.frame.size.width, height: selectChildView.frame.size.height)
            
            adminView.frame = CGRect(x: adminView.frame.origin.x , y:selectChildView.frame.origin.y + selectChildView.frame.size.height + 20 , width: adminView.frame.size.width, height: adminView.frame.size.height)
     
            
        }
       

        
//        enterTagTextField.frame = CGRect(x: enterTagTextField.frame.origin.x , y:previewView.frame.origin.y + previewView.frame.size.height + 20 , width: enterTagTextField.frame.size.width, height: enterTagTextField.frame.size.height)
//
//
//        cancelBtn.frame = CGRect(x: cancelBtn.frame.origin.x , y:enterTagTextField.frame.origin.y + enterTagTextField.frame.size.height + 20 , width:
//            cancelBtn.frame.size.width, height: cancelBtn.frame.size.height)
//
//        saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y:enterTagTextField.frame.origin.y + enterTagTextField.frame.size.height + 20  , width: saveBtn.frame.size.width, height: saveBtn.frame.size.height)
    }
    
    
    //MARK:-
    //MARK:- PickerView DataSources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if textFieldPressedValue == 1 {
            
            if type == "child" {
                
                if childDirArray.count > 0 {
                    
                    return childDirArray.count
                    
                }
                    
                else {
                    
                    return 0
                }
                
                
            }
            
            else {
            
                return directoryArray.count
                
            }
            
        }
        else {
            
            return childArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if textFieldPressedValue == 1 {
            
            if type == "child" {
                
                if childDirArray.count > 0 {
                    
                    return childDirArray[row].dir_name
                    
                }
                    
                else {
                    return ""
                }


            }
            
            else {
                  return directoryArray[row].dir_name
                
            }
        }
        else {
            
            return childArray[row].name
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //selectPickerIndex = row
        //        chooseDirTextField.text = pickerArray[row]
        //        dircollectionArray.append(pickerArray[row])
        //        directoryCollectionView.reloadData()
        
        
    }
    
    
    //MARK:-
    //MARK:- Api Methods
    
    @objc func getTags()
    {
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            let parameters:[String : Any] = ["term":"tag"]
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                // ProjectManager.sharedInstance.showLoader()
                
                
                
                Alamofire.request(baseURL + ApiMethods.tags, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
                    .responseJSON { response in
                        
                        // ProjectManager.sharedInstance.stopLoader()
                        
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
    
    
    func saveIntro()
    {
        
        let title:String = (titleTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        let tags:String = (enterTagTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        let dir:String = (selectDirectroyTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        let childDir:String = (selectChildTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if dir.isEmpty {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter Directory", vc: self)
        }
        else if type == "child" && childDir.isEmpty  {
            
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter child Directory", vc: self)
            
        }
        
        else {
        
        
        let row = pickerView.selectedRow(inComponent: 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        do{
            if audioBtnValue
            {
//                guard self.audioUrl != nil  else {return}
//
//                self.recordedData = try Data(contentsOf: self.audioUrl!)
                
                print(self.recordedData!)
            }
                
            else if videoBtnValue
            {
                guard self.videoURL != nil  else {return}
                self.recordedData = try Data(contentsOf: self.videoURL!)
                
            }
            
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
                    
                    
                    //let parametr = ["user_id":"6","question_id":"4","answer":"", "answer_by":"record"]
                    
                    if audioBtnValue
                    {
                        if  type == "admin" {
                        
                            params = ["tags":tags, "recording_type":"audio", "recording_title":title, "file_date":dateFormatter.string(from:Date()), "type":self.type, "directory_id":self.directoryArray[row].dir_id]
                            
                        }
                        
                        else if  type == "child" {
                            
                            params = ["tags":tags, "recording_type":"audio", "recording_title":title, "file_date":dateFormatter.string(from:Date()), "type":self.type, "directory_id":self.childDirArray[row].dir_id, "child_id":self.childArray[row].id]
                            
                            
                        }
                        
                        Alamofire.upload(multipartFormData: { (multipartFormData) in
                            
                            multipartFormData.append(self.recordedData ?? Data(), withName: "video-blob", fileName:  "\(Date().ticks).m4a", mimeType: "audio")
                            for (key, value) in self.params {
                                // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                                
                            }
                        }, to:baseURL + ApiMethods.saveintro, headers:headers)
                        { (result) in
//                            ProjectManager.sharedInstance.stopLoader()
                            
                            
                            
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
                                        print(response.result.value!)
                                        
                                        
                                        let json = response.result.value as? [String: Any]
                                        ProjectManager.sharedInstance.stopLoader()
                                        
                                        if json  != nil {
                                         let status = json!["status"] as? NSNumber
                                        if status == 1 {
                                        let msg = json!["message"] as? String
                                        let alert = UIAlertController(title: "", message: msg!, preferredStyle: .alert)
                                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                            
                                           ProjectManager.sharedInstance.refreshTimeLineDelegate?.refreshTimeLine()
                                            
                                            self.dismiss(animated: true, completion: nil)
                                            
                                        }
                                        alert.addAction(OKAction)
                                        
                                        
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                    }
                                        
                                        else {
                                            
                                             let msg = json!["message"] as? String
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
                        
                    else if videoBtnValue
                    {
//                        params = ["tags":enterTagTextField.text!, "recording_type":"video", "file_date":dateFormatter.string(from:Date())]
                        
                        
                        if  type == "admin" {
                            
                            params = ["tags":tags, "recording_type":"video", "recording_title":title, "file_date":dateFormatter.string(from:Date()), "type":self.type, "directory_id":self.directoryArray[row].dir_id]
                            
                        }
                            
                        else if  type == "child" {
                            
                            params = ["tags":tags, "recording_type":"video",  "recording_title":title, "file_date":dateFormatter.string(from:Date()), "type":self.type, "directory_id":self.childDirArray[row].dir_id, "child_id":self.childArray[row].id]
                            
                            
                        }
                        
                        
                        
                        Alamofire.upload(multipartFormData: { (multipartFormData) in
                            
                            multipartFormData.append(self.recordedData ?? Data(), withName: "video-blob", fileName: "\(Date().ticks).mp4", mimeType: "video/mp4")
                            for (key, value) in self.params {
                                // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                                
                            }
                        }, to:baseURL + ApiMethods.saveintro, headers:headers)
                        { (result) in
                           
                            
                            
                            
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
                                           
                                            
                                             ProjectManager.sharedInstance.stopLoader()
                                            ProjectManager.sharedInstance.showServerError(viewController:self)
                                        }
                                    }
                                    else {
                                        print(response.result.value!)
                                        
                                        
                                        let json = response.result.value as? [String: Any]
                                         ProjectManager.sharedInstance.stopLoader()
                                        
                                        if json  != nil {
                                            let status = json!["status"] as? NSNumber
                                            if status == 1 {
                                                let msg = json!["message"] as? String
                                                let alert = UIAlertController(title: "", message: msg!, preferredStyle: .alert)
                                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                                    
                                                    ProjectManager.sharedInstance.refreshTimeLineDelegate?.refreshTimeLine()
                                                    
                                                    self.dismiss(animated: true, completion: nil)
                                                    
                                                }
                                                alert.addAction(OKAction)
                                                
                                                
                                                
                                                self.present(alert, animated: true, completion: nil)
                                                
                                                
                                            }
                                                
                                            else {
                                                
                                                let msg = json!["message"] as? String
                                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    //print response.result
                                }
                                
                                // })
                                
                                
                                
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
        catch let error as NSError {
            
            print(error)
            
        }
        
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
                                
                                if data.count > 0 {
                                    
                                self.selectDirectroyTextField.isEnabled = true

                                print(data)
                                self.directoryArray = ProjectManager.sharedInstance.GetKeyHolderListObjects(array: data)
                                    
                                    self.adminArray = ProjectManager.sharedInstance.GetKeyHolderListObjects(array: data)
                              
                                    
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
                    
                    ProjectManager.sharedInstance.stopLoader()
                    ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                })
            }
        }
    }
    
    func getChildList() {
        
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
                
                
                Alamofire.request(baseURL + ApiMethods.childlistDropdown, method: .get,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? NSArray {
                                
                                if data.count > 0 {
                                    
                                    self.selectChildTextField.isEnabled = true
                                    self.selectDirectroyTextField.isEnabled = true
                                    self.selectChildTextField.isUserInteractionEnabled = true
                                    self.selectDirectroyTextField.isUserInteractionEnabled = true
                                    
                                    print(data)
                                    self.childArray = ProjectManager.sharedInstance.GetPublicDirObjects(array: data)
                                }
                                
                                else {
                                    
                                    self.selectChildTextField.isEnabled = false
                                    self.selectDirectroyTextField.isEnabled = false
                                    self.selectChildTextField.isUserInteractionEnabled = false
                                    self.selectDirectroyTextField.isUserInteractionEnabled = false
                                    
                                    let msg = json["message"] as? String
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                    
                                }
                                
                            }
                            else{
                                
                                self.selectChildTextField.isEnabled = false
                                self.selectDirectroyTextField.isEnabled = false
                                self.selectChildTextField.isUserInteractionEnabled = false
                                self.selectDirectroyTextField.isUserInteractionEnabled = false
                                
                                let msg = json["message"] as? String
                                ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                
                                
                            }
                            
                        }
                        else {
                            self.selectChildTextField.isEnabled = false
                            self.selectDirectroyTextField.isEnabled = false
                            self.selectChildTextField.isUserInteractionEnabled = false
                            self.selectDirectroyTextField.isUserInteractionEnabled = false
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
    
    
    func getChildDirectoriesList() {
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            //let todoEndpoint: String = "http://dev.loopleap.com/api/notificationslist"
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]
            
            let row = pickerView.selectedRow(inComponent: 0)
            var parameters = [String: Any]()
            parameters = ["child_id":self.childArray[row].id]
            
            if ProjectManager.sharedInstance.isInternetAvailable()
            {
                ProjectManager.sharedInstance.showLoader()
                
                
                Alamofire.request(baseURL + ApiMethods.childDirectory, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? NSArray {
                                
                                if data.count > 0 {
                                    
                               self.selectDirectroyTextField.isEnabled = true

                                print(data)
                                self.childDirArray = ProjectManager.sharedInstance.GetKeyHolderListObjects(array: data)
                                    
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
                    
                    ProjectManager.sharedInstance.stopLoader()
                    ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                })
            }
        }
    }

    
    
}
