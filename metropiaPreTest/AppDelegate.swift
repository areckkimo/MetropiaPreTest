//
//  AppDelegate.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import UIKit
import GoogleSignIn
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Google Sign In
        GIDSignIn.sharedInstance.restorePreviousSignIn { (user, error) in
            if error == nil, let _ = user {
                NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
            }else{
                NotificationCenter.default.post(name: .signInGoogleFail, object: nil)
            }
        }
        //Google Map
        GMSServices.provideAPIKey("AIzaSyBz1TSprs1K20BF4dWXc2UGHxHu2gpJapE")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
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

}

