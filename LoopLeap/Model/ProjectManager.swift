//
//  ProjectManager.swift
//  LoopLeap
//
//  Created by IOS3 on 20/09/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit
import SystemConfiguration
import NVActivityIndicatorView
import AVFoundation
public typealias blockAction = () -> Void
var deviceToken = String()
var activeStatus = Bool()

protocol uploadSingleFileDelegate {
    func updateSingleFilelabel()
}

protocol uploadFilesDelegate {
    func updateFileslabel()
}

protocol releaseChildDelegate {
    func changeReleaseChildStatus()
}

protocol TimelineDelegate {
    func refreshTimeLine()
}

protocol progressDismissDelegate {
    func progressDismiss()
}


class ProjectManager: NSObject {
    
    
    var childDelegate: refreshChildListDelegate?
    var addedChildDelegate: refreshAddedChildDelegate?
    var uploadDelegate: uploadFilesDelegate?
    var backtoprtalDelegate : childDashboardDelegate?
    var releaseDelegate : releaseChildDelegate?
    var refreshTimeLineDelegate : TimelineDelegate?
    var progressDelegate : progressDismissDelegate?
    var uploadSingleDelegate : uploadSingleFileDelegate?



    static let sharedInstance = ProjectManager()
    
    private override init() {
        
    }
    
    //MARK:-
    //MARK:- Call Webservice Method
    
    func callApiWithParameters(params:[String:Any], url:String , image: UIImage? , imageParam:String,completionHandler:@escaping([String:Any]?,Error?)->Void) {
        


            print(url , params)
            if isInternetAvailable() {

                if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
                {
                    let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as? String


                    var r  = URLRequest(url: URL(string: "\(url)")!)
                    r.httpMethod = "POST"
                    let boundary = "Boundary-\(UUID().uuidString)"
                    r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    r.addValue("application/json", forHTTPHeaderField: "Accept")
                    r.addValue(token_type! + accessToken , forHTTPHeaderField: "Authorization")





                    let filename = String( Date().ticks) + ".jpg"
                    if image != nil {
                        if image?.size != CGSize.zero {

                            r.httpBody = createBody(parameters: params as! [String : Any],
                                                    boundary: boundary,
                                                    data: UIImageJPEGRepresentation(image!, 0.4)!,
                                                    mimeType: "image/jpeg",
                                                    filename: filename, imageParam: imageParam)
                        }
                        else {
                            r.httpBody = createBody(parameters: params as! [String : String],
                                                    boundary: boundary,
                                                    data: nil,
                                                    mimeType: "image/jpeg",
                                                    filename: filename, imageParam: imageParam)
                        }
                    }

                    else {
                        r.httpBody = createBody(parameters: params as! [String : String],
                                                boundary: boundary,
                                                data: nil,
                                                mimeType: "image/jpeg",
                                                filename: filename, imageParam: imageParam)

                    }
                    let sessionConfig = URLSessionConfiguration.default
                    sessionConfig.timeoutIntervalForRequest = 50.0
                    sessionConfig.timeoutIntervalForResource = 50.0



                    let session = URLSession(configuration: sessionConfig)

                    //        let session = URLSession.shared
                    let task = session.dataTask(with: r as URLRequest) { data, response, error in
                        guard let data = data, error == nil else {
                            print("error=\(String(describing: error))")
                            DispatchQueue.main.async { ProjectManager.sharedInstance.showServerError(viewController:UIApplication.topViewController()!)
                                completionHandler(nil , error)
                            }
                            return
                        }

                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(String(describing: response))")
                            DispatchQueue.main.async {
                                ProjectManager.sharedInstance.showServerError(viewController:UIApplication.topViewController()!)
                                completionHandler(nil , error)
                            }


                        }


                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let responseJSON = responseJSON as? [String : Any] {
                            print(responseJSON)
                            DispatchQueue.main.async {
                                completionHandler(responseJSON   , nil)
                            }


                        }

                    }

                    task.resume()
                }
        }
        else {
            DispatchQueue.main.async(execute: {
                ProjectManager.sharedInstance.stopLoader()
                ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
            })
        }
        
    }



    func callApiWithoutHeader(params:[String:Any], url:String , image: UIImage? , imageParam:String,completionHandler:@escaping([String:Any]?,Error?)->Void) {

//        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
//        {
//            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as? String

            print(url , params)
            if isInternetAvailable() {
                var r  = URLRequest(url: URL(string: "\(url)")!)
                r.httpMethod = "POST"
                let boundary = "Boundary-\(UUID().uuidString)"
                r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//                r.addValue("application/json", forHTTPHeaderField: "Accept")
//                r.addValue(token_type! + accessToken , forHTTPHeaderField: "Authorization")





                let filename = String( Date().ticks) + ".jpg"
                if image != nil {
                    if image?.size != CGSize.zero {

                        r.httpBody = createBody(parameters: params as! [String : String],
                                                boundary: boundary,
                                                data: UIImageJPEGRepresentation(image!, 0.4)!,
                                                mimeType: "image/jpeg",
                                                filename: filename, imageParam: imageParam)
                    }
                    else {
                        r.httpBody = createBody(parameters: params as! [String : String],
                                                boundary: boundary,
                                                data: nil,
                                                mimeType: "image/jpeg",
                                                filename: filename, imageParam: imageParam)
                    }
                }

                else {
                    r.httpBody = createBody(parameters: params as! [String : String],
                                            boundary: boundary,
                                            data: nil,
                                            mimeType: "image/jpeg",
                                            filename: filename, imageParam: imageParam)

                }
                let sessionConfig = URLSessionConfiguration.default
                sessionConfig.timeoutIntervalForRequest = 50.0
                sessionConfig.timeoutIntervalForResource = 50.0



                let session = URLSession(configuration: sessionConfig)

                //        let session = URLSession.shared
                let task = session.dataTask(with: r as URLRequest) { data, response, error in
                    guard let data = data, error == nil else {
                        print("error=\(String(describing: error))")
                        DispatchQueue.main.async { ProjectManager.sharedInstance.showServerError(viewController:UIApplication.topViewController()!)
                            completionHandler(nil , error)
                        }
                        return
                    }

                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response))")
                        DispatchQueue.main.async {
                            ProjectManager.sharedInstance.showServerError(viewController:UIApplication.topViewController()!)
                            completionHandler(nil , error)
                        }


                    }


                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String : Any] {
                        print(responseJSON)
                        DispatchQueue.main.async {
                            completionHandler(responseJSON   , nil)
                        }


                    }

                }

                task.resume()
            }
       // }
        else {
            DispatchQueue.main.async(execute: {
                ProjectManager.sharedInstance.stopLoader()
                ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
            })
        }

    }


    
    func createBody(parameters: [String: Any],
                    boundary: String,
                    data: Data?,
                    mimeType: String,
                    filename: String , imageParam:String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        if data != nil {
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(imageParam)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data!)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
            
        }
        return body as Data
    }
    
    
    func callApi(url:String,completionHandler:@escaping([String:Any]?,Error?)->Void)
    {
        print(url)

        if let accessToken = UserDefaults.standard.value(forKey:DefaultsIdentifier.access_token) as? String
        {

            let token_type = UserDefaults.standard.value(forKey:DefaultsIdentifier.token_type) as? String

            if isInternetAvailable() {
                var r  = URLRequest(url: URL(string: "\(url)")!)
                r.httpMethod = "GET"
                let boundary = "Boundary-\(UUID().uuidString)"
                //  r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                r.setValue("application/json", forHTTPHeaderField: "Accept")
                r.addValue(token_type! + accessToken , forHTTPHeaderField: "Authorization")


                let sessionConfig = URLSessionConfiguration.default
                sessionConfig.timeoutIntervalForRequest = 50.0
                sessionConfig.timeoutIntervalForResource = 50.0



                let session = URLSession(configuration: sessionConfig)

                //        let session = URLSession.shared
                let task = session.dataTask(with: r as URLRequest) { data, response, error in
                    guard let data = data, error == nil else {
                        print("error=\(String(describing: error))")
                        DispatchQueue.main.async { ProjectManager.sharedInstance.showServerError(viewController:UIApplication.topViewController()!)
                            completionHandler(nil , error)
                        }
                        return
                    }

                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response))")
                        DispatchQueue.main.async {
                            ProjectManager.sharedInstance.showServerError(viewController:UIApplication.topViewController()!)
                            completionHandler(nil , error)
                        }


                    }


                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String : Any] {
                        print(responseJSON)
                        DispatchQueue.main.async {
                            completionHandler(responseJSON   , nil)
                        }


                    }

                }

                task.resume()
            }

        }
        else {
            DispatchQueue.main.async(execute: {
                ProjectManager.sharedInstance.stopLoader()
                ProjectManager.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
            })
        }
        
    }
    
    //MARK:-
    //MARK:- LOADER
    
    func showLoader(){
        let color = UIColor(red: 45/255.0 , green: 211/255.0, blue: 234/255.0, alpha: 1.0)
        let loader = NVActivityIndicatorView(frame: UIApplication.topViewController()!.view.frame , type:NVActivityIndicatorType.ballSpinFadeLoader , color: color, padding:0.0 )
        loader.startAnimating()
        let activityData = ActivityData()
        NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
        NVActivityIndicatorView.DEFAULT_TEXT_COLOR = color
//        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = title as String
//        NVActivityIndicatorPresenter.sharedInstance.setMessage(title)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        
    }
    func stopLoader(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
    }
    
    func checkResponseForString(jsonKey : NSString , dict: [String:Any]) -> NSString{
        if((dict[jsonKey as String]) != nil  &&  !(dict[ jsonKey as String] is NSNull)){
            if(dict[ jsonKey as String] is String){
                var value  = dict[jsonKey as String] as! NSString
                if(value != "NA"){
                    value = convertUnicodeToEmoji(str: value as String) as NSString
                    return value
                }
            }
                
            else if(dict[ jsonKey as String] is Int){
                let value = String(describing:dict[jsonKey as String] as! Int)
                return "\(value)" as NSString
            }else if(dict[ jsonKey as String] is NSNumber){
                let value = NumberFormatter().string(from:[ jsonKey as String] as! NSNumber)
                return value! as NSString
            }

            
        }
        return ""
    }

//    func checkResponseFor(jsonKey1 : [String:Any] , dict: [String:Any]) -> NSString{
//        if((dict[jsonKey1 as [String:Any]]) != nil  &&  !(dict[ jsonKey1 as [String:Any]] is NSNull)){
//
//        }
//        return ""
//    }

    func convertUnicodeToEmoji(str : String) -> String{
        let data : NSData = str.data(using: String.Encoding.utf8)! as NSData
        let convertedStr = NSString(data: data as Data, encoding: String.Encoding.nonLossyASCII.rawValue)
        if(convertedStr != nil ){
            return (convertedStr! as String)
        }
        return str
    }
    
    
    func getFileObjects(array:NSArray) -> [FilesObject] {
        var filesArray = [FilesObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = FilesObject()
            obj.FileName = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_original_name" , dict: dict) as String
            obj.DirID = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_id" , dict: dict) as String
            obj.FileID = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            obj.FileSize = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_size" , dict: dict) as String
            obj.FileDate = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_date" , dict: dict) as String
            obj.UserID = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"user_id" , dict: dict) as String
            filesArray.append(obj)
        }
        return filesArray
    }

    func GetAnswersObjects(array:NSArray) -> [GetAnswersObject] {
        var answersArray = [GetAnswersObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = GetAnswersObject()
            if let quesDict = dict["default_questions"] as? [String:Any] {
             obj.default_questions_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: quesDict) as String
            obj.question =  ProjectManager.sharedInstance.checkResponseForString(jsonKey:"question" , dict: quesDict) as String
            }
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            obj.question_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"question_id" , dict: dict) as String
            obj.recorded_answer = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"recorded_answer" , dict: dict) as String
            obj.recording_link = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"recording_link" , dict: dict) as String
             obj.recorded_link = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"recorded_link" , dict: dict) as String
            obj.text_answer = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"text_answer" , dict: dict) as String
            obj.answer_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"answer_id" , dict: dict) as String
            obj.question_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"answer_type" , dict: dict) as String
            answersArray.append(obj)
        }
        return answersArray
    }

    func GetTimeLineFileObjects(array:NSArray) -> [GetTimeLineFileObject] {
        var answersArray = [GetTimeLineFileObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = GetTimeLineFileObject()

            obj.file_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_date" , dict: dict) as String
            obj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_id" , dict: dict) as String
            obj.file_link = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_link" , dict: dict) as String
            obj.file_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_name" , dict: dict) as String
            obj.file_original_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_original_name" , dict: dict) as String
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            obj.tags = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"tags" , dict: dict) as String
            answersArray.append(obj)
        }
        return answersArray
    }

    func GetNotificationListObjects(array:NSArray) -> [GetNotificationListObject] {
        var answersArray = [GetNotificationListObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = GetNotificationListObject()

            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            obj.notification = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"notification" , dict: dict) as String
            obj.created_at = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"created_at" , dict: dict) as String

            answersArray.append(obj)
        }
        return answersArray
    }
    
    func GetDirectoryListObjects(array:NSArray) -> [GetDirectoryListObject] {
        var directoryArray = [GetDirectoryListObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = GetDirectoryListObject()
            
            obj.dir_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_date" , dict: dict) as String
            obj.dir_icon = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_icon" , dict: dict) as String
            obj.dir_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_name" , dict: dict) as String
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            obj.main_dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"main_dir_id" , dict: dict) as String
            obj.is_public = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public" , dict: dict) as String
            obj.public_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_date" , dict: dict) as String
             obj.public_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_type" , dict: dict) as String
             obj.user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"user_id" , dict: dict) as String
            directoryArray.append(obj)
        }
        return directoryArray
    }
    
    func GetKeyHolderListObjects(array:NSArray) -> [KeyHolderObject] {
        var keyholderArray = [KeyHolderObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = KeyHolderObject()
          
            if let userDict = dict["users"] as? [String:Any] {
                obj.name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"name" , dict: userDict) as String
                obj.email = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"email" , dict: userDict) as String
                obj.address_line_1 = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"address_line_1" , dict: userDict) as String
                obj.phone = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"phone" , dict: userDict) as String
                obj.user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: userDict) as String
                obj.role = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"role" , dict: userDict) as String
                obj.status = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"status" , dict: userDict) as String
                 obj.pro_pic = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"pro_pic" , dict: userDict) as String
            }
            
//            if let user_sub_directories = dict["accessable_dirs"] as? [String:Any] {
//                obj.dir_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_date" , dict: user_sub_directories) as String
//                obj.dir_icon = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_icon" , dict: user_sub_directories) as String
//                obj.dir_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_name" , dict: user_sub_directories) as String
//                obj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: user_sub_directories) as String
//                obj.main_dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"main_dir_id" , dict: user_sub_directories) as String
//                obj.is_public = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public" , dict: user_sub_directories) as String
//                obj.public_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_date" , dict: user_sub_directories) as String
//                obj.public_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_type" , dict: user_sub_directories) as String
//            }
            
            
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            obj.receiver_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"receiver_id" , dict: dict) as String
            obj.sender_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"sender_id" , dict: dict) as String
            obj.release_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"release_date" , dict: dict) as String
            obj.release_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"release_type" , dict: dict) as String
            
            obj.dir_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_name" , dict: dict) as String
            
            obj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            
            
            if  let accessable_dirs = dict["accessable_dirs"] as? NSArray {
            
                for i in accessable_dirs {
                let subobj = KeyHolderObject()
                
                subobj.dir_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_date" , dict: i as! [String : Any]) as String
                subobj.dir_icon = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_icon" , dict: i as! [String : Any]) as String
                subobj.dir_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_name" , dict: i as! [String : Any]) as String
                
                subobj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id", dict: i as! [String : Any]) as String
                
                subobj.main_dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"main_dir_id" , dict: i as! [String : Any]) as String
                
                subobj.is_public = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public" ,  dict: i as! [String : Any]) as String
                
                subobj.public_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_date" , dict: i as! [String : Any]) as String
                subobj.public_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_type" , dict: i as! [String : Any]) as String
                
                obj.accessible_dir.append(subobj)
            }
            
        }
          
            if  let user_files = dict["user_files"] as? NSArray {
                
                for i in user_files {
                    let subobj = KeyHolderObject()
                    
                    subobj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_id" , dict: i as! [String : Any]) as String
                    subobj.file_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_date" , dict: i as! [String : Any]) as String
                    subobj.file_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_name" , dict: i as! [String : Any]) as String
                    
                    subobj.file_original_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_original_name", dict: i as! [String : Any]) as String
                    
                    subobj.file_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: i as! [String : Any]) as String
                    
                    subobj.reorder = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"reorder" ,  dict: i as! [String : Any]) as String
                    
                    subobj.tags = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"tags" , dict: i as! [String : Any]) as String
                    
                    subobj.file_user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"user_id" , dict: i as! [String : Any]) as String
                    
                    obj.user_files.append(subobj)
                }
                
            }

            keyholderArray.append(obj)
            
            
        }
        
        
        
        return keyholderArray
    }
    
    func GetAccessibleDirectroies(array:NSArray) -> [KeyHolderObject] {
        var directoryArray = [KeyHolderObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = KeyHolderObject()
            
            obj.dir_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_date" , dict: dict) as String
            obj.dir_icon = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_icon" , dict: dict) as String
            obj.dir_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_name" , dict: dict) as String
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            obj.main_dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"main_dir_id" , dict: dict) as String
            obj.is_public = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public" , dict: dict) as String
            obj.public_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_date" , dict: dict) as String
            obj.public_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_type" , dict: dict) as String
            obj.user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"user_id" , dict: dict) as String
            directoryArray.append(obj)
        }
        return directoryArray
    }
    
    func GetPendingKeyHolderListObjects(array:NSArray) -> [KeyHolderObject] {
        var pendingKeyholderArray = [KeyHolderObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = KeyHolderObject()

                obj.name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"invite_name" , dict: dict) as String
                obj.email = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"invite_email" , dict: dict) as String
                obj.address_line_1 = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"invite_address" , dict: dict) as String
                obj.phone = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"invite_phone" , dict: dict) as String
               obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" ,   dict: dict) as String
               obj.sender_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"sender_id" , dict: dict) as String

            pendingKeyholderArray.append(obj)
        }
        return pendingKeyholderArray
    }
    
    func GetAcceptedInvitationListObjects(array:NSArray) -> [KeyHolderObject] {
        var acceptedInvitationArray = [KeyHolderObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = KeyHolderObject()
            
            if let userDict = dict["users2"] as? [String:Any] {
                obj.name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"name" , dict: userDict) as String
                obj.email = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"email" , dict: userDict) as String
                obj.address_line_1 = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"address_line_1" , dict: userDict) as String
                obj.phone = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"phone" , dict: userDict) as String
                obj.user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: userDict) as String
                obj.role = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"role" , dict: userDict) as String
                obj.status = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"status" , dict: userDict) as String
                obj.pro_pic = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"pro_pic" , dict: userDict) as String
                 obj.public_upon_death = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_upon_death" , dict: userDict) as String
            }
   
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            obj.receiver_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"receiver_id" , dict: dict) as String
            obj.sender_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"sender_id" , dict: dict) as String
             obj.view_shared_link = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"view_shared_link" , dict: dict) as String
           
            
            acceptedInvitationArray.append(obj)
        }
        return acceptedInvitationArray
    }
    
    func GetDirectoriesListObjects(array:NSArray) -> [DirectoriesListObject] {
        var directoryArray = [DirectoriesListObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = DirectoriesListObject()

            obj.dir_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_date" , dict: dict) as String
            obj.dir_icon = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_icon" , dict: dict) as String
             obj.dir_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_name" , dict: dict) as String
             obj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
             obj.main_dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"main_dir_id" , dict: dict) as String
             obj.dir_icon = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_icon" , dict: dict) as String
             obj.is_public = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public" , dict: dict) as String
             obj.public_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_date" , dict: dict) as String
             obj.public_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_type" , dict: dict) as String


            directoryArray.append(obj)
        }
        return directoryArray
    }
    
    
    func GetuserDirListObjects(array:NSArray) -> [KeyHolderObject] {
        var directoryArray = [KeyHolderObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = KeyHolderObject()
            
            if let user_sub_directories = dict["user_sub_directories"] as? NSArray {
            
                for i in user_sub_directories {
                let subobj = KeyHolderObject()
                
                subobj.dir_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_date" , dict: i as! [String : Any]) as String
                subobj.dir_icon = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_icon" , dict: i as! [String : Any]) as String
                subobj.dir_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_name" , dict: i as! [String : Any]) as String
                
                subobj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id", dict: i as! [String : Any]) as String
                
                subobj.main_dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"main_dir_id" , dict: i as! [String : Any]) as String
                
                subobj.is_public = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public" ,  dict: i as! [String : Any]) as String
                
                subobj.public_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_date" , dict: i as! [String : Any]) as String
                subobj.public_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_type" , dict: i as! [String : Any]) as String
                
                obj.user_sub_directories.append(subobj)
            }
            
        }
            
            
            obj.dir_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_date" , dict: dict) as String
            obj.dir_icon = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_icon" , dict: dict) as String
            obj.dir_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_name" , dict:dict) as String
            
            obj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id", dict: dict) as String
            
            obj.main_dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"main_dir_id" , dict: dict) as String
            
            obj.is_public = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public" ,  dict: dict) as String
            
            obj.public_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_date" , dict: dict) as String
            obj.public_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_type" , dict:dict ) as String
 
            
            directoryArray.append(obj)
        }
        return directoryArray
    }
    
    
    
    func GetDirectoriesFilesList(array:NSArray) -> [KeyHolderObject] {
        var directroiresFilesArray = [KeyHolderObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = KeyHolderObject()
            
          
                    obj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_id" , dict: dict) as String
                    obj.created_at = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"created_at" , dict: dict) as String
                    obj.file_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_date" , dict: dict) as String
                    obj.file_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_name" , dict: dict) as String
                    
                    obj.file_original_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_original_name", dict: dict) as String
                    
                    obj.file_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
                    
                    obj.reorder = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"reorder" ,  dict: dict) as String
                    
                    obj.tags = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"tags" , dict:dict) as String
                    
                    obj.file_user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"user_id" , dict: dict) as String
            
                    obj.file_url = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_url" , dict: dict) as String
     
                  directroiresFilesArray.append(obj)
            
            
        }
        
        
        
        return directroiresFilesArray
    }
    
    func GetPublicDirObjects(array:NSArray) -> [KeyHolderObject] {
        var publicDicArray = [KeyHolderObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = KeyHolderObject()

            obj.address_line_1 = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"address_line_1" , dict: dict) as String
            obj.city = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"city" , dict: dict) as String
            
            obj.country = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"country" , dict: dict) as String
            obj.country_code = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"country_code" , dict: dict) as String
            
            obj.diary_mode = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"diary_mode" , dict: dict) as String
            obj.email = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"email" , dict: dict) as String
            
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            
            obj.name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"name" , dict: dict) as String
            
              obj.phone = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"phone" , dict: dict) as String
            
            obj.pro_pic = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"pro_pic" , dict: dict) as String
            
             obj.profile_pic_url = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"pro_pic_url" , dict: dict) as String
            
            obj.public_upon_death = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_upon_death" , dict: dict) as String
            
             obj.public_upon_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_upon_date" , dict: dict) as String
             obj.diary_mode = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"diary_mode" , dict: dict) as String
              obj.dob = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dob" , dict: dict) as String
             obj.parent_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"parent_id" , dict: dict) as String
             obj.role = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"role" , dict: dict) as String
             obj.zip = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"zip" , dict: dict) as String
            obj.mobile_activation_code = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"mobile_activation_code" , dict: dict) as String
            
             obj.released = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"released" , dict: dict) as String
            
            
            
            
            if  let user_sub_directories = dict["user_sub_directories"] as? NSArray {
                
                for i in user_sub_directories {
                    let subobj = KeyHolderObject()
                    
                    subobj.dir_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_date" , dict: i as! [String : Any]) as String
                    subobj.dir_icon = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_icon" , dict: i as! [String : Any]) as String
                    subobj.dir_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_name" , dict: i as! [String : Any]) as String
                    
                    subobj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id", dict: i as! [String : Any]) as String
                    
                    subobj.main_dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"main_dir_id" , dict: i as! [String : Any]) as String
                    
                    subobj.is_public = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public" ,  dict: i as! [String : Any]) as String
                    
                    subobj.public_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_date" , dict: i as! [String : Any]) as String
                    
                    subobj.public_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_type" , dict: i as! [String : Any]) as String
                    
                     subobj.user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"user_id" , dict: i as! [String : Any]) as String
                    
                    obj.user_sub_directories.append(subobj)
                }
                
            }
            
            if  let user_files = dict["user_files"] as? NSArray {
                
                for i in user_files {
                    let subobj = KeyHolderObject()
                    
                    subobj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_id" , dict: i as! [String : Any]) as String
                    subobj.file_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_date" , dict: i as! [String : Any]) as String
                    subobj.file_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_name" , dict: i as! [String : Any]) as String
                    
                    subobj.file_original_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_original_name", dict: i as! [String : Any]) as String
                    
                    subobj.file_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: i as! [String : Any]) as String
                    
                    subobj.reorder = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"reorder" ,  dict: i as! [String : Any]) as String
                    
                    subobj.tags = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"tags" , dict: i as! [String : Any]) as String
                    
                    subobj.file_user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"user_id" , dict: i as! [String : Any]) as String
                    
                    obj.user_files.append(subobj)
                }
                
            }
            
            publicDicArray.append(obj)
   
        }
        
        
        
        return publicDicArray
    }
    
    
    func GetVerifyOtpObjects(array:[String : Any]) -> KeyHolderObject {
        
        
        let obj = KeyHolderObject()

        if let  access_dirs = array["access_dirs"]  as? [String] {
            
            obj.access_dirs = access_dirs
        }
        
        
        if  let user_files = array["user_files"] as? NSArray {
            
            for i in user_files {
                let subobj = KeyHolderObject()
                
                subobj.dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_id" , dict: i as! [String : Any]) as String
                 subobj.created_at = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"created_at" , dict: i as! [String : Any]) as String
                subobj.file_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_date" , dict: i as! [String : Any]) as String
                subobj.file_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_name" , dict: i as! [String : Any]) as String
                
                subobj.file_original_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_original_name", dict: i as! [String : Any]) as String
                
                subobj.file_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: i as! [String : Any]) as String
                
                subobj.reorder = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"reorder" ,  dict: i as! [String : Any]) as String
                
                subobj.tags = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"tags" , dict: i as! [String : Any]) as String
                
                subobj.file_user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"user_id" , dict: i as! [String : Any]) as String
                
                 subobj.file_url = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"file_url" , dict: i as! [String : Any]) as String
                
                obj.user_files.append(subobj)
            }
            
        }
        
        if  let currentuser_details = array["currentuser_details"] as? [String: Any] {
            
             obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: currentuser_details) as String
             obj.about_me = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"about_me" , dict: currentuser_details) as String
             obj.college = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"college" , dict: currentuser_details) as String
             obj.elementry_school = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"elementry_school" , dict: currentuser_details) as String
             obj.facebook = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"facebook" , dict: currentuser_details) as String
             obj.grad_school = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"grad_school" , dict: currentuser_details) as String
             obj.high_school = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"high_school" , dict: currentuser_details) as String
             obj.instagram = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"instagram" , dict: currentuser_details) as String
             obj.linkedin = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"linkedin" , dict: currentuser_details) as String
             obj.middle_school = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"middle_school" , dict: currentuser_details) as String
            obj.place_of_birth = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"place_of_birth" , dict: currentuser_details) as String
            obj.snapchat = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"snapchat" , dict: currentuser_details) as String
            obj.twitter = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"twitter" , dict: currentuser_details) as String
            obj.updated_at = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"updated_at" , dict: currentuser_details) as String
            obj.user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"user_id" , dict: currentuser_details) as String
            obj.created_at = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"created_at" , dict: currentuser_details) as String
            
            if  let first_job = currentuser_details["first_job"] as? [String] {
                
                obj.first_job = first_job
                
            }
            
           if  let partners = currentuser_details["partners"] as? [String] {
                
                obj.partners = partners
                
            }
            
            if  let marriage_date = currentuser_details["marriage_date"] as? [String] {
                
                obj.marriage_date = marriage_date
                
            }
            
            if  let marriage_to = currentuser_details["marriage_to"] as? [String] {
                
                obj.marriage_to = marriage_to
                
            }
   
        }
        
        
        
        obj.address_line_1 = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"address_line_1" , dict: array) as String
        
        obj.child_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"child_id" , dict: array) as String
        
        obj.dob = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dob" , dict: array) as String
        
        obj.country_code = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"country_code" , dict: array) as String
        
        obj.email = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"email" , dict: array) as String
        
        obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: array) as String
        
        obj.name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"name" , dict: array) as String
        
        obj.phone = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"phone" , dict: array) as String
        
        obj.mobile_activation_code = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"mobile_activation_code" , dict: array) as String
        obj.email_activation_code = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"email_activation_code" , dict: array) as String
        
        obj.parent_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"parent_id" , dict: array) as String
        obj.pro_pic = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"pro_pic" , dict: array) as String
        obj.profile_pic_url = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"profile_pic_url" , dict: array) as String
        obj.role = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"role" , dict: array) as String
        obj.zip = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"zip" , dict: array) as String
        obj.country = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"country" , dict: array) as String
         obj.city = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"city" , dict: array) as String
          obj.receiver_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"receiver_id" , dict: array) as String
          obj.release_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"release_date" , dict: array) as String
             obj.release_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"release_type" , dict: array) as String
         obj.sender_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"release_type" , dict: array) as String
         obj.diary_mode = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"diary_mode" , dict: array) as String
        obj.public_upon_death = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"public_upon_death" , dict: array) as String
         obj.is_teenage = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"is_teenage" , dict: array) as String
          obj.newPassword = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"password" , dict: array) as String
        
         obj.vital_information = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"vital_information" , dict: array) as String
         obj.pro_pic_url = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"pro_pic_url" , dict: array) as String
        
         obj.main_dir_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"main_dir_id" , dict: array) as String
        
      
        
        
        // veriftOtpArray.append(obj)
      
        
        
        return obj
    }
    
    func GetPlanListObjects(array:NSArray) -> [GetPlanListObject] {
        var planArray = [GetPlanListObject]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = GetPlanListObject()
            
            obj.dir_size = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_size" , dict: dict) as String
            obj.id = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"id" , dict: dict) as String
            obj.plan_duration = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"plan_duration" , dict: dict) as String
            obj.plan_order = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"plan_order" , dict: dict) as String
            obj.plan_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"plan_type" , dict: dict) as String
            obj.price = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"price" , dict: dict) as String
            
            obj.customer_email = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"customer_email" , dict: dict) as String
            obj.customer_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"customer_name" , dict: dict) as String
            obj.purchased_date = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"purchased_date" , dict: dict) as String
            obj.subscription_canceled = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"subscription_canceled" , dict: dict) as String
            obj.subscription_expire = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"subscription_expire" , dict: dict) as String
            obj.subscription_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"subscription_status" , dict: dict) as String
            
            obj.dir_pending_storage = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_pending_storage" , dict: dict) as String
            obj.dir_purchase_size = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_purchase_size" , dict: dict) as String
            obj.dir_total_storage = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_total_storage" , dict: dict) as String
            obj.dir_used_storage = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_used_storage" , dict: dict) as String
             obj.plan_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"plan_status" , dict: dict) as String
            
           
            planArray.append(obj)
        }
        return planArray
    }
    
    
    func GetGeneralPaymentObjects(object:[String : Any]) -> GetPlanListObject {
        
        
        let obj = GetPlanListObject()
   
        obj.customer_email = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"customer_email" , dict: object) as String
        obj.customer_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"customer_name" , dict: object) as String
       
        obj.subscription_canceled = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"subscription_canceled" , dict: object) as String
        obj.subscription_expire = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"subscription_expire" , dict: object) as String
        
        obj.dir_pending_storage = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_pending_storage" , dict: object) as String
        
        obj.dir_purchase_size = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_purchase_size" , dict: object) as String
        
        obj.dir_total_storage = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_total_storage" , dict: object) as String
        obj.dir_used_storage = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"dir_used_storage" , dict: object) as String
        obj.plan_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"plan_status" , dict: object) as String
        obj.plan_order = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"plan_order" , dict: object) as String
        obj.plan_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"plan_type" , dict: object) as String
        obj.price = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"price" , dict: object) as String
        obj.payment_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey:"payment_status" , dict: object) as String

        return obj
    }
    

    //MARK:-
    //MARK:- EMAIL VALIDATION
    func isEmailValid(email : String) -> Bool{
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: email)
    }
    
    
    
    
    
    func getThumnailImageFromVideo(urlStr:String , completion:@escaping(UIImage?)->Void) {
        DispatchQueue.global(qos:.background).async {
            
            let asset = AVAsset(url: URL(string: urlStr)!)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            //Can set this to improve performance if target size is known before hand
            let width = (UIScreen.main.bounds.size.width - 2)/3
            //assetImgGenerate.maximumSize = CGSize(width: width, height: width + 60)
            let time = CMTimeMakeWithSeconds(1.0, 600)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                if img != nil {
                    let thumbnail = UIImage(cgImage: img)
                    //                    if  let data = thumbnail.jpeg(.lowest) {
                    //                    let image = UIImage(cgImage: img).resizeImageWith(newSize: CGSize(width: width, height: width + 60))
                    DispatchQueue.main.async {
                        // let image = UIImage(data: data)
                        completion(thumbnail)
                        
                    }
                    //                    }
                }
                
            } catch {
                
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    completion(nil)
                }
                
            }
            
        }
        
    }
    
    
    //MARK:-
    //MARK:- Check Internet Connection
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    
    func showAlertwithTitle(title:String , desc:String , vc:UIViewController)  {
        let alert = UIAlertController(title: title, message: desc, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showServerError(viewController : UIViewController) -> Void {
        
        let alertController = UIAlertController(title: "Server Error", message: "An error occurred while processing your request.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.cancel, handler: nil))
        viewController.present(alertController, animated: true, completion: nil);
    }

    func saveDeviceTokenOnServer()  {
        let uuid = "\(String(describing: UIDevice.current.identifierForVendor!))"  //UUID().uuidString
     print(uuid)

            ProjectManager.sharedInstance.callApiWithParameters(params: ["unique_device_id":uuid, "device_type":"iOS" ,"device_token":deviceToken ], url: baseURL + ApiMethods.saveDeviceTokenApi, image: nil , imageParam: "") { (result, error) in
                if error == nil {
                    print(result)
                }
            }
        
    }
}
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
extension UIApplication {
    class func topViewController(_ base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}


class UploadingPopUp: UIViewController  {
    @IBOutlet weak var progressViw: UIProgressView!
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var percentageLbl: UILabel!
    
    var cancelBtnClick:blockAction?
    var cancelAllBtnClick:blockAction?
    var multipleImage = Bool()
    var obj = ImageObject()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressViw.progress = 0.0
        
        if multipleImage {
            
            self.timeLbl.text = "1/\(obj.TotalImages)"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadDidProgress(_:)), name: .uploadProgress, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadMultipleImagesDidProgress(_:)), name: .uploadMultipleImages, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc  func uploadDidProgress(_ notification: Notification) {
        if let progress = notification.object as? Progress {
            
            if progress.fractionCompleted == 1 {
                self.dismiss(animated: true) {
                      ProjectManager.sharedInstance.uploadDelegate?.updateFileslabel()
                    
                    if !(UIApplication.topViewController() is HomeViewController) {
                        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                    }
                }
                // dismiss/exit
            }
            else {
                
                //self.timeLbl.text = "\(String(describing: progress.estimatedTimeRemaining)) sec"
                self.progressViw.progress = Float(progress.fractionCompleted)
                self.percentageLbl.text = "\(Int(Float(progress.fractionCompleted) * 100)) %"
            }
        }
        
        if let progress = notification.object as? Bool {
            if progress  {
                
                self.dismiss(animated: true) {
                   
                    
                    if !(UIApplication.topViewController() is HomeViewController) {
                        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
       
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.cancelBtnClick!()
    }
    
    @IBAction func cancelAllAction(_ sender: Any) {
        self.cancelAllBtnClick!()
    }
    @objc  func uploadMultipleImagesDidProgress(_ notification: Notification) {
        
        if let imgobj = notification.object as? ImageObject {
            
            let progress = 1.0 / Float(imgobj.TotalImages)
            if imgobj.CurrentImageNo == imgobj.TotalImages  {
                self.dismiss(animated: true) {
                    
                    
                    ProjectManager.sharedInstance.uploadDelegate?.updateFileslabel()
                    
                    if !(UIApplication.topViewController() is HomeViewController) {
                    UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                    }
                    
                   
                    
                
                    
                    
                }
            }
            else {
                self.progressViw.progress = progress * Float(imgobj.CurrentImageNo)
                self.timeLbl.text = "\(imgobj.CurrentImageNo)/\(imgobj.TotalImages)"
                self.percentageLbl.text = "\(Int(progress * Float(imgobj.CurrentImageNo) * 100)) %"
                
            }
        }
    }





    
}
class DownloadingPopup: UIViewController  {
    @IBOutlet weak var progressViw: UIProgressView!
    @IBOutlet weak var percentageLbl: UILabel!
    var obj = ImageObject()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressViw.progress = 0.0
        
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadDidProgress(_:)), name: .downloadProgress, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc  func downloadDidProgress(_ notification: Notification) {
        if let progress = notification.object as? Progress {
            
            if progress.fractionCompleted == 1 {
                self.dismiss(animated: true, completion: nil)
                
                
                // ProjectManager.sharedInstance.progressDelegate?.progressDismiss()
                
                
                // dismiss/exit
            }
            else {
                
                //self.timeLbl.text = "\(String(describing: progress.estimatedTimeRemaining)) sec"
                self.progressViw.progress = Float(progress.fractionCompleted)
                self.percentageLbl.text = "\(Int(Float(progress.fractionCompleted) * 100)) %"
            }
        }
    }
    
    
   
    
    
}
class TextField: UITextField {
    // 8
    override func caretRect(for position: UITextPosition) -> CGRect {
    return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange)-> [Any] {
    return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) ->  Bool {
    
    if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
    
    return false
    }
    
    return super.canPerformAction(action, withSender: sender)
    }
}


extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
