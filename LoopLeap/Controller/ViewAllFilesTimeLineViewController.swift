//
//  ViewAllFilesTimeLineViewController.swift
//  LoopLeap
//
//  Created by IOS3 on 10/01/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import SDWebImage
import MediaPlayer
import PopupDialog

class ViewAllCell: UICollectionViewCell
{
    @IBOutlet weak var filesImageView: UIImageView!

    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var videoPlayImg: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()

    }

    var photo: Photo? {
        didSet {
            if let photo = photo {

                filesImageView.image = photo.image
                imageLabel.text = photo.caption
            }
        }
    }


}


class ViewAllFilesTimeLineViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,  AVAudioPlayerDelegate
{
    var photos = Photo.allPhotos()


    @IBOutlet weak var selectedYearLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!


    @IBOutlet weak var viewAllFilesCollectionView: UICollectionView!

    var yearArray = NSArray()
    var filesFinalArray = [GetTimeLineFileObject]()
    var filesArray = [GetTimeLineFileObject]()
    var moviePlayer:MPMoviePlayerController!
    var audioPlayer: AVAudioPlayer?
    var i: Int = 10
    var selectedyear = Int()
    var isLoadMore = Bool()



    let lower : UInt32 = 130
    let upper : UInt32 = 250

    override func viewDidLoad()
    {
        super.viewDidLoad()
        selectedYearLabel.text = "\(selectedyear)"
        viewAllFiles(year: selectedyear, Offset: 0)

        if let layout = viewAllFilesCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }


        // Do any additional setup after loading the view.
    }

    //MARK:-
    //MARK:- CollectionView DataSources
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == viewAllFilesCollectionView {
//            let width = (UIScreen.main.bounds.size.width - 72)/2
//            self.filesFinalArray[indexPath.row].height = CGFloat(arc4random_uniform(upper - lower) + lower)
//
//            return CGSize(width:width, height: self.filesFinalArray[indexPath.row].height)
//        } else {
//            return CGSize(width:70, height: 50)
//        }
//
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {

            return filesFinalArray.count


    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCell", for: indexPath) as! ViewAllCell

       cell.filesImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let width = (UIScreen.main.bounds.size.width - 72)/2
        let frame = CGRect(x:0, y: 0, width: width, height: self.filesFinalArray[indexPath.item].height)
        cell.filesImageView.addBlackGradientLayers(frame: frame, colors:[.clear, UIColor.black.withAlphaComponent(0.6)])

            cell.imageLabel.text = filesFinalArray[indexPath.item].file_original_name

            if let ext = MimeType(path:filesFinalArray[indexPath.item].file_name).ext {

                if let mimeType = mimeTypes[ext]
                {

                    if mimeType.hasPrefix("audio")
                    {
                        cell.videoPlayImg.isHidden = true
                        cell.filesImageView?.image = #imageLiteral(resourceName: "audioPlaceholder")
                    }
                    else  if mimeType.hasPrefix("video")
                    {
                       // cell.filesImageView?.image = #imageLiteral(resourceName: "video-Icon")
                        
                        cell.videoPlayImg.isHidden = false
                        
                        if !self.filesFinalArray[indexPath.row].file_link.isEmpty {
                            if let imageFromCache = imageCache.object(forKey: self.filesFinalArray[indexPath.row].file_link as AnyObject) as? UIImage {
                               // if cell.filesImageView?.image == nil {
                                   cell.filesImageView.image = imageFromCache
                                //}
                                
                            } else {
                                cell.filesImageView.imageFromVideoServerURL(urlString: self.filesFinalArray[indexPath.row].file_link) { (image) in
                                    if image != nil {
                                        
                                        print(indexPath.row ,self.filesFinalArray.count)
                                        if indexPath.row < self.filesFinalArray.count && self.filesFinalArray.count > 0 {
                                        imageCache.setObject(image!, forKey: self.filesFinalArray[indexPath.row].file_link as AnyObject)
                                       // if  cell.filesImageView.image == nil {
                                            cell.filesImageView.image = image
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
                        cell.filesImageView.sd_setImage(with: URL(string:filesFinalArray[indexPath.row].file_link)) { (image, error, cache, url) in

                        }

                        //cell.photo?.image.sd_setImageWithURL(self.imageURL)



                    }

                    else 
                    {
                        cell.videoPlayImg.isHidden = true
                        cell.filesImageView?.image = #imageLiteral(resourceName: "attachment")
                        cell.filesImageView?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }


                }

                else
                {
                    cell.videoPlayImg.isHidden = true
                    cell.filesImageView?.image = #imageLiteral(resourceName: "attachment")
                    cell.filesImageView?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }

            }
            return cell



    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {



        let alertVC :DownloadFilesPopup = (self.storyboard?.instantiateViewController(withIdentifier: "DownloadFilesPopup") as? DownloadFilesPopup)!

        alertVC.receivedFileName = self.filesFinalArray[indexPath.item].file_original_name
        alertVC.receivedUrl = self.filesFinalArray[indexPath.item].file_link
        alertVC.receivedDate = self.filesFinalArray[indexPath.item].file_date
        alertVC.dir_Name = self.filesFinalArray[indexPath.item].dir_id


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

            })
        }

        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)




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
//                        }
//                    }
//                }
//            }
//




    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {




        if indexPath.row == filesArray.count - 1
        {
            //indicator!.start()
            if !isLoadMore {
                viewAllFiles(year:selectedyear ,Offset: 0 + i)
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

    @IBAction func backButtonAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK:-
    //MARK:- Api Methods


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
                if Offset == 0
                {
                    ProjectManager.sharedInstance.showLoader()
                }

                
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
                        let status = json["status"] as? Int

                        guard status == 1 else {
                            print("didn't get todo object as JSON from API")
                            self.isLoadMore = true

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
                            self.viewAllFilesCollectionView.reloadData()
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
    func addBlackGradientLayers(frame: CGRect, colors:[UIColor]){
        let width = (UIScreen.main.bounds.size.width - 72)/2
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
}

extension ViewAllFilesTimeLineViewController : PinterestLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {

        if self.filesFinalArray[indexPath.row].height == 0 {
            self.filesFinalArray[indexPath.row].height = CGFloat(arc4random_uniform(upper - lower) + lower)
        }
        return self.filesFinalArray[indexPath.row].height
    }
}
