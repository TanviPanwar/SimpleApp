//
//  Constants.swift
//  LoopLeap
//
//  Created by IOS3 on 20/09/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import Foundation


//let baseURL = "http://18.220.137.253/loopleap/api/"

//let fileDownloadBaseURL = "http://18.220.137.253/loopleap/api/testdownload"


let baseURL = "https://loopleap.visionsdemo.com/api/" //dev: "https://dev.loopleap.com/api/"  //live: "https://www.loopleap.com/api/"
//let baseURL = "https://www.loopleap.com/api/" //-- live
let domain = "loopleap.visionsdemo.com"   //live: "www.loopleap.com"  //dev: "dev.loopleap.com"

//let fileDownloadBaseURL = "https://dev.loopleap.com/api/download"  //-- dev
let fileDownloadBaseURL = "https://loopleap.visionsdemo.com/api/" //"https://www.loopleap.com/api/download" //-- live

struct ApiMethods {
    static let loginAPI = "login"
    static let signUpAPI = "register"
    static let setPasswordAPI = "setpassword"
    static let forgotPasswordAPI = "forgetpassword"
    static let uploadFileAPI = "uploadfile"
    static let getFilesAPI = "getfiles"
    static let deleteFileAPI = "delete"
    static let checkVerificationAPI  = "checkVerification"
    static let getQuestionApi = "getquestion?"
    static let saveDeviceTokenApi = "savedevicetoken"
    static let notificationslist = "notificationslist"
    static let clearnotification = "clearnotification"
    static let tags =  "tags"
    static let savedailyupdate = "savedailyupdate"
    static let viewallanswers = "viewallanswers"
    static let editquestion =  "editquestion"
    static let deletequestion =  "deletequestion"
    static let savecustomquestion =  "savecustomquestion"
    static let timelineyears =  "timelineyears"
    static let gettimelinefiles =  "gettimelinefiles"
    static let viewalltimelinefiles = "viewalltimelinefiles"
    static let getquestion = "getquestion?"
    static let savequestion = "savequestion"
    static let saveintro =  "saveintro"
    static let startquestionnaire = "startquestionnaire"
    static let logout = "logout"
    static let clearallnotification = "clearallnotification"
    static let getDirectoriesList = "directories"
    static let addDirectories = "addDirectories"
    static let editDirectories = "editDirectories"
    static let deleteDirectories = "deleteDirectories"
    static let keyholder = "keyholder"
    static let deleteKeyholder = "deleteKeyholder"
    static let acceptRejectKeyholder = "acceptRejectKeyholder"
    static let updateKeyholder = "updateKeyholder"
    static let requestAccess = "requestAccess"
    static let viewSharedAnswers = "viewSharedAnswers"
    static let userKeyholderDirectories = "userKeyholderDirectories"
    static let addKeyholder = "addKeyholder"
    static let getDirectoryFiles = "getDirectoryFiles"
    static let deleteFile = "deleteFile"
    static let updateFile = "updateFile"
    static let moveFile = "moveFile"
    static let publicProfile = "publicProfile"
    static let contact = "contact"
    static let investor = "investor"
    static let childList = "childlist"
    static let deleteChild = "deleteChild"
    static let releaseChild = "releaseChild"
    static let impersonateChild = "impersonateChild"
    static let verifyOTP = "verifyOTP"
    static let verifyMobileOTP = "verifyMobileOTP"
    static let addChild = "addChild"
    static let updateChild = "updateChild"
    static let leaveImpersonate = "leaveImpersonate"
    static let childlistDropdown = "childlistDropdown"
    static let childDirectory = "childDirectory"
    static let getPublicDirectoriesFiles = "getPublicDirectoriesFiles"
    static let getPublicDirectory = "getPublicDirectory"
    static let searchDirectoryFiles = "searchDirectoryFiles"
    static let searchSharedDirectoryFiles = "searchSharedDirectoryFiles"
    static let getPublicDirectoryWithPaging = "getPublicDirectoryWithPaging"
    static let setUpChild = "setUpChild"
    static let settings = "settings"
    static let viewSharedDirectoriesFiles = "viewSharedDirectoriesFiles"
    static let getSharedDirectoriesWithPagination = "getSharedDirectoriesWithPagination"
    static let createplan = "createplan"
    static let getpaymentoken = "getpaymentoken"
    static let transactionhistory = "transactionhistory"
    static let paymentgeneraldata = "paymentgeneraldata"
    static let cancelsubscription = "cancelsubscription"


















}
struct DefaultsIdentifier {
    
    static let userID = "userID"
    static let login = "Login"
    static let access_token = "access_token"
    static let token_type = "token_type"
    static let dir_data = "dirData"
    static let role = "role"
    static let parent_id = "parent_id"
    static let plan_status = "plan_status"
    static let plan_order = "plan_order"
    static let plan_id = "plan_id"
    static let parent_access_token = "parent_access_token"





}
