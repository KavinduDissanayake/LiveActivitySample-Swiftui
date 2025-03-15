//
//  AppDelegate.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        
        ActivityManager.shared.listenForTokenToStartActivityViaPush()
        ActivityManager.shared.listenForTokenToUpdateActivityViaPush()
        return true
    }
}

extension AppDelegate {
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("======== DEVICE TOKEN: \(deviceToken.hexEncodedString())")
        AppData.deviceToken = deviceToken.hexEncodedString()
    }
}
