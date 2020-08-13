//
//  PreviewAudioVideoPopup..swift
//  LoopLeap
//
//  Created by IOS3 on 14/01/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import CoreServices
import PopupDialog

class PreviewAudioVideoPopup: UIViewController, AVAudioPlayerDelegate
{
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var  noAction : blockAction?
    var receivedUrl: URL?
    var receivedData: NSData?
    var isPlaying = Bool()
    var moviePlayer:MPMoviePlayerController!
    var audioPlayer: AVAudioPlayer?
  
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 10
        self.view.layer.borderWidth = 2
        self.view.layer.borderColor = UIColor.white.cgColor

        cancelBtn.layer.cornerRadius = 22.5
        cancelBtn.layer.borderWidth = 2
        cancelBtn.layer.borderColor = UIColor.white.cgColor

        displayView.layer.cornerRadius = 10
        displayView.layer.borderWidth = 2
        displayView.layer.borderColor = UIColor.white.cgColor


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           imgView.image = #imageLiteral(resourceName: "video_img")
           self.audioPlayer = nil
           isPlaying = false
    }

    @IBAction func playButtonAction(_ sender: Any)
    {
        if !isPlaying {
            isPlaying = true
            imgView.image = #imageLiteral(resourceName: "grayPause")
              playAudio()
        }
        else {
            imgView.image = #imageLiteral(resourceName: "video_img")
            self.audioPlayer?.stop()
            self.audioPlayer = nil
            isPlaying = false
        }

    }

    @IBAction func cancelButtonAction(_ sender: Any)
    {
        self.audioPlayer?.stop()
        self.audioPlayer = nil
        self.noAction!()

    }

    func playAudio()
    {
        self.activityIndicator.startAnimating()


       // let urlstring = receivedUrl
        let url = receivedUrl
        DispatchQueue.global(qos: .background).async {


            do
            {
                //let data = try Data.init(contentsOf: url!)

                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()


                    do {
                        //self.showActivityIndicatory()
                        //self.createSpinnerView()

                        self.audioPlayer = try AVAudioPlayer(data:self.receivedData! as Data )
                        
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

    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        imgView.image = #imageLiteral(resourceName: "video_img")
        isPlaying = false
        self.audioPlayer?.stop()
        self.audioPlayer = nil
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
