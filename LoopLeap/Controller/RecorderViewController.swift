//
//  RecorderViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 05/10/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import PopupDialog

protocol AudioDelegate {
    func didFindAudioFile(found : URL)
}


class RecorderViewController: UIViewController , AVAudioRecorderDelegate{
    
     private var observer: NSObjectProtocol?
    @IBOutlet weak var waveViw: UIView!
    
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var pausebtn: UIButton!
    @IBOutlet weak var reloadBtn: UIButton!
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var loadedPlayBtn: UIButton!

    
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var recorLbl: UILabel!
    var audioRecorder:AVAudioRecorder!
    
    var recordTime = Int()
    var timer = Timer()
    var fileURL : URL?

    var recievedBool = Bool()
    var delegate : AudioDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        /** LCWaveView **/
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: waveViw.frame.size.height - 100)
        let waveView = LCWaveView(frame: frame, color: #colorLiteral(red: 0.768627451, green: 0.1490196078, blue: 0.1490196078, alpha: 1) )
        waveView.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
        waveView.waveFrequency = 2
        waveView.waveSpeed = 1
        waveViw.addSubview(waveView)
        //        waveView.addOverView(oView: overView)
        waveView.startWave()
        
        self.checkBtn.isHidden = true
        playBtn.isHidden = true
        reloadBtn.isHidden = true
        pausebtn.isHidden = true
        loadedPlayBtn.isHidden = false
        observer = NotificationCenter.default.addObserver(forName:Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: .main) {_ in
            
            self.timer.invalidate()
            self.recordTime = 0
            self.timerLbl.text = "00:00:00"
            self.checkBtn.isHidden = true
            self.recorLbl.isHidden = true
            self.pausebtn.isHidden = true
            self.reloadBtn.isHidden = true
            self.playBtn.isHidden = true
            self.pausebtn.isHidden = true
            self.loadedPlayBtn.isHidden = false
            self.audioRecorder.stop()
            let fileMgr = FileManager.default
            
            let dirPaths = fileMgr.urls(for: .documentDirectory,
                                        in: .userDomainMask)
            
            let soundFileURL = dirPaths[0].appendingPathComponent("sound.m4a")
            self.fileURL = soundFileURL
            
            if fileMgr.fileExists(atPath: soundFileURL.path) {
                do {
                    try fileMgr.removeItem(at:soundFileURL)
                    
                }
                catch {
                    
                }
            }
            // do whatever you want when the app is brought back to the foreground
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if !self.audioRecorder.isRecording {
//            audioRecorder.record()
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fileMgr = FileManager.default

        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)

        let soundFileURL = dirPaths[0].appendingPathComponent("sound.m4a")
        fileURL = soundFileURL

        if fileMgr.fileExists(atPath: soundFileURL.path) {
            do {
                try fileMgr.removeItem(at:soundFileURL)

            }
            catch {

            }
        }
        let recordSettings =
            [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),AVSampleRateKey: 44100,AVNumberOfChannelsKey: 2,AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue]

           let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
//            audioRecorder.updateMeters()
//            audioRecorder.isMeteringEnabled = true
           // audioRecorder.delegate = self
           audioRecorder.prepareToRecord()
                audioRecorder.delegate = self
               //audioRecorder.record()
//
//            timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(updateTimer), userInfo:nil , repeats: true)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }


        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
    @IBAction func closeAction(_ sender: Any) {
        
     
        
       self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func uploadAudioAction(_ sender: Any) {

         audioRecorder.stop()


        if recievedBool == true
        {
            if delegate != nil {
                delegate?.didFindAudioFile(found: fileURL!)
            }

             self.dismiss(animated: false, completion: nil)

        }
        else
        {

      
        let url = baseURL + ApiMethods.uploadFileAPI
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let imgParam = "files"
        
        do {
            
        let audioData = try Data(contentsOf: fileURL!)
            print(audioData)
     
        let fileSizeMb = (Float(audioData.count) / Float(1024)/Float(1024))
        
        if fileSizeMb < 20 ||  fileSizeMb == 20  {
        let fileSize = audioData.count / 1024
        print("File Size *** \(fileSize)")
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
                multipartFormData.append(audioData, withName: imgParam, fileName: "\(Date().ticks).m4a", mimeType: "audio")
                for (key, value) in params {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to:url, headers:headers)
            { (result) in
   
                switch result {
                    
                    
                    
                case .success(let upload, _, _):
                    
                    
                    self.dismiss(animated: false, completion: {
                        
                        self.uploadPopup()
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
                                    ProjectManager.sharedInstance.showServerError(viewController:self)
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
            else {
            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Audio size should not be greater than 20 MB", vc: UIApplication.topViewController()!)
            }
        }
        catch {
            
        }
    }
}

    func uploadPopup() {
        
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
    
    @IBAction func reloadAction(_ sender: Any) {
        loadedPlayBtn.isHidden = true

        self.timer.invalidate()
        self.recordTime = 0
        self.timerLbl.text = "00:00:00"
         self.checkBtn.isHidden = true
        self.recorLbl.isHidden = true
        self.pausebtn.isHidden = true
        self.reloadBtn.isHidden = false
        self.playBtn.isHidden = false
        audioRecorder.stop()
        
    }
    @IBAction func pauseAction(_ sender: Any) {
        
        loadedPlayBtn.isHidden = true

        self.recorLbl.isHidden = false
        self.recorLbl.text = "Paused"
        self.pausebtn.isHidden = true
        self.reloadBtn.isHidden = false
        self.playBtn.isHidden = false
      if audioRecorder.isRecording == true {
            audioRecorder.pause()
            self.timer.invalidate()
       }
        
        if recordTime > 0 {
            
            self.checkBtn.isHidden = false
        }
        else {
             self.checkBtn.isHidden = true
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        loadedPlayBtn.isHidden = true
        self.pausebtn.isHidden = false
        self.reloadBtn.isHidden = true
        self.playBtn.isHidden = true
         self.checkBtn.isHidden = true
        if recordTime == 0 {
            
            let fileMgr = FileManager.default
            
            let dirPaths = fileMgr.urls(for: .documentDirectory,
                                        in: .userDomainMask)
            
            let soundFileURL = dirPaths[0].appendingPathComponent("sound.m4a")
            fileURL = soundFileURL
            
            if fileMgr.fileExists(atPath: soundFileURL.path) {
                do {
                    try fileMgr.removeItem(at:soundFileURL)
                    
                }
                catch {
                    
                }
            }
            let recordSettings =
                [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),AVSampleRateKey: 44100,AVNumberOfChannelsKey: 2,AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue]

            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioRecorder = AVAudioRecorder(url: fileURL!,
                                                    settings: recordSettings as [String : AnyObject])
                
//                audioRecorder.updateMeters()
//                audioRecorder.isMeteringEnabled = true
                audioRecorder.delegate = self

              audioRecorder.prepareToRecord()
               // audioRecorder.record()
                
                timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(updateTimer), userInfo:nil , repeats: true)
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }

            do {
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch {
            }
        }
        
        else {
            audioRecorder.record()
             timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(updateTimer), userInfo:nil , repeats: true)
            self.timer.fire()
        }
         self.recorLbl.isHidden = false
         self.recorLbl.text = "Recording"
       if audioRecorder.isRecording == false {
            self.pausebtn.isHidden = false
            self.reloadBtn.isHidden = true
            self.playBtn.isHidden = true
        
        }
    }

    
   @objc func updateTimer() {
        recordTime = recordTime + 1
        let hours =  recordTime / 3600
        let minutes = recordTime / 60 % 60
        let seconds = recordTime % 60
         self.timerLbl.text =  String(format:"%02i:%02i:%02i", hours, minutes, seconds)
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
