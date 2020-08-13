//
//  TimeLineHistoryViewController.swift
//  LoopLeap
//
//  Created by IOS2 on 12/20/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import SDWebImage
import MediaPlayer
import PopupDialog


protocol AudioVideoDelegate {

    func displayAudioVideo(found: URL, fileName: String)
}


class MyCell: UICollectionViewCell
{
    @IBOutlet weak var yearLabel: UILabel!

    @IBOutlet weak var roundViw: UIView!
    
}

class CollectionCell: UICollectionViewCell
{
    @IBOutlet weak var addedImageView: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var videoPlayImg: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    var photo: Photo? {
        didSet {
            if let photo = photo {
                
                addedImageView.image = photo.image
                imageLabel.text = photo.caption
            }
        }
    }
    
    
}

class TimeLineHistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, AVAudioPlayerDelegate , UICollectionViewDelegateFlowLayout, TimelineDelegate
{
    
    func refreshTimeLine() {
        // showBool = true
        self.filesFinalArray.removeAll()
        self.filesArray.removeAll()
        self.yearArray = []
        self.collectionView.reloadData()
        self.addedFilesCollectionView.reloadData()
         getTimeLineYears()
        
    }
    
    var photos = Photo.allPhotos()

    
    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var backtoPortalBtn: UIButton!
    @IBOutlet weak var selectedYearLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addedFilesCollectionView: UICollectionView!

    
    
    var yearArray = NSArray()
    var filesFinalArray = [GetTimeLineFileObject]()
    var filesArray = [GetTimeLineFileObject]()
    var moviePlayer: MPMoviePlayerController!
    var audioPlayer: AVAudioPlayer?
    var i: Int = 10
    var selectedyear = Int()
    var selectedYearIndex = Int()
    var isLoadMore = Bool()
    var delegate: AudioVideoDelegate?
    var messageLabel = UILabel()
    var message = String()
    var role = Int()
    var showBool = Bool()
    var selected_year = String()
    var activePlanObj = GetPlanListObject()



    let lower : UInt32 = 130
    let upper : UInt32 = 250

    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let layout = addedFilesCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        ProjectManager.sharedInstance.refreshTimeLineDelegate = self
        

        self.viewAllBtn.layer.cornerRadius = 19
        self.viewAllBtn.layer.masksToBounds = true

        messageLabel = UILabel(frame: CGRect(x: 10, y: (addedFilesCollectionView.frame.size.height - 40)/2, width: view.bounds.size.width - 20, height: 40))
       // messageLabel.text
        message = "Click to view more files to view all files"
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Raleway", size: 18.0)!
        messageLabel.sizeToFit()
        //self.addedFilesCollectionView.addSubview(messageLabel)
        messageLabel.isHidden = true
        self.addedFilesCollectionView.backgroundView = messageLabel
        backtoPortalBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: backtoPortalBtn.frame.size.height/2)
        uploadBtn.setBorder(width: 1, color: #colorLiteral(red: 0.7764705882, green: 0.1960784314, blue: 0.231372549, alpha: 1), cornerRaidus: uploadBtn.frame.size.height/2)
      //  if !(showBool) {
       
        
       // if !activeStatus {
            
            self.paymentGeneralApi()
       // }
        
            getTimeLineYears()
            
       // }
       
        
       
        
        
        
//        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
//        {
//            
//            if let role = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
//                
//                if role  == 6 {
//                    
//                    backtoPortalBtn.isHidden = false
//                    
//                }
//                    
//                else {
//                    
//                    backtoPortalBtn.isHidden = true
//                }
//            }
//                
//            else {
//                
//                backtoPortalBtn.isHidden = true
//                
//            }
//            
//        }
//            
//            
//        else {
//            
//            backtoPortalBtn.isHidden = true
//            
//        }
    

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if (UserDefaults.standard.value(forKey:DefaultsIdentifier.role) != nil)
        {
            
            if let  userRole = UserDefaults.standard.value(forKey:DefaultsIdentifier.role) as? Int {
                
                role = userRole
                
                if role == 6 {
                    
                    self.backtoPortalBtn.isHidden = false
                    //self.addDirectoryBtn.isHidden = true
                }
                    
                else  {
                    
                    self.backtoPortalBtn.isHidden = true
                    // self.addDirectoryBtn.isHidden = false
                    
                }
                
            }
            
            
            else {
                
                backtoPortalBtn.isHidden = true
                
            }
            
        }
        
        
        else {
            
             backtoPortalBtn.isHidden = true
            
        }
        
    }
    
    
    
    

    //MARK:-
    //MARK:- CollectionView DataSources
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == addedFilesCollectionView {
//      let width = (UIScreen.main.bounds.size.width - 72)/2
//        self.filesFinalArray[indexPath.row].height = CGFloat(arc4random_uniform(upper - lower) + lower)
//        return CGSize(width:width, height: self.filesFinalArray[indexPath.row].height)
//        } else {
//            return CGSize(width:70, height: 50)
//        }
//
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == self.collectionView
        {
          return yearArray.count
        }
        
        else
        {
            if self.filesFinalArray.count  > 0
            {
                return filesFinalArray.count

            }

            else {

            }
            return 0

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView
        {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
            cell.yearLabel.text = "\(yearArray[indexPath.row])"
            cell.roundViw.layer.cornerRadius = 8
            cell.roundViw.clipsToBounds = true
            cell.roundViw.setBorderWithWidth(width:1.5, color: .lightGray)
            
            
            
            if "\(self.yearArray[indexPath.row])" ==  selected_year {
                
                cell.roundViw.backgroundColor = #colorLiteral(red: 0.7777315974, green: 0.193803966, blue: 0.232359767, alpha: 1)

                
            }
       
//            if indexPath.item ==  selectedYearIndex {
//
//                cell.roundViw.backgroundColor = #colorLiteral(red: 0.7777315974, green: 0.193803966, blue: 0.232359767, alpha: 1)
//            }
            else {
                cell.roundViw.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            }
//            cell.yearLabel.tag = indexPath.row
//            let tap = UITapGestureRecognizer(target: self, action: #selector(TimeLineHistoryViewController.yearLabelClicked))
//            cell.yearLabel.isUserInteractionEnabled = true
//            cell.yearLabel.addGestureRecognizer(tap)

        
        return cell
        }
        
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
            //cell.photo = photos[indexPath.item]
            

            cell.addedImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
             let width = (UIScreen.main.bounds.size.width - 72)/2
           let frame = CGRect(x:0, y: 0, width: width, height: self.filesFinalArray[indexPath.item].height)
            cell.addedImageView.addBlackGradientLayer(frame: frame, colors:[.clear  , UIColor.darkGray.withAlphaComponent(0.4)])
             //cell.addedImageView.frame =  cell.addedImageView.contentClippingRect
          
            cell.imageLabel.text = filesFinalArray[indexPath.item].file_original_name
            //imageWithGradient(img: cell.addedImageView.image)


            if let ext = MimeType(path:filesFinalArray[indexPath.item].file_name).ext {

                if let mimeType = mimeTypes[ext]
                {

                    if mimeType.hasPrefix("audio")
                    {
                    cell.addedImageView.sd_cancelCurrentImageLoad()
                    cell.addedImageView?.image = #imageLiteral(resourceName: "audioPlaceholder")
                    cell.videoPlayImg.isHidden = true
                        
                    }
                    else  if mimeType.hasPrefix("video")
                    {
                        cell.addedImageView.sd_cancelCurrentImageLoad()
                        cell.videoPlayImg.isHidden = false

//
//
//
//                            let urlstring = self.filesFinalArray[indexPath.row].file_link
//
//                            let url = URL(string:urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//
//                            let asset = AVAsset(url: url!)
//                            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
//                            assetImgGenerate.appliesPreferredTrackTransform = true
//                            let time = CMTimeMake(1, 2)
//                            let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
//                            if img != nil {
//                                let frameImg  = UIImage(cgImage: img!)
//                                DispatchQueue.main.async(execute: {
//                                    // assign your image to UIImageView
//
//                                    cell.addedImageView?.image = frameImg
//                                })
//                            }
//
//                            else {
//
//
//                            }
//
//
                       
                      // cell.addedImageView?.image = #imageLiteral(resourceName: "video-Icon")
                        
                        
                        
                        
                        if !self.filesFinalArray[indexPath.row].file_link.isEmpty {
                            if let imageFromCache = imageCache.object(forKey: self.filesFinalArray[indexPath.row].file_link as AnyObject) as? UIImage {
                                //if cell.addedImageView?.image == nil {
                                     cell.addedImageView.image = imageFromCache
                                //}

                            } else {
                               cell.addedImageView.imageFromVideoServerURL(urlString: self.filesFinalArray[indexPath.row].file_link) { (image) in
                                    if image != nil {
                                        print(indexPath.row ,self.filesFinalArray.count)
                                        if indexPath.row < self.filesFinalArray.count && self.filesFinalArray.count > 0 {
                                        imageCache.setObject(image!, forKey: self.filesFinalArray[indexPath.row].file_link as AnyObject)
                                       // if  cell.addedImageView.image == nil {
                                            cell.addedImageView.image = image
                                        //}
                                        }
                                    }
                                }

                            }

                        }
                        
                        
                        
                        
                        

                    }

                    else  if mimeType.hasPrefix("image")
                    {
                        cell.videoPlayImg.isHidden = true
                        cell.addedImageView.sd_setImage(with: URL(string:filesFinalArray[indexPath.row].file_link)) { (image, error, cache, url) in

                        }
                        //cell.photo?.image.sd_setImageWithURL(self.imageURL)


                    }

                    else
                    {
                        cell.videoPlayImg.isHidden = true
                        cell.addedImageView.sd_cancelCurrentImageLoad()
                        cell.addedImageView?.image = #imageLiteral(resourceName: "attachment")
                        cell.addedImageView?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }


                }

                else
                {
                    cell.videoPlayImg.isHidden = true
                    cell.addedImageView.sd_cancelCurrentImageLoad()
                    cell.addedImageView?.image = #imageLiteral(resourceName: "attachment")
                    cell.addedImageView?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }

            }
            return cell

            }


        }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //Where elements_count is the count of all your items in that
        //Collection view...
        if collectionView == self.collectionView {
        let cellCount = CGFloat(self.yearArray.count)
        
        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            
            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount 
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.
                
                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsetsMake(0, padding, 0, padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsetsMake(0, 40, 0, 40)
            }
        }
        }
        return UIEdgeInsets.zero
    }
    

    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 55, height: 72)
        } else {
            return CGSize.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {


        

        if collectionView == self.collectionView
        {
            
            let yearLabelValue = yearArray[indexPath.row]
            selectedyear = Int("\(yearLabelValue)")!// as! Int
            self.selectedYearLabel.text = "\(self.selectedyear)"
            self.filesFinalArray.removeAll()
            self.addedFilesCollectionView.reloadData()
            self.selectedYearIndex = indexPath.item
            self.selected_year = "\(yearLabelValue)"
            self.isLoadMore = false
            self.i = 10
            
            self.collectionView.reloadData()
            addedFilesCollectionView.contentOffset = CGPoint.zero
            getTimeLineFiles(year: Int(selected_year)!, offset : 0)
        
        }

        else
        {
            let alertVC :DownloadFilesPopup = (self.storyboard?.instantiateViewController(withIdentifier: "DownloadFilesPopup") as? DownloadFilesPopup)!

            alertVC.receivedFileName = self.filesFinalArray[indexPath.item].file_original_name
            alertVC.receivedUrl = self.filesFinalArray[indexPath.item].file_link
            alertVC.receivedID = self.filesFinalArray[indexPath.item].id
            alertVC.receivedDate = self.filesFinalArray[indexPath.item].file_date
            alertVC.dir_Name = self.filesFinalArray[indexPath.item].dir_id


                   let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                    , tapGestureDismissal: false, panGestureDismissal: false) {
                        let overlayAppearance = PopupDialogOverlayView.appearance()
                        overlayAppearance.blurRadius  = 30
                        overlayAppearance.blurEnabled = true
                       overlayAppearance.liveBlur    = false
                        overlayAppearance.opacity     = 0.4
//                        if self.delegate != nil{
//                            self.delegate?.displayAudioVideo(found: URL(string: self.filesFinalArray[indexPath.item].file_link)! , fileName:  self.filesFinalArray[indexPath.item].file_name )
//
//                        }
                   }

                    alertVC.noAction = {

                        popup.dismiss({



                       })
                   }

                    alertVC.yesAcion = {

                       popup.dismiss({

          })
                    }

                    UIApplication.topViewController()?.present(popup, animated: true, completion: nil)


          
//
//            if let ext = MimeType(path:filesFinalArray[indexPath.item].file_name).ext {
//
//                if let mimeType = mimeTypes[ext]
//                {
//
//                    if mimeType.hasPrefix("video")
//                    {
//
//                        let url:NSURL = NSURL(string: filesFinalArray[indexPath.item].file_link)!
//
//                        moviePlayer = MPMoviePlayerController(contentURL: url as URL)
//                        moviePlayer.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
//
//                        self.view.addSubview(moviePlayer.view)
//                        moviePlayer.isFullscreen = true
//
//                        moviePlayer.controlStyle = MPMovieControlStyle.embedded
//                    }
//
//                    else if mimeType.hasPrefix("audio")
//                    {
//                        let urlstring = filesFinalArray[indexPath.item].file_link
//
//                        let url = URL(string:urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//
//                        DispatchQueue.global(qos: .background).async {
//
//                            do
//                            {
//                                let data = try Data.init(contentsOf: url!)
//
//                                DispatchQueue.main.async {
//
//
//
//                                    do {
//                                        self.audioPlayer = try AVAudioPlayer(data:data as Data )
//                                        self.audioPlayer?.prepareToPlay()
//                                        self.audioPlayer?.delegate = self
//
//                                        self.audioPlayer?.play()
//
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
//
//                    }
//                    }
//                }
//            }

        }
       


    }
    func play(url:URL) {
        print("playing \(url)")

        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }

    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {




        if indexPath.row == filesFinalArray.count - 1 && filesFinalArray.count > 9
        {
            //indicator!.start()
            if !isLoadMore {
                getTimeLineFiles(year:Int(selected_year)! ,offset: 0 + i)
            }
            else{
                print("No files")

            }

            //
            //
            //            indicator!.stop()

        }

        else if filesArray.count < 10
        {

            print(self.filesArray.count)
        }
    }
  

    //MARK:-
    //MARK:- IBAction Methods
    
    
    @IBAction func sideMenuBtnAction(_ sender: Any) {
        
        sideMenuController?.revealMenu()
        
    }
    @IBAction func uploadBtnActionj(_ sender: Any) {
        
        let vc:ContainerForUploadViewController = self.storyboard?.instantiateViewController(withIdentifier:"ContainerForUploadViewController") as! ContainerForUploadViewController
        self.present(vc, animated: true, completion: nil)
        
        
        
//        let vc:NumberOfQuestionsViewController = self.storyboard?.instantiateViewController(withIdentifier:"NumberOfQuestionsViewController") as! NumberOfQuestionsViewController
//        self.present(vc, animated: true, completion: nil)

        
    }
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        
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
    
    
    @IBAction func backToPortalBtnAction(_ sender: Any) {
        
        backtoPortalApi()
        
    }
    


    @IBAction func addButtonAction(_ sender: Any)
    {
        
        let vc:ViewAllFilesTimeLineViewController = self.storyboard?.instantiateViewController(withIdentifier:"ViewAllFilesTimeLineViewController") as! ViewAllFilesTimeLineViewController
       // vc.selectedyear = selectedyear
        vc.selectedyear = Int(selected_year)!
        self.present(vc, animated: true, completion: nil)

    }


   @objc func yearLabelClicked(sender:UITapGestureRecognizer)
    {
        print("tap working")
        
        //getTimeLineFiles()

    }


    func imageWithGradient(img:UIImage!) -> UIImage {

        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()

        img.draw(at: CGPoint(x: 0, y: 0))

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]

        let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor

        let colors = [top, bottom] as CFArray

        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)

        let startPoint = CGPoint(x: img.size.width/2, y: 0)
        let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)

        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
    }
    
    //MARK:-
    //MARK:- Api Methods

    func getTimeLineYears()
    {


       // let todoEndpoint: String = "http://dev.loopleap.com/api/timelineyears?user_id=\(userId)"
       // let parameters = ["user_id": userId]

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


                Alamofire.request(baseURL + ApiMethods.timelineyears, method: .post,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
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
                if status == 0 {
                    
                    self.messageLabel.isHidden = false
                    self.messageLabel.text = "No Files"
                    let msg = json["message"] as? String
//                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!
//                    , vc: UIApplication.topViewController()!)
                    
                }
                else {
                    
                    if let array = json["data"] as? NSArray {
                        self.yearArray = array
                        print(self.yearArray)
                        self.collectionView.reloadData()
                        if self.yearArray.count > 0 {
                             self.messageLabel.isHidden = true
                            self.selectedyear = Int("\(self.yearArray[0])")! //as! Int
                            
                            
                            let year = Calendar.current.component(.year, from: Date())
                            
                            var stringYear = String()
                            
                            stringYear = String(year)
                            
                            
                            if self.yearArray.contains(year) {
                                
                                self.selected_year = stringYear
                                
                            }
                            
                            else {
                                
                                self.selected_year =  "\(self.yearArray[0])"
                            }
                            
                            
                            self.selectedYearLabel.text = "\(self.selectedyear)"
                             self.getTimeLineFiles(year: Int(self.selected_year)! , offset: 0)
//                            self.getTimeLineFiles(year: self.yearArray[0] as! Int, offset: 0)
                        }
                            
                        else {
                            
                            self.messageLabel.isHidden = false
                            self.messageLabel.text = "No Files"
                            let msg = json["message"] as? String
//                            ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!
//                                , vc: UIApplication.topViewController()!)
                            
                        }
                        
                    }
                    
                    
                    else {
                        
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = "No Files"
                        let msg = json["message"] as? String
//                        ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!
//                            , vc: UIApplication.topViewController()!)
                        
                    }
                }
                // get and print the title
                
                //                guard let data = json["data"] as? [String:Any] else {
                //                    print("Could not get question from JSON")
                //                    return
                //                }
                //                print(data)
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

    func getTimeLineFiles(year: Int, offset: Int)
    {


        //let todoEndpoint: String = "http://dev.loopleap.com/api/gettimelinefiles"

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
                if offset == 0
                {
                   ProjectManager.sharedInstance.showLoader()
                }

               let parameters = ["year":year,
                          "offset":offset] as [String : Any]

                print(parameters)
                Alamofire.request(baseURL + ApiMethods.gettimelinefiles, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
                var status = json["status"] as? Int

                guard status == 1 else {
                    
                    if self.filesFinalArray.count == 0 {
                        
                        if offset == 0 {
                         self.messageLabel.isHidden = false
                         self.messageLabel.text = json["message"] as? String
                            
                        }
                        
                        else {
                            
                             self.messageLabel.isHidden = true
                        }
                    }
                    else {
                      
                            self.messageLabel.isHidden = true
                       
                    }
                    if  let hasmorefiles = json["hasmorefiles"] as? Int {
                        if hasmorefiles > 0
                    {
                        self.viewAllBtn.isHidden = false
                        // self.messageLabel.isHidden = false
                        
                       // self.messageLabel.text = json["message"] as? String


                    }
                    else
                    {
                       // self.messageLabel.text = json["message"] as? String
                        if json["message"] as? String == "No files uploaded in this year"
                        {
                            self.viewAllBtn.isHidden = true
                            //self.messageLabel.isHidden = true
                            
                           // self.messageLabel.text = json["message"] as? String

                        }

                        else
                        {
                            
                            self.viewAllBtn.isHidden = true
                           // self.messageLabel.isHidden = true


                        }
                        
                    }
                        }
                    print("didn't get todo object as JSON from API")
                    self.isLoadMore = true

                    return
                }

                print(status)
//                         var hasmorefiles = json["hasmorefiles"] as? Int
//
//                        guard hasmorefiles > 0 else {
//                            self.messageLabel.isHidden = false
//                            self.messageLabel.text = json["message"] as? string
//                            print("didn't get todo object as JSON from API")
//                            self.isLoadMore = true
//
//                            return
//                        }
//
//                         print(hasmorefiles)
                        let hasmorefiles = json["hasmorefiles"] as? Int
                        if hasmorefiles! > 0
                        {
                            self.viewAllBtn.isHidden = false
                            if self.filesFinalArray.count == 0 {
                            self.messageLabel.isHidden = false
                            self.messageLabel.text = json["message"] as? String

                            }
                            
                            else {
                                self.messageLabel.isHidden = true

                                
                            }

                        }
                        else
                        {

                            if json["message"] as? String == "No files uploaded in this year"
                            {
                                self.viewAllBtn.isHidden = true
                                self.messageLabel.isHidden = true
                                 //self.messageLabel.text = json["message"] as? String
                                
                            }
                                
                            else
                            {
                                self.viewAllBtn.isHidden = true
                                self.messageLabel.isHidden = true

                                
                            }
                            //self.viewAllBtn.isHidden = true
                        }

                if let data = json["data"] as? NSArray
                {
                    self.i += 10
                    print(data)
                    self.filesArray = ProjectManager.sharedInstance.GetTimeLineFileObjects(array: data)

                    self.filesFinalArray.append(contentsOf:self.filesArray)
                    print(self.filesFinalArray)

//                    self.photos = [Photo](repeatElement(Photo(caption:"", comment: "", image: UIImage()), count: self.filesArray.count))

                    DispatchQueue.main.async {
                        self.addedFilesCollectionView.reloadData()
                        if self.filesFinalArray.count > 0
                        {
                            self.messageLabel.isHidden = true
                        }
                        else
                        {
                            if offset == 0 {
                            
                             self.messageLabel.isHidden = false
                             self.messageLabel.text = json["message"] as? String
                                
                            }
                            
                            else {
                                
                                self.messageLabel.isHidden = true
                                
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

    func viewAllFiles(year: Int, Offset: Int )
    {

       // let todoEndpoint: String = "http://dev.loopleap.com/api/viewalltimelinefiles"

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
                let parameters = ["year":year,
                                  "offset":Offset] as [String : Any]

                Alamofire.request(baseURL + ApiMethods.viewalltimelinefiles, method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers:headers)
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
                        var status = json["status"] as? Int

                        guard status == 1 else {
                            print("didn't get todo object as JSON from API")
                            //self.isLoadMore = true

                            return
                        }

                        print(status)


                        if let data = json["data"] as? NSArray
                        {
                            self.i += 10
                            print(data)
                            self.filesArray = ProjectManager.sharedInstance.GetTimeLineFileObjects(array: data)

                            self.filesFinalArray.append(contentsOf:self.filesArray)
                            print(self.filesFinalArray)

                            self.photos = [Photo](repeatElement(Photo(caption:"", comment: "", image: UIImage()), count: self.filesArray.count))
                            self.addedFilesCollectionView.reloadData()
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
    
    
    func backtoPortalApi() {
        
        
        // let todoEndpoint: String = "http://dev.loopleap.com/api/timelineyears?user_id=\(userId)"
        // let parameters = ["user_id": userId]
        
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
                
                
                Alamofire.request(baseURL + ApiMethods.leaveImpersonate, method: .post,  parameters: nil, encoding: JSONEncoding.default, headers:headers)
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
                            if let data = json["data"] as? [String: Any] {
                                
                                if  let access_token = data["access_token"] as? String {
                                    
                                    let msg = json["message"] as? String
                                    // let userID =
                                    //ProjectManager.sharedInstance.checkResponseForString(jsonKey:"enc_user_id", dict: data )
                                    
                                    let token_type =  data["token_type"] as? String
                                    UserDefaults.standard.set("Bearer ", forKey:DefaultsIdentifier.token_type)
                                    UserDefaults.standard.set(access_token, forKey:DefaultsIdentifier.access_token)
                                    
                                     UserDefaults.standard.set(access_token, forKey:DefaultsIdentifier.parent_access_token)
                                    
                                    let role = data["role"] as? Int
                                    UserDefaults.standard.set(role, forKey:DefaultsIdentifier.role)
                                    UserDefaults.standard.synchronize()
                                    self.backtoPortalBtn.isHidden = true
                                    //  self.addDirectoryBtn.isHidden = false
                                    
                                    ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: msg!, vc: UIApplication.topViewController()!)
                                    
                                    self.filesFinalArray.removeAll()
                                    self.filesArray.removeAll()
                                    self.yearArray = []
                                    self.collectionView.reloadData()
                                    self.addedFilesCollectionView.reloadData()
                                    self.getTimeLineYears()
                                }
                                
                            }
                        }
                        else {
                            let msg = json["message"] as? String
                            
                            self.navigationController?.popViewController(animated: true)
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
                        
                        UserDefaults.standard.set(true, forKey: "isShowPopup")
                        UserDefaults.standard.synchronize()
                        
                        let status = json["status"] as? Bool
                        if status == true
                        {
                            
                            // DispatchQueue.main.async {
                            
                            
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
                                    if UIApplication.topViewController() is UIAlertController {
                                        
                                        self.dismiss(animated: true, completion: {
                                            
                                            
                                            let vc:NumberOfQuestionsViewController = self.storyboard?.instantiateViewController(withIdentifier:"NumberOfQuestionsViewController") as! NumberOfQuestionsViewController
                                            
                                            
                                            
                                            // self.present(vc, animated: true, completion: nil)
                                            //self.navigationController?.pushViewController(vc, animated: true)
                                            
                                            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                                        })
                                    }
                                        
                                    else
                                    {
                                        
                                        
                                        let vc:NumberOfQuestionsViewController = self.storyboard?.instantiateViewController(withIdentifier:"NumberOfQuestionsViewController") as! NumberOfQuestionsViewController
                                        
                                        
                                        
                                        // self.present(vc, animated: true, completion: nil)
                                        //self.navigationController?.pushViewController(vc, animated: true)
                                        
                                        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                                    }
                                    
                                    
                                    
                                    
                                })
                            }
                            
                            UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                            
                            
                            
                            
                            // }
                            
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
                                        
                                        
                                        self.present(vc, animated: true, completion: nil)
                                        //self.navigationController?.pushViewController(vc, animated: true)
                                        
                                        
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
                        if status == 1 {
                            
                            UserDefaults.standard.set("logout", forKey:DefaultsIdentifier.login)
                            UserDefaults.standard.synchronize()
                            
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            let vc:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
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
    
    func paymentGeneralApi() {
        
        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.parent_access_token) as? String
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
//                          activeStatus =  true
                            if let data = json["data"] as? [String: Any] {
                                
                                let object = ProjectManager.sharedInstance.GetGeneralPaymentObjects(object: data)

                                
                                 if object.payment_status == "0" {
                                    
                                    
                                    let vc:UpdatePlanViewController = self.storyboard?.instantiateViewController(withIdentifier:"UpdatePlanViewController") as! UpdatePlanViewController
                                     UserDefaults.standard.set(nil, forKey: DefaultsIdentifier.plan_order)
                                    
                                    vc.cancelStatusBool = true
                                    self.present(vc, animated: true, completion: nil)
                                    
                                    //                                    UserDefaults.standard.set(nil, forKey: DefaultsIdentifier.plan_order)
                                    //
                                    //
                                    //                                    let alertVC :GeneralAlertPopup = (self.storyboard?.instantiateViewController(withIdentifier: "GeneralAlertPopup") as? GeneralAlertPopup)!
                                    //
                                    //
                                    //                                    let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                    //                                    , tapGestureDismissal: false, panGestureDismissal: false) {
                                    //                                        let overlayAppearance = PopupDialogOverlayView.appearance()
                                    //                                        overlayAppearance.blurRadius  = 30
                                    //                                        overlayAppearance.blurEnabled = true
                                    //                                        overlayAppearance.liveBlur    = false
                                    //                                        overlayAppearance.opacity     = 0.4
                                    //                                    }
                                    //
                                    //                                    alertVC.cancelAction = {
                                    //
                                    //                                        popup.dismiss({
                                    //
                                    //
                                    //
                                    //                                        })
                                    //
                                    //
                                    //                                    }
                                    //
                                    //                                    alertVC.showPlansAction = {
                                    //
                                    //                                        popup.dismiss({
                                    //
                                    //
                                    //
                                    //
                                    //                                            let vc:UpdatePlanViewController = self.storyboard?.instantiateViewController(withIdentifier:"UpdatePlanViewController") as! UpdatePlanViewController
                                    //
                                    //                                            vc.fromHomeScreen = true
                                    //                                            self.present(vc, animated: true, completion: nil)
                                    //
                                    //
                                    //
                                    //                                        })
                                    //
                                    //                                    }
                                    //
                                    //
                                    //                                    UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                                    //
                                    
                                    
                                    
                                    
                                }

                               else {
                                    
                                    if !UserDefaults.standard.bool(forKey: "isShowPopup") {
                                        self.showPopups()
                                    }
                                    
                                     UserDefaults.standard.set(object.plan_order, forKey: DefaultsIdentifier.plan_order)
                                     UserDefaults.standard.synchronize()
                                    
                                    if !activeStatus {
                                        
                                        activeStatus = true
 
                                    let alertVC :ActivePlanDetailPopup = (self.storyboard?.instantiateViewController(withIdentifier: "ActivePlanDetailPopup") as? ActivePlanDetailPopup)!

                                    alertVC.obj = object


                                    let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                                    , tapGestureDismissal: false, panGestureDismissal: false) {
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
    
    
    
    
    
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImageView{
    func addBlackGradientLayer(frame: CGRect, colors:[UIColor]){
        let width = (UIScreen.main.bounds.size.width - 72)/2
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
}

extension TimeLineHistoryViewController: PinterestLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {

        if self.filesFinalArray[indexPath.row].height == 0 {
        self.filesFinalArray[indexPath.row].height = CGFloat(arc4random_uniform(upper - lower) + lower)
        }
        return self.filesFinalArray[indexPath.row].height
    }
}


extension TimeLineHistoryViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard let data = NSData(contentsOf: outputFileURL as URL) else {
            return
        }
        
        //    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        //        guard let data = NSData(contentsOf: outputFileURL as URL) else {
        //            return
        //        }
        
        print("File size before compression: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        compressVideo(inputURL: outputFileURL as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}
let userImageCache = NSCache<NSString, UIImage>()
let imageCache = NSCache<AnyObject, AnyObject>()
var imageURLString: String?


extension UIImageView {
    public func imageFromVideoServerURL(urlString: String, completion:@escaping (UIImage?) -> Void) {
        imageURLString = urlString
        self.image = nil
        if let url = URL(string: urlString) {
            
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil{
                    
                }
                
                DispatchQueue.main.async(execute: {
                    
                    
                    ProjectManager.sharedInstance.getThumnailImageFromVideo(urlStr: urlString) { (img) in
                        if img != nil {
                            completion(img)
                            // calls when scrolling
                            
                        } else {
                            completion(nil)
                        }
                    }
                    
                })
            }) .resume()
        }
    }
    public func imageFromServerURL(urlString: String, completion:@escaping (UIImage?) -> Void) {
        imageURLString = urlString
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil{
                    
                }
                DispatchQueue.main.async(execute: {
                    if data != nil {
                        
                        if let imgaeToCache = UIImage(data: data!){
                            let width = (UIScreen.main.bounds.size.width - 2)/3
                            let cacheImage = imgaeToCache.resizeImageWith(newSize: CGSize(width: width, height: width + 60))
                            completion(cacheImage)
                            
                            
                        } else {
                            completion(nil)
                        }
                    }
                })
            }) .resume()
        }
}
}
