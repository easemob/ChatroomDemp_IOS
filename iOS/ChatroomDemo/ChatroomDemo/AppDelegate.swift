//
//  AppDelegate.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/23.
//

import UIKit
import ChatroomUIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let option = ChatSDKOptions(appkey: <#Your's app key#>)
        option.enableConsoleLog = true
        option.deleteMessagesOnLeaveChatroom = true
        let error = ChatroomUIKitClient.shared.setup(appKey: "", option: option)
        if error != nil {
            consoleLogInfo("ChatroomUIKitClient init error:\(error?.errorDescription ?? "")", type: .debug)
        }
        if let lang = NSLocale.preferredLanguages.first,lang.contains("zh") {
            Appearance.messageTranslationLanguage = .Chinese
        } else {
            Appearance.messageTranslationLanguage = .English
        }
        
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




