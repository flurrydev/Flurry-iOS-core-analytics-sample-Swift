//
//  AppDelegate.swift
//  FlurryCoreAnalyticsSampleApp_Swift
//
//  Created by Yilun Xu on 9/28/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let fileName = "/setting.plist"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory = paths.object(at: 0) as! NSString
        let path = documentDirectory.appendingPathComponent(fileName)
        if let dict = NSMutableDictionary(contentsOfFile: path) {
            print("exist")
            dict.forEach { print("\($0): \($1)") }
        } else {
            print("not yet exist")
            // copy
            let fileManager = FileManager.default
            if(!fileManager.fileExists(atPath: path)){
                if let defaultPath = Bundle.main.path(forResource: "FlurryCoreConfig", ofType: "plist") {
                    do {
                        try fileManager.copyItem(atPath: defaultPath, toPath: path)
                    } catch {
                        print("copy error")
                    }
                }
            } else {
                print("\(fileName) not exist")
            }
        }
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
    
    
}

