//
//  ViewQuestionnaireViewController.swift
//  LoopLeap
//
//  Created by iOS6 on 04/04/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import AVKit
import MediaPlayer

class ViewQuestionnaireViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate
{
    
     @IBOutlet weak var questionsListTableView: UITableView!
    
    
    let kHeaderSectionTag: Int = 6900;
    var i: Int = 0
    var answeredQuestionsArray: Array<Any> = []
    var sectionItems: Array<Any> = []
    //let section  = headerView?.tag
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var filesArray = [GetAnswersObject]()
    var filesFinalArray = [GetAnswersObject]()
    
    var audioPlayer: AVAudioPlayer?
    var moviePlayer:MPMoviePlayerController!
    var currentIndex = Int()
    var obj = KeyHolderObject()
    var index = Int()


    override func viewDidLoad() {
        super.viewDidLoad()

        getAnsweredList(offset: 0)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    //MARK:-
    //MARK:- Tableview  Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if filesFinalArray.count > 0
            //filesArray.count > 0
        {
            self.questionsListTableView.backgroundView = nil
            return self.filesFinalArray.count
        }
        else
        {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "No questions found"
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.questionsListTableView.backgroundView = messageLabel;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if (self.expandedSectionHeaderNumber == section) {
        //            let arrayOfItems = self.filesFinalArray[section]
        //            return filesFinalArray.count;
        //        } else {
        //            return 0;
        //
        //    }
        if filesFinalArray[section].status {
            return 1
        } else {
            return 0
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"AnsweredCell", for: indexPath) as? AnsweredQuestionsCell else {return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        
        cell.answeredQuestionsTextView.isHidden = false
        cell.activityIndicator.isHidden = true
        
        //cell.ImgView.isHidden = true
        cell.answeredQuestionsTextView.text = self.filesFinalArray[indexPath.section].text_answer
        
        if self.filesFinalArray[indexPath.section].recorded_answer.isEmpty {
            
            cell.cellImageView.isHidden = true
            cell.videoView.isHidden = true
        }
        // cell.ImgView.isHidden = false
        
        
        if let ext = MimeType(path:self.filesFinalArray[indexPath.section].recorded_answer).ext {
            
            if let mimeType = mimeTypes[ext]
            {
                
                if mimeType.hasPrefix("audio")
                {
                    
                    //cell.videoView.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
                    
                    cell.videoView.isHidden = false
                    // cell.answeredQuestionsTextView.isHidden = true
                    cell.cellImageView.isHidden = true
                    
                    if self.filesFinalArray[indexPath.section].playStatus {
                        cell.ImgView.image = #imageLiteral(resourceName: "grayPause")
                    } else {
                        cell.ImgView.image = #imageLiteral(resourceName: "white-icon")
                    }
                    //cell.videoView.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
                    
                    
                    //                        cell.ImgView.isHidden = false
                    //                        cell.ImgView.image = UIImage(named: "audioPlaceholder")
                    //                        cell.activityIndicator.startAnimating()
                    //
                    //
                    //                        let urlstring = self.filesFinalArray[indexPath.section].recording_link
                    //                        let url = URL(string:urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    //                        DispatchQueue.global(qos: .background).async {
                    //
                    //
                    //                            do
                    //                            {
                    //                                let data = try Data.init(contentsOf: url!)
                    //
                    //                                DispatchQueue.main.async {
                    //                                    cell.activityIndicator.stopAnimating()
                    //
                    //
                    //                                    do {
                    //                                        //self.showActivityIndicatory()
                    //                                        //self.createSpinnerView()
                    //
                    //                                        self.audioPlayer = try AVAudioPlayer(data:data as Data )
                    //                                        self.audioPlayer?.prepareToPlay()
                    //                                        self.audioPlayer?.delegate = self
                    //
                    //                                        //                                    self.child.willMove(toParentViewController: nil)
                    //                                        //                                    self.child.view.removeFromSuperview()
                    //                                        //                                    self.child.removeFromParentViewController()
                    //
                    //
                    //                                        self.audioPlayer?.play()
                    //
                    //                                    }
                    //                                    catch _ {
                    //
                    //
                    //                                    }
                    //                                }
                    //
                    //                            } catch {
                    //
                    //                            }
                    //
                    //                        }
                    
                }
                    
                else  if mimeType.hasPrefix("video")
                {
                    
                    // cell.videoView.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
                    
                    
                    //  cell.answeredQuestionsTextView.isHidden = true
                    cell.cellImageView.isHidden = true
                    cell.videoView.isHidden = false
                    cell.videoView.backgroundColor = UIColor.black
                    
                    
                    
                    
                    //                        cell.ImgView.isHidden = false
                    //
                    //                        let vidURL = NSURL(fileURLWithPath:self.filesFinalArray[indexPath.section].recording_link as String)
                    //                        let asset = AVURLAsset(url: vidURL as URL)
                    //                        let generator = AVAssetImageGenerator(asset: asset)
                    //                        generator.appliesPreferredTrackTransform = true
                    //
                    //                        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
                    //
                    //                        do {
                    //                            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
                    //                            let uiImage = UIImage(cgImage: imageRef)
                    //                            cell.ImgView.image = uiImage
                    //
                    //                        }
                    //                        catch let error as NSError
                    //                        {
                    //                            print("Image generation failed with error \(error)")
                    //
                    //                        }
                    
                }
                    
                else if mimeType.hasPrefix("image")
                {
                    cell.videoView.isHidden = true
                    //cell.videoView.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
                    //  cell.answeredQuestionsTextView.isHidden = true
                    
                    cell.cellImageView.isHidden = false
                    cell.cellImageView?.sd_setImage(with: URL(string:self.filesFinalArray[indexPath.section].recorded_link)) { (image, error, cache, url) in

                    }
                    
//                    cell.cellImageView?.sd_setImage(with: URL(string:self.filesFinalArray[indexPath.section].recorded_answer)) { (image, error, cache, url) in
//
//                    }
                } else {
                    cell.videoView.isHidden = true
                    cell.cellImageView.isHidden = true
                }
                
                
            }
            else {
                cell.videoView.isHidden = true
                cell.cellImageView.isHidden = true
            }
        }
        else {
            cell.videoView.isHidden = true
            cell.cellImageView.isHidden = true
        }
        
        
        
        
        
        //            var err: NSError? = nil
        //            //cell.answeredQuestionsTextView.text = filesArray[indexPath.row].question
        //            do {
        //
        //            let asset = AVURLAsset(url: NSURL(fileURLWithPath:filesArray[indexPath.section].recording_link) as URL, options: nil)
        //            let imgGenerator = AVAssetImageGenerator(asset: asset)
        //            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
        //            // !! check the error before proceeding
        //            let uiImage = UIImage(cgImage: cgImage)
        //            //let imageView = UIImageView(image: uiImage)
        //
        //                cell.ImgView.image = uiImage
        //            }
        //
        //            catch let error {
        //
        //                print("*** Error generating thumbnail: \(error.localizedDescription)")
        //
        //
        //            }
        
        
        
        //
        //            let vidURL = NSURL(fileURLWithPath:filesFinalArray[indexPath.section].recording_link as String)
        //            let asset = AVURLAsset(url: vidURL as URL)
        //            let generator = AVAssetImageGenerator(asset: asset)
        //            generator.appliesPreferredTrackTransform = true
        //
        //            let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        //
        //            do {
        //                let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
        //                let uiImage = UIImage(cgImage: imageRef)
        //                cell.ImgView.image = uiImage
        //
        //            }
        //            catch let error as NSError
        //            {
        //                print("Image generation failed with error \(error)")
        //
        //            }
        
        
        
        
        
        
        
        
        
        //cell.dateLabel.text = filesArray[indexPath.row].question
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == filesFinalArray.count - 1 && filesArray.count == 10
            
        {
            
            //indicator!.start()
            getAnsweredList(offset: 0 + i)
            //
            
            
            //
            //            indicator!.stop()
            
            
        }
            
        else if filesArray.count < 10
        {
            
            print(self.filesArray.count)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let ext = MimeType(path:self.filesFinalArray[indexPath.section].recorded_answer).ext {
            
            if let mimeType = mimeTypes[ext]
            {
                
                if mimeType.hasPrefix("video")
                {
                    let cell = tableView.cellForRow(at:indexPath)  as! AnsweredQuestionsCell
                    let url:NSURL = NSURL(string: filesFinalArray[indexPath.section].recorded_link)!
                    
                     // let url:NSURL = NSURL(string: filesFinalArray[indexPath.section].recorded_answer)!
                    
                   

                    let vc = AVPlayerViewController()
                    vc.player = AVPlayer(url:url as URL)
                    self.present(vc, animated: true) {
                        vc.player?.play()
                    }
                    
                    //                    self.moviePlayer = MPMoviePlayerController(contentURL: url as URL)
                    //                    self.moviePlayer.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height)
                    //
                    //
                    //                    self.moviePlayer.isFullscreen = true
                    //                    self.moviePlayer.controlStyle = .embedded
                    //                    cell.videoView.addSubview(self.moviePlayer.view)
                    
                    //self.moviePlayer.controlStyle = MPMovieControlStyle.embedded
                }
                    
                else if mimeType.hasPrefix("audio")
                {
                    let cell = tableView.cellForRow(at:indexPath)  as! AnsweredQuestionsCell
                    currentIndex = indexPath.section
                    
                    if self.filesFinalArray[indexPath.section].playStatus {
                        self.filesFinalArray[indexPath.section].playStatus = false
                        self.audioPlayer?.stop()
                        self.questionsListTableView.reloadData()
                    }
                    else {
                        for i in 0..<self.filesFinalArray.count {
                            if i == indexPath.section {
                                self.filesFinalArray[i].playStatus = true
                            } else {
                                self.filesFinalArray[i].playStatus = false
                            }
                        }
                        self.questionsListTableView.reloadData()
                        cell.activityIndicator.startAnimating()
                        
                        
                        let urlstring = self.filesFinalArray[indexPath.section].recorded_link
                        //let urlstring = self.filesFinalArray[indexPath.section].recorded_answer
                        
                        let url = URL(string:urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                        DispatchQueue.global(qos: .background).async {
                            
                            
                            do
                            {
                                let data = try Data.init(contentsOf: url!)
                                
                                DispatchQueue.main.async {
                                    cell.activityIndicator.stopAnimating()
                                    
                                    
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
                                
                            } catch {
                                
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAtindexPath: IndexPath) {
        //questionsListTableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 58
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let obj = filesFinalArray[section]
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 58))
        headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let label = UILabel(frame: CGRect(x: 10, y: 3, width: headerView.frame.size.width - 40, height: 50))
        label.numberOfLines = 2
        label.text = obj.question
        let expandLbl = UIImageView(frame: CGRect(x:  label.frame.size.width + label.frame.origin.x + 5 , y: 3, width:20, height: 50))
        expandLbl.contentMode = .scaleAspectFit
        expandLbl.tintColor = .black
        if obj.status {
            expandLbl.image  = #imageLiteral(resourceName: "collapse")
        }
        else {
            expandLbl.image  = #imageLiteral(resourceName: "expand")
        }
        headerView.addSubview(label)
        headerView.addSubview(expandLbl)
        headerView.tag = section
        headerView.isUserInteractionEnabled = true
        let line = UIView(frame: CGRect(x: 0, y: 56.5, width: tableView.bounds.size.width, height: 1.5))
        line.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.7450980392, blue: 0.7490196078, alpha: 1)
        headerView.addSubview(line)
        let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
        headerView.addGestureRecognizer(tapgesture)
        return headerView
    }
    
    //    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //        //recast your view as a UITableViewHeaderFooterView
    //        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
    //        header.contentView.backgroundColor = UIColor.gray
    //        header.textLabel?.textColor = UIColor.white
    //
    //        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
    //            viewWithTag.removeFromSuperview()
    //        }
    //        let headerFrame = self.view.frame.size
    //        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
    //        theImageView.image = UIImage(named: "Chevron-Dn-Wht")
    //        theImageView.tag = kHeaderSectionTag + section
    //        header.addSubview(theImageView)
    //
    //        // make headers touchable
    //        header.tag = section
    //        let headerTapGesture = UITapGestureRecognizer()
    //        headerTapGesture.addTarget(self, action: #selector(AnsweredQuestionsListViewController.sectionTapped(_:)))
    //        header.addGestureRecognizer(headerTapGesture)
    //    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.filesFinalArray[section].question
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.questionsListTableView!.beginUpdates()
            self.questionsListTableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.questionsListTableView!.endUpdates()
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.filesFinalArray[section].question
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.questionsListTableView!.beginUpdates()
            self.questionsListTableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.questionsListTableView!.endUpdates()
        }
    }
    
    @objc func sectionTapped(_ sender: UITapGestureRecognizer)
    {
        let headerView = sender.view
        let section    = headerView?.tag
        if filesFinalArray[section!].status {
            filesFinalArray[section!].status = false
        } else {
            filesFinalArray[section!].status = true
        }
        self.audioPlayer?.stop()
        self.filesFinalArray.forEach { $0.playStatus = false}
        questionsListTableView.reloadData()
        
        
    }
    
    
    //MARK:-
    //MARK:- IBActions
    
    @IBAction func backButtonAction(_ sender: Any)
    {

        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.filesFinalArray[currentIndex].playStatus = false
        self.questionsListTableView.reloadData()
        
    }
    //MARK:-
    //MARK:- Api Methods
    
    func getAnsweredList(offset: Int)
    {
        //        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.userID) as! String
        //
        //        let todoEndpoint: String = "http://dev.loopleap.com/api/viewallanswers"
        
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
                if i == 0 {
                    ProjectManager.sharedInstance.showLoader()
                }
                
                let parameters:[String : Any] = ["sender_id":obj.sender_id, "page_number":offset, "per_page_question":"10"]
                
                Alamofire.request(baseURL + ApiMethods.viewSharedAnswers, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
                        
                        if let data = json["data"] as? NSArray
                        {
                            self.i += 10
                            print(data)
                            self.filesArray = ProjectManager.sharedInstance.GetAnswersObjects(array:data)
                            
                            self.filesFinalArray.append(contentsOf:self.filesArray)
                            print(self.filesFinalArray)
                            self.questionsListTableView.reloadData()
                            
                           
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
