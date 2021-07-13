//
//  AppDelegate.swift
//  GitHubAPITestLab
//
//  Created by HanzoMac on 20/05/21.
//

import UIKit
import AlamofireNetworkActivityLogger

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if DEBUG
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        #endif
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        #if DEBUG
        NetworkActivityLogger.shared.stopLogging()
        #endif
    }
    
}

