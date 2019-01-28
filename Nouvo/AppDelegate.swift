//
//  AppDelegate.swift
//  Swipe Rewards
//
//  Created by Bharathan on 27/06/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import GoogleSignIn
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate,UIViewControllerTransitioningDelegate,CAAnimationDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    var window: UIWindow?
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
   
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    
    func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "26831433128-ahuf7eg93phklvpf1ru37d69bnqup6vh.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
       
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
       // application.registerForRemoteNotifications()
        requestNotificationAuthorization(application: application)
        
        
      //  messaging(<#T##messaging: Messaging##Messaging#>, didReceiveRegistrationToken: <#T##String#>)
        
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            NSLog("[RemoteNotification] applicationState: \(applicationStateString) didFinishLaunchingWithOptions for iOS9: \(userInfo)")
            //TODO: Handle background notification
        }
        
        
     
//        
//        //DB
//        static var fcmToken = String()
//        static let fcmTokenkey = "fcm"
        
        

        let token = Database.value(forKey: Constants.Tokenkey) as? String
        if token != nil {
            //Navigating to Home Dashboard Screen
            
            
            
          
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.transitioningDelegate = self
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = navigationController
                UIView.transition(with: window, duration: 0.1, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                
         
            
            
        }
        else{
            let fcmtokens: String?
            fcmtokens = Messaging.messaging().fcmToken
            print("FCM Token :",fcmtokens as? String)
            if  fcmtokens == nil {
                Constants.fcmToken = ""
                Database.set(Constants.fcmToken, forKey: Constants.fcmTokenkey)
                Database.synchronize()
            }else{
                print(fcmtokens!)
                Constants.fcmToken = fcmtokens!
                Database.set(Constants.fcmToken, forKey: Constants.fcmTokenkey)
                Database.synchronize()
            }
        }
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
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
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Swipe_Rewards")
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
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS10+, called when presenting notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) willPresentNotification: \(userInfo)")
        //TODO: Handle foreground notification
        completionHandler([.alert])
    }
    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)")
        //TODO: Handle background notification
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
   // func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
   //     NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    //}
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
        
        let fcmtokens: String?
        fcmtokens = fcmToken
        Constants.fcmToken = fcmtokens!
        Database.set(Constants.fcmToken, forKey: Constants.fcmTokenkey)
        Database.synchronize()
        
        
    }
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        if UIApplication.shared.applicationState == .active {
            
            //TODO: Handle foreground notification
        } else {
            //TODO: Handle background notification
        }
    }
}
