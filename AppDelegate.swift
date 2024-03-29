//
//  AppDelegate.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/3.
//

import UIKit
import FBSDKCoreKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
                
        //通知設定
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("user notifications are allowed")
            } else {
                print("user notifications are not allowed")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Hotel recommendation", comment: "")
        content.subtitle = NSLocalizedString("Try new hotel today", comment: "")
        content.body = NSLocalizedString("Come query it", comment: "")
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "camping", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        let image = UIImage()
        UINavigationBar.appearance().setBackgroundImage(image, for: .default)
        UINavigationBar.appearance().shadowImage = image
        
        UITabBar.appearance().backgroundImage = image
        UITabBar.appearance().shadowImage = image
        UITabBar.appearance().tintColor = .orange
        print("home= \(NSHomeDirectory() )")
        
        Thread.sleep(forTimeInterval: 2)

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application( _ app:UIApplication, open url:URL, options: [UIApplication.OpenURLOptionsKey :Any] = [:] ) -> Bool { ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
    }
    
    
    
}

