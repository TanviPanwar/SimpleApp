//
//  DownloadingPopup.swift
//  LoopLeap
//
//  Created by IOS3 on 08/01/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import MediaPlayer
import Alamofire
import CoreServices
import AssetsPickerViewController
import Photos
import PopupDialog




class DownloadFilesPopup: UIViewController, AudioVideoDelegate, AVAudioPlayerDelegate
{
    func displayAudioVideo(found: URL ,fileName: String ) {
        print(found)
      //  receivedUrl = found
        receivedFileName = fileName

        

    }

    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var playAudioBtn: UIButton!
    @IBOutlet weak var audioImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dirNameLabel: UILabel!
    
    @IBOutlet weak var downlaodBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    var yesAcion :blockAction?
    var  noAction : blockAction?
    var receivedUrl: String?
    var receivedFileName: String?
    var receivedID: String?
    var receivedDate: String?
    var dir_Name: String?
    var moviePlayer:MPMoviePlayerController!
    var audioPlayer: AVAudioPlayer?
    var isPlaying = Bool()
    var timer:Timer!
    var END_TIME = 2.0
    let queue = OperationQueue()
    var fullScreenBool = Bool()


    override func viewDidLoad()
    {
        super.viewDidLoad()

        //        popupview.layer.cornerRadius = 15
        //        popupview.layer.shadowColor = UIColor.black.cgColor
        //        popupview.layer.shadowOffset = CGSize(width: 0, height: 10)
        //        popupview.layer.shadowOpacity = 0.9
        //        popupview.layer.shadowRadius = 5

        // yesBtn.backgroundColor = .clear

        self.view.layer.cornerRadius = 10
        self.view.layer.borderWidth = 2
        self.view.layer.borderColor = UIColor.white.cgColor


        downlaodBtn.layer.cornerRadius = 10
        downlaodBtn.layer.borderWidth = 2
        downlaodBtn.layer.borderColor = UIColor.white.cgColor

        //noBtn.backgroundColor = .clear
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderWidth = 2
        cancelBtn.layer.borderColor = UIColor.white.cgColor


        setUI()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachStart(notification:)), name: .MPMoviePlayerWillEnterFullscreen, object:nil)
        
                NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(notification:)), name: .MPMoviePlayerWillExitFullscreen, object:nil)
        


        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.playAudioBtn.isHidden = true
      //  self.audioImage.isHidden = true
        audioImage.image = #imageLiteral(resourceName: "video_img")
        self.audioPlayer = nil
        isPlaying = false
        
        
//        if fullScreenBool {
//
//            if moviePlayer != nil
//            {
//                self.moviePlayer.stop()
//            }
//            self.moviePlayer = nil
//            queue.cancelAllOperations()
//
//
//        }
//
//        else {
//
//
//        }
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //blockOperatio.cancel()\
   
        if fullScreenBool {
        
        if moviePlayer != nil
        {
            self.moviePlayer.stop()
        }
        self.moviePlayer = nil
        queue.cancelAllOperations()
            
        }
        
        else {
            
            
        }
    }

    func setUI()
    {

        titleLabel.text = receivedFileName
        dateLabel.text = receivedDate
        dirNameLabel.text = dir_Name

        if let ext = MimeType(path:receivedFileName!).ext {

            if let mimeType = mimeTypes[ext]
            {


                if mimeType.hasPrefix("video")
                {
                    //self.activityIndicator.startAnimating()
                    self.playAudioBtn.isHidden = true
                    self.audioImage.isHidden = true
                    DispatchQueue.main.async {

                        let url = URL(string:self.receivedUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

                        self.moviePlayer = MPMoviePlayerController(contentURL: url as! URL)
                    // moviePlayer.view.frame = CGRect(x: 14.5, y: 32, width: 200, height: 150)
                       

                        self.moviePlayer.view.frame = CGRect(x: 0 , y: 0 , width: UIScreen.main.bounds.size.width - 69, height: self.displayView.frame.size.height)
                        self.moviePlayer.controlStyle = MPMovieControlStyle.embedded


                        self.displayView.addSubview(self.moviePlayer.view)
                        self.moviePlayer.isFullscreen = false
                        self.moviePlayer.shouldAutoplay = false
                       


                        
                    }

                }
                else if mimeType.hasPrefix("audio")
                {

                    self.playAudioBtn.isHidden = false
                    self.audioImage.isHidden = false
//                    self.activityIndicator.startAnimating()
//
                    displayView.backgroundColor = UIColor.gray
                    imgView.isHidden = true
                   // imgView.image = UIImage(named: "audioPlaceholder")
//
//                    let urlstring = receivedUrl
//                    let url = URL(string:urlstring!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//                    DispatchQueue.global(qos: .background).async {
//
//
//                        do
//                        {
//                            let data = try Data.init(contentsOf: url!)
//
//                            DispatchQueue.main.async {
//                                self.activityIndicator.stopAnimating()
//
//
//                                do {
//                                    //self.showActivityIndicatory()
//                                    //self.createSpinnerView()
//
//                                    self.audioPlayer = try AVAudioPlayer(data:data as Data )
//                                    self.audioPlayer?.prepareToPlay()
//                                    self.audioPlayer?.delegate = self
//
//                                    //                                    self.child.willMove(toParentViewController: nil)
//                                    //                                    self.child.view.removeFromSuperview()
//                                    //                                    self.child.removeFromParentViewController()
//
//
//                                    self.audioPlayer?.play()
//
//
//
//
//
//                                }
//                                catch _ {
//
//
//                                }
//                            }
//
//                        } catch {
//
//                        }
//
//                    }

                }

                else if mimeType.hasPrefix("image")
                {
                    self.playAudioBtn.isHidden = true
                    self.audioImage.isHidden = true
                    ImageView.isHidden = false
                    ImageView.sd_setImage(with: URL(string:receivedUrl!)) { (image, error, cache, url) in

                    }
                }

                else
                {
                    self.playAudioBtn.isHidden = true
                    self.audioImage.isHidden = true
                    ImageView.isHidden = false
                    ImageView.image = #imageLiteral(resourceName: "attachment")
                    ImageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }

                
            }
            else
            {
                self.playAudioBtn.isHidden = true
                self.audioImage.isHidden = true
                ImageView.isHidden = false
                ImageView.image = #imageLiteral(resourceName: "attachment")
                ImageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }


    }
    
    
    
    @objc func playerItemDidReachStart(notification: Notification?) {
        
        fullScreenBool = false
        
    }

    
    @objc func playerItemDidReachEnd(notification: Notification?) {
        
        fullScreenBool = true
      
    }
    

    //MARK:-
    //MARK:- IBAction Methods

    @IBAction func downlaodButtonAction(_ sender: Any)
    {
        downloadFiles()
       // self.yesAcion!()

    }

    @IBAction func cancelButtonAction(_ sender: Any)
    {


        //queue.resume()

//        if let ext = MimeType(path:receivedFileName!).ext {
//
//            if let mimeType = mimeTypes[ext]
//            {
//
//
//                if mimeType.hasPrefix("audio")
//                {
//                    self.activityIndicator.stopAnimating()
//                    let urlstring = receivedUrl
//                    let url = URL(string:urlstring!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//                    do{
//                        //var error:NSError?
//                        self.audioPlayer = try AVAudioPlayer(contentsOf: url!)
//                        self.audioPlayer?.stop()
//                        self.audioPlayer = nil
//                    }
//
//                    catch{
//
//                    }
//                }
//            }
//        }
        self.audioPlayer?.stop()
        self.audioPlayer = nil
        if moviePlayer != nil
        {
            self.moviePlayer.stop()
        }
        self.moviePlayer = nil
        self.noAction!()
      //  blockOperatio.cancel()

         queue.cancelAllOperations()
         print(queue.operations.count)
    }



    @IBAction func playAudioButtonAction(_ sender: Any) {

        if !isPlaying {
            isPlaying = true
            audioImage.image = #imageLiteral(resourceName: "grayPause")
           self.playAudioBtn.isEnabled = false
            playAudio()
        }
        else {
            audioImage.image = #imageLiteral(resourceName: "video_img")
            self.audioPlayer?.stop()
            self.audioPlayer = nil
            isPlaying = false
        }


    }
    
    
    
    

    func playAudio()
    {
        self.activityIndicator.startAnimating()

//        displayView.backgroundColor = UIColor.gray
//        imgView.isHidden = false
//        imgView.image = UIImage(named: "audioPlaceholder")

        let urlstring = receivedUrl
        let url = URL(string:urlstring!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let blockOperatio = BlockOperation ()
        blockOperatio.addExecutionBlock ({

            do
            {
               // let audioSession = AVAudioSession.sharedInstance()

                let data = try Data.init(contentsOf: url!)

              print(blockOperatio.isCancelled)
                if blockOperatio.isCancelled {


                    return
                }
                OperationQueue.main.addOperation {



                self.activityIndicator.stopAnimating()
                    self.playAudioBtn.isEnabled = true

                    if  (UIApplication.topViewController() as?  PopupDialog) != nil {
                        if let ext = MimeType(path:self.receivedFileName!).ext {

                            if let mimeType = mimeTypes[ext]
                        {

                            if mimeType.hasPrefix("audio"){
                    do {
                        //self.showActivityIndicatory()
                        //self.createSpinnerView()

                        self.audioPlayer = try AVAudioPlayer(data:data as Data )
                        self.audioPlayer?.prepareToPlay()
                        self.audioPlayer?.delegate = self

                        //                                    self.child.willMove(toParentViewController: nil)
                        //                                    self.child.view.removeFromSuperview()
                        //                                    self.child.removeFromParentViewController()


                        self.audioPlayer?.play()





                    }
                    catch _ {


                    }
                            }
                            }
                        }

                }
                }

            } catch {

            }



        })
        queue.addOperation(blockOperatio)

    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playAudioBtn.isHidden = false
        self.audioImage.isHidden = false
        audioImage.image = #imageLiteral(resourceName: "video_img")
        isPlaying = false
        self.audioPlayer?.stop()
       // checkTime()
        self.audioPlayer = nil
    }

    @objc func checkTime() {
//        print(audioPlayer?.currentTime)
//        if (self.audioPlayer?.currentTime)! >= END_TIME {
            self.audioPlayer?.stop()
            timer.invalidate()
        //}
    }



    func documentsPathForFileName(name: String) -> URL? {
        let fileMgr = FileManager.default

        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        let fileURL = dirPaths[0].appendingPathComponent(name)
        return fileURL
    }

    func downloadPopup() {

        let alertVC :DownloadingPopup = (self.storyboard?.instantiateViewController(withIdentifier: "DownloadingPopup") as? DownloadingPopup)!
        let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
        , tapGestureDismissal: false, panGestureDismissal: false) {
            let overlayAppearance = PopupDialogOverlayView.appearance()
            overlayAppearance.blurRadius  = 30
            overlayAppearance.blurEnabled = true
            overlayAppearance.liveBlur    = false
            overlayAppearance.opacity     = 0.4
        }
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
    }


func downloadFiles()
{

   self.audioPlayer?.stop()
    //self.audioPlayer?.currentTime = 0

        //checkTime()
        self.audioPlayer = nil
    self.audioPlayer = nil
    if moviePlayer != nil
    {
      self.moviePlayer.stop()
    }

    //blockOperatio.cancel()
    queue.cancelAllOperations()

    if ProjectManager.sharedInstance.isInternetAvailable() {

        self.downloadPopup()
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {
            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as! String
            let headers = [
                "Authorization": token_type + accessToken,
                "Accept": "application/json"
            ]

            let fileUrl = receivedUrl // /\(obj.UserID)
            Alamofire.request(fileUrl!, headers:headers).downloadProgress { (progress) in
                NotificationCenter.default.post(name:.downloadProgress, object:progress )
                print(progress.fractionCompleted)
                }.responseData { (data) in

                    if let contentType = data.response?.allHeaderFields["Content-Type"] as? String {
                        print("contentType ***** \(contentType)")
                        if contentType.hasPrefix("image") {
                            if UIImage(data:data.data ?? Data() ) != nil {
                                UIImageWriteToSavedPhotosAlbum(UIImage(data:data.data!)!, nil, nil, nil)
                                self.yesAcion!()
                            }
                        }
                        else if contentType.hasPrefix("video") {
                            let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + "\(self.receivedFileName!)")
                            do {

                                try data.data?.write(to:filePath!)
                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: filePath!)
                                }) { saved, error in
                                    if saved {

                                               self.yesAcion!()
                                    }
                                }
                            }
                            catch {


                            }

                        }
                        else if contentType.hasPrefix("audio") {
                            let filePath = self.documentsPathForFileName(name:"\(Date().ticks)" + "\(self.receivedFileName!)")
                            do {

                                try data.data?.write(to:filePath!)
                                self.yesAcion!()

                            }
                            catch {


                            }

                        }
                        else {
                            let filePath = self.documentsPathForFileName(name:"\(Date().ticks)" + "\(self.receivedFileName!)")
                            do {

                                try data.data?.write(to:filePath!)                                
                                self.yesAcion!()
                            }
                            catch {


                            }



                        }

                    }

            }
        }
    }
    else {
        ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)

    }

    }




//    func showActivityIndicatory()
//    {
//        let container: UIView = UIView()
//        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
//        container.backgroundColor = .clear
//
//        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
//        activityIndicator.center = self.displayView.center
//        //activityIndicator.startAnimating()
//
//
//        container.addSubview(activityIndicator)
//        self.displayView.addSubview(container)
//        activityIndicator.startAnimating()
//    }


//    func createSpinnerView() {
//          child = DownloadFilesPopup()
//
//        // add the spinner view controller
//        addChildViewController(child)
//        child.view.frame = view.frame
//        view.addSubview(child.view)
//        child.didMove(toParentViewController: self)
//
//        // wait two seconds to simulate some work happening
////        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
////            // then remove the spinner view controller
//////            child.willMove(toParentViewController: nil)
//////            child.view.removeFromSuperview()
//////            child.removeFromParentViewController()
////        }
//    }



    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}

