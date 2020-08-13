//
//  AppDelegate.swift
//  LoopLeap
//
//  Created by IOS3 on 13/09/18.
//  Copyright © 2018 IOS3. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID
import PopupDialog
import Stripe



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        STPPaymentConfiguration.shared().publishableKey = "pk_test_EWFyZnPqIaMJL0LbkHjhSKcp"  // "pk_test_Z4hV9AHaO1R99jf4D3FAyDA400oafruhIE"

        
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.disabledToolbarClasses = [UploadFileViewController.self, RecordVideoAudioViewController.self, ContainerForUploadViewController.self, AddKeyHolderViewController.self, EditKeyHolderViewController.self, SelectedNotificationViewController.self , UpdateProfileViewController.self , AddChildProfileViewController.self, EditDirectoryViewController.self, CreateDirectoryViewController.self, MoveFilePopup.self, EditFilePopup.self]
        
        
        let login = UserDefaults.standard.value(forKey: DefaultsIdentifier.login)
        
        if login is String  {
            
            if (login as! String) == "login" {
                let storyBoard = UIStoryboard(name:"Main", bundle: nil)
//                let vc :HomeViewController = storyBoard.instantiateViewController(withIdentifier:"HomeViewController") as! HomeViewController
                 let vc :TimeLineHistoryViewController = storyBoard.instantiateViewController(withIdentifier:"TimeLineHistoryViewController") as! TimeLineHistoryViewController
                
               // let nav = UINavigationController(rootViewController:vc)
               // self.window?.rootViewController = nav
                
                
                
                
               // let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContentNavigation")
                
                let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.rootViewController = SideMenuController(contentViewController: vc,
                                                                menuViewController: menuViewController)
                
            }
            
            else {
                
                
                let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContentNavigation")
                
                //            let storyBoard = UIStoryboard(name:"Main", bundle: nil)
                //            let vc :LoginViewController = storyBoard.instantiateViewController(withIdentifier:"LoginViewController") as! LoginViewController
                
                let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.rootViewController = SideMenuController(contentViewController: contentViewController,
                                                                menuViewController: menuViewController)
                
                
                
            }
        
        }
        
        else {
            
            
            let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContentNavigation")
            
//            let storyBoard = UIStoryboard(name:"Main", bundle: nil)
//            let vc :LoginViewController = storyBoard.instantiateViewController(withIdentifier:"LoginViewController") as! LoginViewController
            
            let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = SideMenuController(contentViewController: contentViewController,
                                                            menuViewController: menuViewController)
            
            
            
        }

       FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
       Messaging.messaging().delegate = self

        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
   //  IQKeyboardManager.shared.disabledToolbarClasses = [UploadFileViewController.self]

        application.registerForRemoteNotifications()
  //    Messaging.messaging().delegate = self
//        UNUserNotificationCenter.current().delegate = self

       // FirebaseApp.configure()


        //application.registerForRemoteNotifications()
        //GMSServices.provideAPIKey("AIzaSyB8-1JXQwYtaVsMqHzhWkP_xYymn621-P4")
        
        //configureSideMenu()
        
        
//        let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContentNavigation")
//        let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = SideMenuController(contentViewController: contentViewController,
//                                                        menuViewController: menuViewController)
//
        return true
    }
    
    private func configureSideMenu() {
        SideMenuController.preferences.basic.menuWidth = 240
        SideMenuController.preferences.basic.defaultCacheKey = "0"
    }


//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let content = notification.request.content
//        // Process notification content
//        print("\(content.userInfo)")
//        //completionHandler([.alert, .sound]) // Display notification as
//        let userInfo = content.userInfo
//        //guard let notificationType = userInfo["type"] as? String else { return }
//
//        //
////        if notificationType == "0"{
////            if UIApplication.shared.applicationState != .background || UIApplication.shared.applicationState == .active {
////                guard let notificationTimerID = userInfo["timer_id"] as? String else { return }
////                let storyboard = UIStoryboard(name: "Main", bundle: nil)
////                let TimerDetailsVC = storyboard.instantiateViewController(withIdentifier: "TimerDetailsVC") as! TimerDetailsVC
////                TimerDetailsVC.timerID = notificationTimerID
////                UIApplication.topViewController()?.navigationController?.pushViewController(TimerDetailsVC, animated: true)
////            }
////        }
////        else if notificationType == "5"{
////            if UIApplication.shared.applicationState != .background || UIApplication.shared.applicationState == .active {
////                guard let notificationTimerID = userInfo["timer_id"] as? String else { return }
////                let storyboard = UIStoryboard(name: "Main", bundle: nil)
////                let TimerDetailsVC = storyboard.instantiateViewController(withIdentifier: "TimerDetailsVC") as! TimerDetailsVC
////                TimerDetailsVC.timerID = notificationTimerID
////                UIApplication.topViewController()?.navigationController?.pushViewController(TimerDetailsVC, animated: true)
////            }
////
////        }
////        //            else
////        if notificationType == "1"{
////            if UIApplication.shared.applicationState != .background || UIApplication.shared.applicationState == .active {
////                completionHandler([.alert, .sound])
////            }
////
////        }
////        else if notificationType == "2"{
////            if UIApplication.shared.applicationState != .background || UIApplication.shared.applicationState == .active {
////                completionHandler([.alert, .sound])
////            }
////
////        }
////        else if notificationType == "3"{
////            if UIApplication.shared.applicationState != .background || UIApplication.shared.applicationState == .active {
////                completionHandler([.alert, .sound])
////            }
////
////        }
////        else if notificationType == "4"{
////            if UIApplication.shared.applicationState != .background || UIApplication.shared.applicationState == .active {
////                completionHandler([.alert, .sound])
////            }
////
////        }
//
//
//
//    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        completionHandler()
//    }

    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
       
        print(url.path)
      //  if url .host == domain {
            if url.path == "/user/verified" {
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                 let queryItems  = components?.queryItems
                var tokenString = String()
                
                for item  in queryItems! {
                    tokenString = item.value!
                }
                        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
                        let vc :CheckDeepLinkingViewController = storyBoard.instantiateViewController(withIdentifier:"CheckDeepLinkingViewController") as! CheckDeepLinkingViewController
                
                        vc.token = tokenString
                        let nav = UINavigationController(rootViewController:vc)
                        self.window?.rootViewController = nav
                
            }
            else if url.path == "/user/childRegisterdPopup" {
                
                let login = UserDefaults.standard.value(forKey: DefaultsIdentifier.login)
                
              //  if login is String {
                
                if login == nil || (login as! String) == "logout" {
                    
                    let storyBoard = UIStoryboard(name:"Main", bundle: nil)
                    
                    let alertVC :SetupProfilePopup = (storyBoard.instantiateViewController(withIdentifier: "SetupProfilePopup") as? SetupProfilePopup)!
                    
                   
                    let str =  "\(url)"
                    let split = str.split(separator: "=")
                    let childId    = String(split.suffix(1).joined(separator: ["="]))
                    print(childId)
                    
                    alertVC.child_Id = childId
                    
                    let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                    , tapGestureDismissal: false, panGestureDismissal: false) {
                        let overlayAppearance = PopupDialogOverlayView.appearance()
                        overlayAppearance.blurRadius  = 30
                        overlayAppearance.blurEnabled = true
                        overlayAppearance.liveBlur    = false
                        overlayAppearance.opacity     = 0.4
                    }
                    
                    alertVC.sendAction = {
                        
//                        popup.dismiss({
//
//                            // self.navigationController?.popViewController(animated: true)
//
//                        })
                        
                        
                    }
                    
                    alertVC.noAction = {
                        
                        popup.dismiss({
                            
                            // self.navigationController?.popViewController(animated: true)
                            
                        })
                        
                        
                    }
                    
                    UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
                    
                }
                
          //  }
                        
                
                
            }
        //}
        
        
//        NSMutableDictionary *dict = [NSMutableDictionary new];
//        NSLog(@"host%@",[url host]);
//        if([[url host] isEqualToString:@"domain"]){
//            if([[url path] isEqualToString:@"/mypath"]){
//
//                NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
//                NSArray *queryItems = [components queryItems];
//                for (NSURLQueryItem *item in queryItems)
//                {
//                    [dict setObject:[item value] forKey:[item name]];
//                }
//
//                valueDict = dict;
//                self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
//                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                ViewController *viewController =  [story instantiateViewControllerWithIdentifier:@"ViewController"];
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
//                self.window.rootViewController = nav;//making a view to root view
//                [self.window makeKeyAndVisible];
//
//                return YES;
//
//
//            }
//        }
        return true;
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

             window?.endEditing(true)

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                deviceToken  = "\(result.token)"
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {


        
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }


//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        //Messaging.messaging().appDidReceiveMessage(userInfo)
//        // Print full message.
//        print(userInfo)
//    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.


        print(userInfo)
        guard let notificationID = userInfo["notification_id"] as? String else { return }
        print(notificationID)
        
         let title =  userInfo["title"] as? String


       // completionHandler(UIBackgroundFetchResult.newData)

//         if UIApplication.shared.applicationState != .background || UIApplication.shared.applicationState == .active {

        if !(UIApplication.topViewController() is ReceviedNotificationViewController)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let Vc = storyboard.instantiateViewController(withIdentifier: "ReceviedNotificationViewController") as! ReceviedNotificationViewController
            Vc.obj = notificationID
            Vc.NotificationTitle = title!
            UIApplication.topViewController()?.navigationController?.pushViewController(Vc, animated: true)
        }



    }



    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LoopLeap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

#if DEBUG
extension AppDelegate {
    private func setupTestingEnvironment(with arguments: [String]) {
        if arguments.contains("SwitchToRight") {
            SideMenuController.preferences.basic.direction = .right
        }
    }
}
#endif
