//
//  AppDelegate.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import Bolts
import PopupDialog
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // light status bar
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        // Override point for customization after application launch.
        
        // configuration of using Parse code in Heroku
        //let parseConfig = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            
            //accessing Heroku App via id & keys
        //    ParseMutableClientConfiguration.applicationId = "instagramASDAShhggjhghgghj"
        //    ParseMutableClientConfiguration.clientKey = "instagramQWStrkhljjljkjljlyyyiyu"
        //    ParseMutableClientConfiguration.server = "http://tripinstagram.herokuapp.com/parse"
        //}

        let parseConfig = ParseClientConfiguration { (ParseMutableClientConfiguration) in
        
        // Back4Apps
        //  accessing Heroku App via id & keys
//            ParseMutableClientConfiguration.applicationId = "Z0lLgro7mYSMQPlpG33VQvHy6NlJYnbXfPfMIZO4"
//            ParseMutableClientConfiguration.clientKey = "NYLFBOcOU4ah0oA83eNzsBXhK9KpMTFpf0hTqtmv"
//            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
            
            ParseMutableClientConfiguration.applicationId = "giMy5zrPdxGS6K7n63F8zbZKc7dAPc8bCmOG4G94"
            ParseMutableClientConfiguration.clientKey = "Xm3Cw5nCLP2SUd59TSXgs3hbG9GcbiH8RfCP4dA7"
            ParseMutableClientConfiguration.server = "https://pg-app-ff0ppowy4lzielkcxeri34vrpddf9v.scalabl.cloud/1/"
            
            
        }
        
        
        
        Parse.enableLocalDatastore()
        
       // Parse.setApplicationId("Z0lLgro7mYSMQPlpG33VQvHy6NlJYnbXfPfMIZO4", clientKey: "NYLFBOcOU4ah0oA83eNzsBXhK9KpMTFpf0hTqtmv")
        
//        let configuration = ParseClientConfiguration{
//            $0.applicationId = "Z0lLgro7mYSMQPlpG33VQvHy6NlJYnbXfPfMIZO4"
//            $0.clientKey = "NYLFBOcOU4ah0oA83eNzsBXhK9KpMTFpf0hTqtmv"
//            $0.server = "https://parseapi.back4app.com/"
//        }
        
        Parse.initialize(with: parseConfig)
        
        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
        
        // PFUser.enableAutomaticUser()
        
        //let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        //defaultACL.getPublicReadAccess = true
        
        //PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        
//        for i in 0...9 {
//            let testObject = PFObject(className: "photos")
//            // let uuid = UUID().uuidString
//            testObject["uuid"] = "\(PFUser.current()?.username) A5D9E7B3-8617-4258-A155-90CC92A2DA91"
//            testObject["ishome"] = false
//            let img = UIImage(named: "image" + "\(i)")
//            let imageData = UIImageJPEGRepresentation(img!, 0.5)
//            let imageFile = PFFile(name: "post.jpg", data: imageData!)
//            testObject["picture"] = imageFile
//            testObject.saveInBackground()
//        }

        
        
//        let testObject = PFObject(className: "follow")
//        testObject["follower"] = "ejko"
//        testObject["following"] = "jirka"
//        testObject.saveInBackground { (success: Bool, error: Error?) in
//        print("object has ben saved")
//        }
    
//        if application.applicationState != UIApplicationState.background {
//            // Track an app open here if we launch with a push, unless
//            // "content_available" was used to trigger a background push (introduced in iOS 7).
//            // In that case, we skip tracking here to avoid double counting the app-open.
//            
//            let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
//            //let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
//            let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
//            //let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
//            var noPushPayload = false;
//            if let options = launchOptions {
//                noPushPayload = options[UIApplicationLaunchOptionsKey.remoteNotification] != nil;
//            }
//            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
//                PFAnalytics.trackAppOpened(launchOptions: launchOptions)
//            }
//        }
        
        //call login function
        login()
        
        // color of window
        window?.backgroundColor = .white
        
        // push notification enablement
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            center.requestAuthorization(options: options, completionHandler: { authorized, error in
                if authorized {
                    application.registerForRemoteNotifications()
                }
            })
        }
        
        
        //Parse.initialize(with: configuration)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func login() {
        
        // remeber user's login
        
        let username : String? = UserDefaults.standard.string(forKey: "username")
        
        if username != nil {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            window?.rootViewController = myTabBar
        }
    }

    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let installation = PFInstallation.current()
//        installation.setDeviceTokenFrom(deviceToken as Data)
//        installation.saveInBackground()
//        
//        PFPush.subscribeToChannel(inBackground: "") { (succeeded: Bool, error: Error?) in
//            if succeeded {
//                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.\n");
//            } else {
//                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error)
//            }
//        }
//    }
//    
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        if error.localizedDescription == "" {
//            print("Push notifications are not supported in the iOS Simulator.\n")
//        } else {
//            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
//        }
//
//    }
//    
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        PFPush.handle(userInfo)
//        if application.applicationState == UIApplicationState.inactive {
//            PFAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
//        }
//    }
}

