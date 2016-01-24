//
//  AppDelegate.swift
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Asks users if they will allow this application to send them notifications
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        //If device is connected to network, check for new notifications and create them if necessary
        if isConnectedToNetwork() {
            var fireDate = NSDate()
            var message = ""
            //URL for notification message
            let messageUrlString = "https://www.dropbox.com/sh/0p31gpjkb2ifu8p/AACESUdrnEEr3oVWth3l9WOVa/notification.txt?raw=1"
            //URL for notification date
            let dateUrlString = "https://www.dropbox.com/sh/0p31gpjkb2ifu8p/AADeaNsCycu9ORUcUnWGE6HUa/notificationdate.txt?raw=1"
            let messageUrl = NSURL(string: messageUrlString)!
            let dateUrl = NSURL(string: dateUrlString)!
            //Parse message into String
            do {
                let messageRaw = try String(contentsOfURL: messageUrl, encoding: NSUTF8StringEncoding)
                message = messageRaw as String
            }
            catch {
                print("Problem dowloading data for notification message from URL.")
            }
            //Only proceed if there is a notification to be created (if there is no message, that means there is no notificatoin)
            if (message != "") {
                //Parse date into NSDate
                do {
                    let dateRaw = try String(contentsOfURL: dateUrl, encoding: NSUTF8StringEncoding)
                    let dateRawString = dateRaw as String
                    let stringToDateFormatter = NSDateFormatter()
                    stringToDateFormatter.dateFormat = "yyyy MM d HH:mm:ss"
                    fireDate = stringToDateFormatter.dateFromString(dateRawString)!
                }
                catch {
                    print("Problem dowloading data for text from URL.")
                }
                //Create notification
                let notification = UILocalNotification()
                notification.fireDate = fireDate
                notification.alertBody = message
                notification.alertAction = "open"
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.userInfo = ["CustomField1": "w00t"]
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

}

