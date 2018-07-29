//
//  AppDelegate.swift
//  Mokets
//
//  Created by Panacea-soft on 11/19/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerForPushNotifications(application: application)
        
        return true
    }
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        }
            
        else{ //If user is not on iOS 10 use the old methods we've been using
            let notificationTypes : UIUserNotificationType = [.alert, .badge, .sound]
            let notificationSettings : UIUserNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            })
            
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings)
    {
        
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var deviceID : String = UIDevice.current.identifierForVendor!.uuidString
        let devicePlatform : String = "IOS"
        var deviceTokenKey : String = ""
        
        /*
         for i in 0..<deviceToken.count {
         deviceTokenKey = deviceTokenKey + String(format: "%02.2hhx", arguments: [deviceToken[i]])
         }*/
        
        deviceTokenKey = String(format: "%@", deviceToken as CVarArg)
        
        // Save values in USUserDefaults
        let prefs = UserDefaults.standard
        
        prefs.set(deviceID, forKey:  notiKey.deviceIDKey)
        prefs.set(deviceToken, forKey: notiKey.deviceTokenKey)
        prefs.set(devicePlatform, forKey: notiKey.devicePlatform)
        
        // Remove All Space, >, <
        deviceTokenKey = deviceTokenKey.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        deviceTokenKey = deviceTokenKey.replacingOccurrences(of: ">", with: "", options: NSString.CompareOptions.literal, range: nil)
        deviceTokenKey = deviceTokenKey.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        deviceID = deviceID.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        print("Device ID Key : " + deviceID)
        print("Device Token Key : " + deviceTokenKey)
        print("Device Platforma : " + devicePlatform)
        
        let isRegister = prefs.string(forKey: notiKey.isRegister)
        
        if(isRegister != "YES"){
            if(deviceID != "" && deviceTokenKey != "" && devicePlatform != "") {
                
                let params: [String: AnyObject] = [
                    "reg_id"    :  deviceTokenKey as AnyObject,
                    "device_id" :  deviceID as AnyObject,
                    "os_type"   :  devicePlatform as AnyObject,
                    "platformName": "ios" as AnyObject
                ]
                
                /*TOFIX*/
                _ =  Alamofire.request(APIRouters.RegitsterPushNoti(params)).responseObject {
                    (response: DataResponse<StdResponse>) in
                    print(response)
                    if response.result.isSuccess {
                        if let res = response.result.value {
                            print("Success \(res.intData)")
                            prefs.set("YES", forKey: notiKey.isRegister)
                        }
                    } else {
                        print("Fail \(response)")
                    }
                    
                    
                }
            }
        }else{
            // Already registered.
            print("Already Registered")
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    /*
     //old code
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     print("Recived2: \(userInfo)")
     var _ : NSDictionary = userInfo as NSDictionary
     if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
     {
     let alertMsg = info["alert"] as! String
     
     let prefs = UserDefaults.standard
     
     let terminate = prefs.string(forKey: "TERMINATE");
     
     if terminate != nil {
     
     // Set to tmp storage
     //let prefs = NSUserDefaults.standardUserDefaults()
     prefs.set(alertMsg, forKey: notiKey.notiMessageKey)
     }else {
     let alert = UIAlertController(title: "", message: info["alert"] as! String?, preferredStyle: UIAlertControllerStyle.alert)
     alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertActionStyle.default, handler: nil))
     self.window?.rootViewController?.present(alert, animated: true, completion: nil)
     
     }
     }
     
     }*/
    
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("User Info = ",notification.request.content.userInfo)
        if let info =  notification.request.content.userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            let alertMsg = info["alert"] as! String
            
            let prefs = UserDefaults.standard
            
            let terminate = prefs.string(forKey: "TERMINATE");
            
            if terminate != nil {
                print( "terminate is not null.")
                // Set to tmp storage
                prefs.set(alertMsg, forKey: notiKey.notiMessageKey)
                completionHandler([.alert, .badge, .sound])
            }else {
                let alert = UIAlertController(title: "", message: info["alert"] as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertActionStyle.default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let info =  response.notification.request.content.userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            let alertMsg = info["alert"] as! String
            
            let prefs = UserDefaults.standard
            
            let terminate = prefs.string(forKey: "TERMINATE");
            
            if terminate != nil {
                // Set to tmp storage
                prefs.set(alertMsg, forKey: notiKey.notiMessageKey)
                completionHandler()
            }else {
                let alert = UIAlertController(title: "", message: info["alert"] as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertActionStyle.default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //print("did enter background")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        //print("enter to fore ground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //print("did become active")
        UserDefaults.standard.removeObject(forKey: "TERMINATE")
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.set("Y", forKey:  "TERMINATE");
        
        print ("terminate")
        
    }
    
    
}


