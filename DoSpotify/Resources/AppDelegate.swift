//
//  AppDelegate.swift
//  DoSpotify
//
//  Created by Adonis Rumbwere on 25/2/2021.
//  Copyright © 2021 akdigital. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        if AuthManager.shared.isSignedIn {
            window.rootViewController = TabBarViewController()
        } else {
            let NavVC = UINavigationController(rootViewController: WelcomeViewController())
            NavVC.navigationBar.prefersLargeTitles = true
            NavVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = NavVC
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
        AuthManager.shared.refreshIfNeeded { (success) in
            print(success)
        }
        //print(AuthManager.shared.signInURL?.absoluteString)
        
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


}

