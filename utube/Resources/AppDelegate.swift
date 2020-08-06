//
//  AppDelegate.swift
//  utube
//
//  Created by ILJOO CHAE on 8/5/20.
//  Copyright © 2020 ILJOO CHAE. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    //for notification
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
         application.applicationIconBadgeNumber = 0
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (success, error) in
            if let error = error {
                print("There was an error when requesting authorization to send the user a notification \(error) -- \(error.localizedDescription)")
            }
            if success {
                //register user for notification
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }
    
    //for notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //subscribe the user for notification
        HypeController.shared.subscribeForRemoteNotifications { (error) in
            if let error = error {
                print("There was an error subscibing or remote notifications -\(error) -- \(error.localizedDescription)")
            }
        }
        
        
    }

    //for notification
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("We failed to register for remote notifications \(error) --\(error.localizedDescription)")
    }
    
    //for notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        HypeController.shared.fetchAllHypes { (result) in
            switch result {
                
            case .success(let hypes):
                HypeController.shared.hypes = hypes
            case .failure(_):
                print("Failed to fetch Hypes")
            }
            
        }
    }
    
    //for notification
    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }



}

