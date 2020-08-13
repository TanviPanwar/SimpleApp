//
//  NumberOfQuestionsViewController.swift
//  LoopLeap
//
//  Created by IOS2 on 12/20/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import AssetsPickerViewController
import Photos
import PopupDialog
import IQKeyboardManagerSwift
import AVFoundation
import AVKit
import MediaPlayer




class NumberOfQuestionsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AudioDelegate
{
    func didFindAudioFile(found: URL) {
        print(found)
        audioUrl = found
        audioUrl = found
        do{
            guard self.audioUrl != nil  else {return}
            
            self.recordedData = try Data(contentsOf: self.audioUrl!)
            
        }
        catch {
            
            
        }
        self.previewView.isHidden = false
        self.clickToSeePreviewBtn.setTitle("Audio Recorded, Click to listen", for: .normal)
        self.previewLabel.text = "Note: Re-record to chnage current recorded message "
        updateUI()


    }


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "sendSpySegue" {
//            let vc : RecorderViewController = segue.destination as! RecorderViewController
//            vc.delegate = self
//        }
//    }


    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
    @IBOutlet weak var totalQuestionNumberLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var displayedQuestionNumberLabel: UILabel!
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
    @IBOutlet weak var clickToSeePreviewBtn: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var previewLabel: UILabel!


    
    
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    var parameters = [String:Any]()

    var controller = UIImagePickerController()
    let videoFileName = "/video.mp4"
    var videoURL : URL?
    var question_id1 = Int()
    var valueSent: Bool = true
    var audioUrl: URL?
    var recordedData: Data?
    var index = Int()
    var assets = [PHAsset]()
    var hasMoreAnswers = Int()
    var totalquestions = Int()
    var pageNumber: Int = 1
    var saveBool: Bool = true
    var prevBool = Bool()
    var audioPlayer: AVAudioPlayer?
    var moviePlayer:MPMoviePlayerController!




    override func viewDidLoad()
    {
        super.viewDidLoad()
          setUI()
        getApi(pageNum: pageNumber)
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

        saveBtn.layer.cornerRadius = 20
        saveBtn.clipsToBounds = true
        saveBtn.layer.borderWidth = 1
        saveBtn.layer.borderColor = UIColor.clear.cgColor


        nextBtn.layer.cornerRadius = 20
        nextBtn.clipsToBounds = true
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = UIColor.clear.cgColor

        prevBtn.layer.cornerRadius = 20
        prevBtn.clipsToBounds = true
        prevBtn.layer.borderWidth = 1
        prevBtn.layer.borderColor = UIColor.clear.cgColor


        recordAudioBtn.layer.cornerRadius = 20
        recordAudioBtn.clipsToBounds = true
        recordAudioBtn.layer.borderWidth = 1
        recordAudioBtn.layer.borderColor = UIColor.clear.cgColor


        //        textAnswerTextView.text = "Your answer..."
        //        textAnswerTextView.textColor = UIColor.lightGray
        //        textAnswerTextView.becomeFirstResponder()
        //        textAnswerTextView.selectedTextRange = textAnswerTextView.textRange(from: textAnswerTextView.beginningOfDocument, to: textAnswerTextView.beginningOfDocument)

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


//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // 1
//        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
//            // Save video to the main photo album
//            let selectorToCall = #selector(NumberOfQuestionsViewController.videoSaved(_:didFinishSavingWithError:context:))
//
//            // 2
//            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
//            // Save the video to the app directory
//            let videoData = try? Data(contentsOf: selectedVideo)
//            let paths = NSSearchPathForDirectoriesInDomains(
//                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
//            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
//            try! videoData?.write(to: dataPath, options: [])
//        }
//        // 3
//        picker.dismiss(animated: true)
//    }
//
//    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
//        if let theError = error {
//            print("error saving the video = \(theError)")
//        } else {
//            DispatchQueue.main.async(execute: { () -> Void in
//            })
//        }
//    }


    

    //MARK:-
    //MARK:- IBAction Methods
    
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        
        
        self.dismiss(animated: true, completion: nil)
      // self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func audioImageButtonAction(_ sender: Any)
    {
        
        self.textAnswerTextView.text = nil
        self.audioUrl = nil
        self.videoURL = nil
     
       // changeRadioBtnImg(tagValue: recordAudioRadioBtn.tag)
        self.previewView.isHidden = true
        audioImage.image = UIImage(named: "radioFill-btn")
        videoImage.image = UIImage(named: "radio-Btn")
        textImage.image = UIImage(named: "radio-Btn")
            
       

        
        
//        self.recordAudioBtn.transform = CGAffineTransform(translationX: 0, y: 0.0)
//
//        let btn = UIButton(frame: CGRect(x: 21, y: 87, width: self.recordAudioBtn.frame.size.width, height: self.recordAudioBtn.frame.size.height))
//
//        recordAudioBtn = btn
        recordAudioBtn.isHidden = false
        textAnswerTextView.isHidden = true
        recordAudioBtn.isHidden = false

        recordAudioBtn.setTitle("Record Audio",for: .normal)

        self.answerlabel.translatesAutoresizingMaskIntoConstraints = true
        self.recordAudioBtn.translatesAutoresizingMaskIntoConstraints = true
        self.selectionView.translatesAutoresizingMaskIntoConstraints = true
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
        self.nextBtn.translatesAutoresizingMaskIntoConstraints = true




        answerlabel.frame = CGRect(x: answerlabel.frame.origin.x , y: answerlabel.frame.origin.y, width: answerlabel.frame.size.width, height: answerlabel.frame.size.height)

        recordAudioBtn.frame = CGRect(x: recordAudioBtn.frame.origin.x , y:answerlabel.frame.origin.y + answerlabel.frame.size.height + 20  , width: recordAudioBtn.frame.size.width, height: recordAudioBtn.frame.size.height) //recordAudioBtn.frame.origin.y - 10

//       previewView.frame = CGRect(x: previewView.frame.origin.x , y:recordAudioBtn.frame.origin.y + recordAudioBtn.frame.size.height + 20  , width: previewView.frame.size.width, height: previewView.frame.size.height)
//
//        selectionView.frame = CGRect(x: selectionView.frame.origin.x , y: previewView.frame.origin.y + previewView.frame.size.height + 20, width: selectionView.frame.size.width, height: selectionView.frame.size.height)

        selectionView.frame = CGRect(x: selectionView.frame.origin.x , y: recordAudioBtn.frame.origin.y + recordAudioBtn.frame.size.height + 20, width: selectionView.frame.size.width, height: selectionView.frame.size.height)

        if  pageNumber > 1   //saveBool == true
        {
            saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)

            nextBtn.frame = CGRect(x: nextBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)

            prevBtn.frame = CGRect(x: prevBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)
        }

        else  //if pageNumber > 1
        {

//        saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: saveBtn.frame.size.width, height: saveBtn.frame.size.height)
//
//        nextBtn.frame = CGRect(x: nextBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: nextBtn.frame.size.width, height: nextBtn.frame.size.height)
            
            saveBtn.frame = CGRect(x: 33.67 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: saveBtn.frame.size.height)
            
            nextBtn.frame = CGRect(x: saveBtn.frame.origin.x + saveBtn.frame.size.width + 11 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: nextBtn.frame.size.height)
            
            self.prevBtn.isHidden = true


        }

        if hasMoreAnswers == 0 && pageNumber == 1
        {
//            nextBtn.isHidden = true
//            prevBtn.isHidden = true

            self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
            saveBtn.frame = CGRect(x: 8, y: saveBtn.frame.origin.y , width: answerView.frame.size.width - 16, height: saveBtn.frame.size.height )

        }

    }

    func updateUI()
    {
        print("pagenumber is:", pageNumber)

        self.answerlabel.translatesAutoresizingMaskIntoConstraints = true
        self.recordAudioBtn.translatesAutoresizingMaskIntoConstraints = true
        self.selectionView.translatesAutoresizingMaskIntoConstraints = true
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
        self.nextBtn.translatesAutoresizingMaskIntoConstraints = true
        self.prevBtn.translatesAutoresizingMaskIntoConstraints = true





        answerlabel.frame = CGRect(x: answerlabel.frame.origin.x , y: answerlabel.frame.origin.y, width: answerlabel.frame.size.width, height: answerlabel.frame.size.height)

        recordAudioBtn.frame = CGRect(x: recordAudioBtn.frame.origin.x , y:answerlabel.frame.origin.y + answerlabel.frame.size.height + 20  , width: recordAudioBtn.frame.size.width, height: recordAudioBtn.frame.size.height) //recordAudioBtn.frame.origin.y - 10

        previewView.frame = CGRect(x: previewView.frame.origin.x , y:recordAudioBtn.frame.origin.y + recordAudioBtn.frame.size.height + 20  , width: previewView.frame.size.width, height: previewView.frame.size.height)

        selectionView.frame = CGRect(x: selectionView.frame.origin.x , y: previewView.frame.origin.y + previewView.frame.size.height + 20, width: selectionView.frame.size.width, height: selectionView.frame.size.height)

        //        selectionView.frame = CGRect(x: selectionView.frame.origin.x , y: recordAudioBtn.frame.origin.y + recordAudioBtn.frame.size.height + 20, width: selectionView.frame.size.width, height: selectionView.frame.size.height)

        if pageNumber > 1 
        {
            saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)

            nextBtn.frame = CGRect(x: nextBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)

            prevBtn.frame = CGRect(x: prevBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)
        }

        else
        {


            saveBtn.frame = CGRect(x: 33.67 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: saveBtn.frame.size.height)

            nextBtn.frame = CGRect(x: saveBtn.frame.origin.x + saveBtn.frame.size.width + 11 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: nextBtn.frame.size.height)

            self.prevBtn.isHidden = true



        }

        if hasMoreAnswers == 0 && pageNumber == 1
        {
            //            nextBtn.isHidden = true
            //            prevBtn.isHidden = true

            self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
            saveBtn.frame = CGRect(x: 8, y: saveBtn.frame.origin.y , width: answerView.frame.size.width - 16, height: saveBtn.frame.size.height )

        }

    }

    func reupdateUI()
    {
        print("pagenumber is:", pageNumber)

        self.previewView.isHidden = true
        self.answerlabel.translatesAutoresizingMaskIntoConstraints = true
        self.recordAudioBtn.translatesAutoresizingMaskIntoConstraints = true
        self.selectionView.translatesAutoresizingMaskIntoConstraints = true
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
        self.nextBtn.translatesAutoresizingMaskIntoConstraints = true

        answerlabel.frame = CGRect(x: answerlabel.frame.origin.x , y: answerlabel.frame.origin.y, width: answerlabel.frame.size.width, height: answerlabel.frame.size.height)

        recordAudioBtn.frame = CGRect(x: recordAudioBtn.frame.origin.x , y:answerlabel.frame.origin.y + answerlabel.frame.size.height + 20  , width: recordAudioBtn.frame.size.width, height: recordAudioBtn.frame.size.height) //recordAudioBtn.frame.origin.y - 10

//        previewView.frame = CGRect(x: previewView.frame.origin.x , y:recordAudioBtn.frame.origin.y + recordAudioBtn.frame.size.height + 20  , width: previewView.frame.size.width, height: previewView.frame.size.height)

        selectionView.frame = CGRect(x: selectionView.frame.origin.x , y: recordAudioBtn.frame.origin.y + recordAudioBtn.frame.size.height + 20, width: selectionView.frame.size.width, height: selectionView.frame.size.height)

        //        selectionView.frame = CGRect(x: selectionView.frame.origin.x , y: recordAudioBtn.frame.origin.y + recordAudioBtn.frame.size.height + 20, width: selectionView.frame.size.width, height: selectionView.frame.size.height)

        if pageNumber > 1
        {
            saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)

            nextBtn.frame = CGRect(x: nextBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)

            prevBtn.frame = CGRect(x: prevBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)
        }

        else
        {

//            saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: saveBtn.frame.size.width, height: saveBtn.frame.size.height)
//
//            nextBtn.frame = CGRect(x: nextBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: nextBtn.frame.size.width, height: nextBtn.frame.size.height)
//
            
            saveBtn.frame = CGRect(x: 33.67 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: saveBtn.frame.size.height)
            
            nextBtn.frame = CGRect(x: saveBtn.frame.origin.x + saveBtn.frame.size.width + 11 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: nextBtn.frame.size.height)

            self.prevBtn.isHidden = true

        }

        if hasMoreAnswers == 0 && pageNumber == 1
        {
            //            nextBtn.isHidden = true
            //            prevBtn.isHidden = true

            self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
            saveBtn.frame = CGRect(x: 8, y: saveBtn.frame.origin.y , width: answerView.frame.size.width - 16, height: saveBtn.frame.size.height )

        }

    }
    
    @IBAction func videoImageButtonAction(_ sender: Any)
    {
        
        self.textAnswerTextView.text = nil
        self.audioUrl = nil
        self.videoURL = nil
        //changeRadioBtnImg(tagValue: recordVideoRadioBtn.tag)
        self.previewView.isHidden = true

        audioImage.image = UIImage(named: "radio-Btn")
        videoImage.image = UIImage(named: "radioFill-btn")
        textImage.image = UIImage(named: "radio-Btn")
    


        recordAudioBtn.isHidden = false
        textAnswerTextView.isHidden = true
        textAnswerTextView.isHidden = true
        recordAudioBtn.setTitle("Record Video",for: .normal)


       self.answerlabel.translatesAutoresizingMaskIntoConstraints = true
       self.recordAudioBtn.translatesAutoresizingMaskIntoConstraints = true
       self.selectionView.translatesAutoresizingMaskIntoConstraints = true
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
        self.nextBtn.translatesAutoresizingMaskIntoConstraints = true


         answerlabel.frame = CGRect(x: answerlabel.frame.origin.x , y: answerlabel.frame.origin.y, width: answerlabel.frame.size.width, height: answerlabel.frame.size.height)

        recordAudioBtn.frame = CGRect(x: recordAudioBtn.frame.origin.x , y:answerlabel.frame.origin.y + answerlabel.frame.size.height + 20  , width: recordAudioBtn.frame.size.width, height: recordAudioBtn.frame.size.height) //recordAudioBtn.frame.origin.y - 10

//        previewView.frame = CGRect(x: previewView.frame.origin.x , y:recordAudioBtn.frame.origin.y + recordAudioBtn.frame.size.height + 20  , width: previewView.frame.size.width, height: previewView.frame.size.height)
//
//        selectionView.frame = CGRect(x: selectionView.frame.origin.x , y: previewView.frame.origin.y + previewView.frame.size.height + 20, width: selectionView.frame.size.width, height: selectionView.frame.size.height)

        selectionView.frame = CGRect(x: selectionView.frame.origin.x , y: recordAudioBtn.frame.origin.y + recordAudioBtn.frame.size.height + 20, width: selectionView.frame.size.width, height: selectionView.frame.size.height)

        if pageNumber > 1
        {
            saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)

            nextBtn.frame = CGRect(x: nextBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)

            prevBtn.frame = CGRect(x: prevBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)
        }
        else
        {

//        saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: saveBtn.frame.size.width, height: saveBtn.frame.size.height)
//
//        nextBtn.frame = CGRect(x: nextBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: nextBtn.frame.size.width, height: nextBtn.frame.size.height)
            
            saveBtn.frame = CGRect(x: 33.67 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: saveBtn.frame.size.height)
            
            nextBtn.frame = CGRect(x: saveBtn.frame.origin.x + saveBtn.frame.size.width + 11 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: nextBtn.frame.size.height)
            
            self.prevBtn.isHidden = true

        }

        if hasMoreAnswers == 0 && pageNumber == 1
        {
//            nextBtn.isHidden = true
//            prevBtn.isHidden = true

            self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
            saveBtn.frame = CGRect(x: 8, y: saveBtn.frame.origin.y , width: answerView.frame.size.width - 16, height: saveBtn.frame.size.height )

        }


    }
    
    @IBAction func textImageButtonAction(_ sender: Any)
    {
        
        self.textAnswerTextView.text = nil
        self.audioUrl = nil
        self.videoURL = nil
       // changeRadioBtnImg(tagValue: writeTextRadioBtn.tag)
        self.previewView.isHidden = true
        audioImage.image = UIImage(named: "radio-Btn")
        videoImage.image = UIImage(named: "radio-Btn")
        textImage.image = UIImage(named: "radioFill-btn")
        
      

        self.answerlabel.translatesAutoresizingMaskIntoConstraints = true
        //self.recordAudioBtn.translatesAutoresizingMaskIntoConstraints = true
        self.selectionView.translatesAutoresizingMaskIntoConstraints = true
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
        self.nextBtn.translatesAutoresizingMaskIntoConstraints = true


        answerlabel.frame = CGRect(x: answerlabel.frame.origin.x , y: answerlabel.frame.origin.y, width: answerlabel.frame.size.width, height: answerlabel.frame.size.height)


        selectionView.frame = CGRect(x: selectionView.frame.origin.x , y: textAnswerTextView.frame.origin.y + textAnswerTextView.frame.size.height + 10, width: selectionView.frame.size.width, height: selectionView.frame.size.height)

        if pageNumber > 1 //saveBool == true
        {
            saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)

            nextBtn.frame = CGRect(x: nextBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)

            prevBtn.frame = CGRect(x: prevBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: prevBtn.frame.size.width, height: prevBtn.frame.size.height)
        }

        else
        {

//        saveBtn.frame = CGRect(x: saveBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: saveBtn.frame.size.width, height: saveBtn.frame.size.height)
//
//        nextBtn.frame = CGRect(x: nextBtn.frame.origin.x , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: nextBtn.frame.size.width, height: nextBtn.frame.size.height)

            
            
            saveBtn.frame = CGRect(x: 33.67 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: saveBtn.frame.size.height)
            
            nextBtn.frame = CGRect(x: saveBtn.frame.origin.x + saveBtn.frame.size.width + 11 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: nextBtn.frame.size.height)
            
            self.prevBtn.isHidden = true

        }

        if hasMoreAnswers == 0 && pageNumber == 1
        {
//            nextBtn.isHidden = true
//            prevBtn.isHidden = true

            self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
            saveBtn.frame = CGRect(x: 8, y: saveBtn.frame.origin.y , width: answerView.frame.size.width - 16, height: saveBtn.frame.size.height )

        }

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

        

//        let todoEndpoint: String = "http://18.220.137.253/ResuseMe/ApiV1/register"
//
//        self.parameters = ["full_name":"Test User","email":"test12345@mailinator.com","country_code":"91", "phone":"9999911111", "password":"Flash007", "confirm_password": "Flash007"]
//
//
//    Alamofire.request(todoEndpoint, method: .post, parameters: parameters )
//    .responseString { response in
//    // check for errors
//    guard response.result.error == nil else {
//    // got an error in getting the data, need to handle it
//    print("error calling GET on /todos/1")
//    print(response.result.error!)
//    return
//    }
//
//    // make sure we got some JSON since that's what we expect
//    guard let json = response.result.value as? [String: Any] else {
//    print("didn't get todo object as JSON from API")
//    if let error = response.result.error {
//    print("Error: \(error)")
//    }
//    return
//    }
//
//    print(json)
//
//
//    }
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
    
    @IBAction func prevButtonAction(_ sender: Any)
    {
        
        self.textAnswerTextView.text = nil
        self.audioUrl = nil
        self.videoURL = nil

        if self.previewView.isHidden == false {
            self.recordedData = nil
            self.reupdateUI()
        }
        
        if prevBool == true
        {
            if pageNumber == 0
            {

            }
            else
            {
                getApi(pageNum: pageNumber - 1)
                pageNumber -= 1
               
            }
        }
        
    }
    
    @IBAction func nextButtonAction(_ sender: Any)
    {
       
        
        let answertxt:String = (textAnswerTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        
        if !answertxt.isEmpty || self.audioUrl != nil || self.videoURL != nil {

            let alert = UIAlertController(title:"Are you sure?", message: "Your answer will not saved.", preferredStyle: .alert)

            let okAction = UIAlertAction(title:"OK"
            , style: .default) { (action) in
                self.prevBool = true

//                if self.previewView.isHidden == true {
//                       self.reupdateUI()
//                }

                if self.previewView.isHidden == false {
                    self.recordedData = nil
                    self.reupdateUI()
                }
                if self.pageNumber == self.totalquestions {
                
                    
                } else {
                    
                   self.getApi(pageNum: self.pageNumber + 1)
                     self.pageNumber += 1
                    
                }
                
                
            }
            let cancel = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)

           alert.addAction(cancel)
            alert.addAction(okAction)


            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        } else {
         prevBool = true
//        if saveBool == true
//        {
            if self.pageNumber == self.totalquestions {
                
                
            } else {
               
                self.getApi(pageNum: self.pageNumber + 1)
                 self.pageNumber += 1
            }
//            getApi(pageNum: pageNumber + 1)
//            pageNumber += 1
//        }
//
//        else
//        {
//             getApi(pageNum: pageNumber)
//        }
        }
    }
    
    @IBAction func ssaveButtonAction(_ sender: Any)
    {
        saveBool = false
        //let todoEndpoint: String = "http://dev.loopleap.com/api/savequestion"
        //let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.userID) as! String

        let text:String = (textAnswerTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        if self.audioUrl != nil || self.videoURL != nil || text != ""
        {


            if textImage.image == UIImage(named: "radioFill-btn") && !text.isEmpty
            {

                self.parameters = ["question_id":self.question_id1,"answer":text, "answer_by":"write", "video-blob": ""]
            }

            if audioImage.image == UIImage(named: "radioFill-btn") && self.audioUrl != nil
            {

                self.parameters = ["question_id":self.question_id1,"answer":"", "answer_by":"record"]

            }

            if videoImage.image == UIImage(named: "radioFill-btn") && self.videoURL != nil
            {

                self.parameters = ["question_id":self.question_id1,"answer":"", "answer_by":"record"]
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


                    if ProjectManager.sharedInstance.isInternetAvailable()
                    {
                        //ProjectManager.sharedInstance.showLoader()
                


                //var audiodata1 = Data()

                if audioImage.image == UIImage(named: "radioFill-btn") && self.audioUrl != nil
                {
                    //recordedData = try Data(contentsOf: self.audioUrl!)
                    print(self.recordedData!)
                }

                else if videoImage.image == UIImage(named: "radioFill-btn") && self.videoURL != nil
                {
                    recordedData = try Data(contentsOf: self.videoURL!)
                }
                //let parametr = ["user_id":"6","question_id":"4","answer":"", "answer_by":"record"]


//                if self.assets.count > 0{
//
//                    if self.index < assets.count {
                       // let asset = self.assets[self.index]
                        if audioImage.image == UIImage(named: "radioFill-btn")  && self.audioUrl != nil   //asset.mediaType == .audio
                        {
                            ProjectManager.sharedInstance.showLoader()


                            Alamofire.upload(multipartFormData: { (multipartFormData) in

                                multipartFormData.append(self.recordedData ?? Data(), withName: "video-blob", fileName:  "\(Date().ticks).m4a", mimeType: "audio")
                                for (key, value) in self.parameters {
                                    // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)

                                }
                            }, to:baseURL + ApiMethods.savequestion, headers:headers)
                            { (result) in
                               //ProjectManager.sharedInstance.stopLoader()

                                switch result {


                                case .success(let upload, _, _):


                                    upload.responseJSON { response in
                                        print(response)
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
                                            self.textAnswerTextView.text = ""
                                            self.recordedData = nil
                                            print(response.result.value)
                                            self.audioUrl = nil
                                            self.previewView.isHidden = true
                                            self.reupdateUI()
                                         
                                            //self.previewLabel.isHidden = true
                                            if self.hasMoreAnswers == 0 {
                                            
                                            self.pageNumber = 1
                                            self.getApi(pageNum: self.pageNumber)

                                                
                                            }
                                            
                                            else {
                                                
                                                self.getApi(pageNum: self.pageNumber)

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
                            ProjectManager.sharedInstance.showLoader()


                            Alamofire.upload(multipartFormData: { (multipartFormData) in

                                multipartFormData.append(self.recordedData ?? Data(), withName: "video-blob", fileName: "\(Date().ticks).mp4", mimeType: "video/mp4")
                                for (key, value) in self.parameters {
                                    // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)

                                }
                            }, to:baseURL + ApiMethods.savequestion, headers:headers)
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
                                            self.videoURL = nil
                                            self.previewView.isHidden = true
                                            self.textAnswerTextView.text = ""
                                            self.reupdateUI()
                                            if self.hasMoreAnswers == 0 {
                                                
                                                self.pageNumber = 1
                                                self.getApi(pageNum: self.pageNumber)
                                                
                                                
                                            }
                                                
                                            else {
                                                
                                                self.getApi(pageNum: self.pageNumber)
                                                
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

             else if textImage.image == UIImage(named: "radioFill-btn") && !text.isEmpty
                        {
                            ProjectManager.sharedInstance.showLoader()



                            Alamofire.request(baseURL + ApiMethods.savequestion, method: .post,  parameters: self.parameters, encoding: JSONEncoding.default, headers:headers)
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
                                    self.textAnswerTextView.text = nil

                                    if self.hasMoreAnswers == 0 {
                                        
                                        self.pageNumber = 1
                                        self.getApi(pageNum: self.pageNumber)
                                        
                                        
                                    }
                                        
                                    else {
                                        
                                        self.getApi(pageNum: self.pageNumber)
                                        
                                    }

                                    // get and print the title

                                    //                guard let data = json["data"] as? [String:Any] else {
                                    //                    print("Could not get question from JSON")
                                    //                    return
                                    //                }
                                    //                print(data)
                            }
                }
                   // }
                //}
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

            //        Alamofire.upload(multipartFormData: { data in
            //            if let audiodata1 = try Data(contentsOf: self.audioUrl!) {
            //            data.append(audiodata1, withName: "video-blob", fileName:  "file.mp4", mimeType: "audio")
            //            }
            //
            //            for (key, value) in self.parameters {
            //                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            //            }}, to: "upload_url", method: .post, headers: ["Authorization": "auth_token"],
            //                encodingCompletion: { encodingResult in
            //                    switch encodingResult {
            //                    case .success(let upload, _, _):
            //                        upload.response { [weak self] response in
            //                            guard let strongSelf = self else {
            //                                return
            //                            }
            //                            debugPrint(response)
            //                        }
            //                    case .failure(let encodingError):
            //                        print("error:\(encodingError)")
            //                    }
            //        })



        }
        
     else
        {
            saveBool = true

            let alert = UIAlertController(title: "Error", message: "Please Select one answer.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }



    }
    
    func changeRadioBtnImg(tagValue:Int)
    {
        
            
            if (self.audioImage.image == UIImage(named: "radio-Btn"))
            {
                audioImage.image = UIImage(named: "radioFill-btn")
            }
            else //if (self.audioImage.image == UIImage(named: "radioFill-btn"))
            {
                audioImage.image = UIImage(named: "radio-Btn")
            }
         
       
            
            if (self.videoImage.image == UIImage(named: "radio-Btn"))
            {
                videoImage.image = UIImage(named: "radioFill-btn")
            }
            else //if (self.videoImage.image == UIImage(named: "radioFill-btn"))
            {
                videoImage.image = UIImage(named: "radio-Btn")
            }
       
        
        
            if (self.textImage.image == UIImage(named: "radio-Btn"))
            {
                textImage.image = UIImage(named: "radioFill-btn")
            }
                
            else //if (self.textImage.image == UIImage(named: "radioFill-btn"))
            {
                textImage.image = UIImage(named: "radio-Btn")
            }
        
        
    }

    //MARK:-
    //MARK:- API Calls


    func getApi(pageNum: Int)
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
            Alamofire.request(baseURL + ApiMethods.getquestion + "page=\(pageNum)" , headers:headers)
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


                    // get and print the title


                    //            let data1 = json["data"]  as? [String:Any]
                    //            self.question_id1 = data1!["question_id"] as! Int
                    //            print(data1)
                    //            print(self.question_id1)


                    let status = json["status"] as? Bool
                    if  !status!

                    {

                        print(status)


                    }



                    guard let data = json["data"] as? [String:Any] else {
                        print("Could not get question from JSON")
                        return
                    }
                    print(data)

                    guard let question = data["question"] as? String else {
                        print("Could not get question from JSON")
                        return
                    }
                    print("The question is: " + question)

                    guard  let qusId = data["question_id"] as? Int else {
                        print("Could not get question_id from JSON")
                        return
                    }
                    print(qusId)
                    self.question_id1 = qusId


                    guard let answeredStatus = data["answered"] as? Int else {
                        print("Could not get answeredStatus from JSON")
                        return
                    }
                    print(answeredStatus)

                    guard let hasMore = data["hasmorepages"] as? Int else {
                        print("Could not get answeredStatus from JSON")
                        return
                    }
                    print(hasMore)
                    self.hasMoreAnswers = hasMore

                    guard let totalquestions = data["totalquestions"] as? Int else {
                        print("Could not get answeredStatus from JSON")
                        return
                    }
                    print(totalquestions)
                    self.totalquestions = totalquestions
                   
                    guard let statusCode = json["statusCode"] as? Int else {return}
                    
                    if statusCode == 1 {
                        
                        
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
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            })
                            
                            
                        }
                        
                        alertVC.yesAcion = {
                            
                            popup.dismiss({
                                
                                let vc:TellAboutYourselfViewController = self.storyboard?.instantiateViewController(withIdentifier:"TellAboutYourselfViewController") as! TellAboutYourselfViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                
                            })
                        }
                        
                        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                        
                        
                    } else {
                        
                        self.textAnswerTextView.text = nil
                        self.audioUrl = nil
                        self.videoURL = nil
                        self.setUI(questionText: question,answeredStatus:answeredStatus, totalQues: totalquestions)
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
    
    func setUI(questionText: String,answeredStatus:Int, totalQues: Int )
    {
        
        print("pagenumber is:", pageNumber)
        questionTextView.text = questionText
        currentQuestionNumberLabel.text = "(" + String(answeredStatus) + "/"
        totalQuestionNumberLabel.text = String(totalQues) + ")"
        textAnswerTextView.text = ""
        
        //        if hasMoreAnswers == 0
        //        {
        //            nextBtn.isHidden = true
        //            prevBtn.isHidden = true
        //
        //            self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
        //            saveBtn.frame = CGRect(x: 8, y: saveBtn.frame.origin.y , width: answerView.frame.size.width - 16, height: saveBtn.frame.size.height )
        //
        //        }
        
        
         if  pageNumber > 1 && hasMoreAnswers == 0 {
            
            self.prevBtn.isHidden = false

            saveBtn.frame = CGRect(x: 33.67 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: saveBtn.frame.size.height)
            
            prevBtn.frame = CGRect(x: saveBtn.frame.origin.x + saveBtn.frame.size.width + 11 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: nextBtn.frame.size.height)
            print(saveBtn.frame.origin.x + saveBtn.frame.size.width + 11)
            
            
            
            
            self.nextBtn.isHidden = true
            
        }
        
        
         else if pageNumber > 1 { //if saveBool == true  //pageNumber > 0
        
            let width = (answerView.frame.size.width - 56)/3
            prevBtn.isHidden = false
            nextBtn.isHidden = false
            self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
            self.nextBtn.translatesAutoresizingMaskIntoConstraints = true
            self.prevBtn.translatesAutoresizingMaskIntoConstraints = true
            self.selectionView.translatesAutoresizingMaskIntoConstraints = true
            

            print(selectionView.frame.origin.y + selectionView.frame.size.height + 20)
            
            selectionView.frame = CGRect(x:selectionView.frame.origin.x  , y: selectionView.frame.origin.y , width: selectionView.frame.size.width, height:selectionView.frame.size.height)
            
            
            saveBtn.frame = CGRect(x:8  , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: width, height:prevBtn.frame.size.height)
            
            prevBtn.frame = CGRect(x: saveBtn.frame.origin.x + saveBtn.frame.size.width + 20 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: width, height: prevBtn.frame.size.height)
            
            nextBtn.frame = CGRect(x: prevBtn.frame.origin.x + prevBtn.frame.size.width + 20 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20 , width: width, height: prevBtn.frame.size.height)
            
            
            
        }
            
            
            
        else if pageNumber == 1 && hasMoreAnswers == 0 {
            
            nextBtn.isHidden = true
            prevBtn.isHidden = true
            
            self.saveBtn.translatesAutoresizingMaskIntoConstraints = true
            saveBtn.frame = CGRect(x: 8, y: saveBtn.frame.origin.y , width: answerView.frame.size.width - 16, height: saveBtn.frame.size.height )
            
        }
            
            
        else if pageNumber == 1 {
            
            nextBtn.isHidden = false
            saveBtn.frame = CGRect(x: 33.67 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: saveBtn.frame.size.height)
            
            
            
            nextBtn.frame = CGRect(x: saveBtn.frame.origin.x + saveBtn.frame.size.width + 11 , y: selectionView.frame.origin.y + selectionView.frame.size.height + 20, width: (UIScreen.main.bounds.size.width - 109)/2, height: nextBtn.frame.size.height)
            
            
            print(saveBtn.frame.origin.x + saveBtn.frame.size.width + 11)
            self.prevBtn.isHidden = true
            
            
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
    
    //    func getQuestionsApi()//(obj:GetFileObject)
    //    {
    //        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.userID) as! String
    //
    //        let usrId = Int(userId)
    ////        var page = Int()
    ////        var user_id = Int()
    ////
    ////        let url = URL(string: baseURL + ApiMethods.getQuestionApi + "/\(page=1&user_id=usrId)") \(usrId ?? 0)
    //
    //
    //        //let url = URL(string: baseURL + ApiMethods.getQuestionApi + page=1&user_id=usrId)!
    //
    //        ProjectManager.sharedInstance.showLoader()
    //        ProjectManager.sharedInstance.callApi(url:"http://dev.loopleap.com/api/getquestion?page=1&user_id=6") { (response, error) in
    //            ProjectManager.sharedInstance.stopLoader()
    //
    //            if response != nil {
    //                if let status = response?["status"] as? NSNumber {
    //                    if status == 0 {
    //                        if let err = response?["error"] as? [String:Any] {
    //
    //                            if let emailArr = err["Email"] as?[String] {
    //                                if emailArr.count > 0 {
    //                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: emailArr[0], vc: UIApplication.topViewController()!)
    //                                    return
    //                                }
    //
    //                            }
    //
    //                            if let phoneArr = err["phone"] as?[String] {
    //                                if phoneArr.count > 0 {
    //                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: phoneArr[0], vc: UIApplication.topViewController()!)
    //                                    return
    //                                }
    //
    //                            }
    //
    //                        }
    //
    //                    }
    //                    else {
    //
    //                        if let msg = response?["message"] as? String {
    //                            print(msg)
    //
    ////                            UserDefaults.standard.set("login", forKey:DefaultsIdentifier.login)
    ////                            UserDefaults.standard.synchronize()
    ////
    ////                            let vc:HomeViewController = self.storyboard?.instantiateViewController(withIdentifier:"HomeViewController") as! HomeViewController
    ////                            self.navigationController?.pushViewController(vc, animated: true)
    ////
    ////
    ////                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg, vc: UIApplication.topViewController()!)
    //                        }
    //
    //                    }
    //                }
    //
    //
    //            }
    //
    //
    //        }
    //
    //    }

}
