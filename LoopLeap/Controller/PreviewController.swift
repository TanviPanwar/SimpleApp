//
//  PreviewController.swift
//  LoopLeap
//
//  Created by IOS3 on 05/10/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog

protocol GetImageDelegate {
   func didGetImage(image : UIImage)
}



class PreviewController: UIViewController , URLSessionDelegate , URLSessionDataDelegate {
    @IBOutlet weak var previewImgViw: UIImageView!
    
   @IBOutlet weak var canvasView: UIView!
   var stickerView: UIImageView!
   var selectedImg = UIImage()
   var editedImage = UIImage()
   var directoryBool = true
    var delegate : GetImageDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.previewImgViw.image = selectedImg

      
      
      stickerView = makeStickerView(with: selectedImg, center: previewImgViw.center)
      self.addGestures(stickerView: stickerView)
      canvasView.addSubview(stickerView)
        // Do any additional setup after loading the view.
    }
    func addGestures( stickerView: UIImageView) {
      let stickerPinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(stickerDidPinch))
      stickerView.addGestureRecognizer(stickerPinchGesture)
      
   }
    
   @objc private func stickerDidPinch(pincher: UIPinchGestureRecognizer) {
      guard let stickerView = pincher.view else { return }
      stickerView.transform = stickerView.transform.around(pincher.location(in: stickerView), do: { $0.scaledBy(x: pincher.scale, y: pincher.scale) })
      pincher.scale = 1
   }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func uploadAction(_ sender: Any) {
       
      
      let iamg:UIImage = UIImage(named:"splash-bg")!
      UIGraphicsBeginImageContext(canvasView.frame.size)
      iamg.draw(at: CGPoint.zero)
      let context = UIGraphicsGetCurrentContext()
      
      // set fill gray and alpha
      context!.setFillColor(gray: 0, alpha: 1.0)
      context!.move(to: CGPoint(x: 0, y: 0))
      context!.fill(CGRect(x: 0, y: 0, width: iamg.size.width, height: iamg.size.height))
      context!.strokePath()
      let resultImage = UIGraphicsGetImageFromCurrentImageContext()
      
      // end the graphics context
      UIGraphicsEndImageContext()
      
      let image = resultImage
      
      var images: [(image: UIImage, viewSize: CGSize, transform: CGAffineTransform)] = []
      
      if let stickerViewImage = stickerView.image {
         images.append((image: stickerViewImage, viewSize: stickerView.bounds.size, transform: stickerView.transform))
      }
      
      let img = image?.merge(in: canvasView.frame.size, viw: canvasView, with: images)
      
      
        let size = UIImageJPEGRepresentation(img!, 1.0)
        let sizeInMb:Float = (Float(size!.count)/Float(1024))/Float(1024)
        if sizeInMb > 20 {
            
            let alertController = UIAlertController(title:"Message", message:"Image size should not be greater than 20 MB", preferredStyle: .alert)
            let okAction =  UIAlertAction(title:"OK", style:.default) { (action) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else {
         
         if directoryBool {
            
            if delegate != nil {
               delegate?.didGetImage(image: img!)
            }
            self.dismiss(animated: true, completion: nil)
            
         }
            
         else {
            
            let url = baseURL + ApiMethods.uploadFileAPI
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let imgParam = "files"
            let fileSize = UIImageJPEGRepresentation(img!, 1.0)!.count / 1024
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
                     multipartFormData.append(UIImageJPEGRepresentation(img!, 1.0)!, withName: imgParam, fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
                     for (key, value) in params {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                     }
                  }, to:url, headers:headers)
                  { (result) in
                     ProjectManager.sharedInstance.stopLoader()
                     
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
   
    
    //MARK:-
    //MARK:- URL Session Delegate
    
    
    @IBAction func saveToGalleryAction(_ sender: Any) {
        //let image = previewImgViw.image!
//        var drawingRect : CGRect = CGRect.zero
//        drawingRect.size = previewImgViw.frame.size
//        let scale = previewImgViw.frame.width / (previewImgViw.image?.size.width)!
//        let height = (previewImgViw.image?.size.height)! * scale
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: previewImgViw.frame.width, height: height), true, 0)
//        let context = UIGraphicsGetCurrentContext()
//        //Set Center Position before Scale, Rotate Image
//        context?.translateBy(x: previewImgViw.frame.width / 2, y: height / 2)
//        //Applied Translate, Scale, Rotate
//        context!.concatenate(previewImgViw.transform)
//        context?.translateBy(x: -(previewImgViw.frame.width / 2), y: -(height / 2))
//        image.draw(in: CGRect(x: 0, y: 0, width: previewImgViw.frame.width, height: height))
//        UIRectFill(previewImgViw.frame)
//        editedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
//        UIGraphicsEndImageContext();
      let iamg:UIImage = UIImage(named:"splash-bg")!
      UIGraphicsBeginImageContext(canvasView.frame.size)
      iamg.draw(at: CGPoint.zero)
      let context = UIGraphicsGetCurrentContext()
      
      // set fill gray and alpha
      context!.setFillColor(gray: 0, alpha: 1.0)
      context!.move(to: CGPoint(x: 0, y: 0))
      context!.fill(CGRect(x: 0, y: 0, width: iamg.size.width, height: iamg.size.height))
      context!.strokePath()
      let resultImage = UIGraphicsGetImageFromCurrentImageContext()
      
      // end the graphics context
      UIGraphicsEndImageContext()
      
       let image = resultImage
      
      var images: [(image: UIImage, viewSize: CGSize, transform: CGAffineTransform)] = []
      
      if let stickerViewImage = stickerView.image {
         images.append((image: stickerViewImage, viewSize: stickerView.bounds.size, transform: stickerView.transform))
      }
      
      let img = image?.merge(in: canvasView.frame.size, viw: canvasView, with: images)
        
      UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil)
      self.dismiss(animated: true) {
          ProjectManager.sharedInstance.showAlertwithTitle(title:"", desc: "Image saved successfully.", vc: UIApplication.topViewController()!)
      }
      
    }
   private func makeStickerView(with image: UIImage, center: CGPoint) -> UIImageView {
      let heightOnWidthRatio = image.size.height / image.size.width
      let imageWidth: CGFloat = UIScreen.main.bounds.size.width
      
      //      let newStickerImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: imageWidth, height: imageWidth * heightOnWidthRatio)))
      
      
      let height = imageWidth * heightOnWidthRatio
      let view = UIImageView(frame: CGRect(x: 0, y: (canvasView.frame.size.height - height)/2, width: imageWidth, height: height))
      view.image = image
      view.clipsToBounds = true
      view.contentMode = .scaleAspectFit
      view.isUserInteractionEnabled = true
      //view.backgroundColor = UIColor.red.withAlphaComponent(0.7)
      //view.layer.anchorPoint = .zero
      //view.layer.position = .zero
      return view
   }
    @objc func pinchaction(_ sender: UIPinchGestureRecognizer) {
        
        previewImgViw.transform = previewImgViw.transform.scaledBy(x: sender.scale, y: sender.scale)
        
        sender.scale = 0.5
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
extension UIImage {
    
    func maskWithColor( color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        color.setFill()
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        context.draw(self.cgImage!, in: rect)
        
        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage!
    }
}




extension Notification.Name {
    static let downloadProgress = Notification.Name("DownloadProgress")
    static let uploadProgress = Notification.Name("UploadProgress")
    static let uploadMultipleImages = Notification.Name("uploadMultipleImages")
}
extension UIImage {
   
   func merge(in viewSize: CGSize, viw imageViw:UIView ,with imageTuples: [(image: UIImage, viewSize: CGSize, transform: CGAffineTransform)]) -> UIImage? {
      UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
      
      print("scale : \(UIScreen.main.scale)")
      print("size : \(size)")
      print("--------------------------------------")
      
      guard let context = UIGraphicsGetCurrentContext() else { return nil }
      
      // Scale the context geometry to match the size of the image view that displayed me, because that's what all the transforms are relative to.
      context.scaleBy(x: size.width / viewSize.width, y: size.height / viewSize.height)
      
      draw(in: CGRect(origin: .zero, size: viewSize), blendMode: .normal, alpha: 1)
      
      for imageTuple in imageTuples {
         let size = CGSize(width:(imageTuple.viewSize.width * imageTuple.transform.a) , height: (imageTuple.viewSize.height * imageTuple.transform.a))
         
         let areaRect =  CGRect(x:(imageViw.frame.size.width - size.width)/2, y: (imageViw.frame.size.height-size.height)/2, width: size.width, height:  size.height)
         print(size)
         context.saveGState()
//         context.concatenate(imageTuple.transform)
      
         context.setBlendMode(.color)
         UIColor.purple.withAlphaComponent(0.5).setFill()
         context.fill(areaRect)
         let img = imageTuple.image
         imageTuple.image.draw(in: areaRect, blendMode: .normal, alpha: 1)
         
         context.restoreGState()
      }
      
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      print(image?.size)
      return image
   }
}
extension CGAffineTransform {
   func around(_ locus: CGPoint, do body: (CGAffineTransform) -> (CGAffineTransform)) -> CGAffineTransform {
      var transform = self.translatedBy(x: 0.5, y: 0.5)
      transform = body(transform)
      transform = transform.translatedBy(x: -0.5, y: -0.5)
      return transform
   }
}
