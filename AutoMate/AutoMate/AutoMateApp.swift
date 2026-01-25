//
//  AutoMateApp.swift
//  AutoMate
//
//  Created by oto rurua on 09.01.26.
//


import SwiftUI
import Firebase
import FirebaseAuth

// 1. ვქმნით AppDelegate-ს
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // ეს ფუნქცია რჩება SMS-ის სიგნალის დასაჭერად
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
    }
}

@main
struct AutoMateApp: App {
    // 2. ვაკავშირებთ AppDelegate-ს SwiftUI-სთან
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
                // 3. აქ ვამატებთ URL-ის დამუშავებას reCAPTCHA-სთვის
                .onOpenURL { url in
                    if Auth.auth().canHandle(url) {
                        print("DEBUG: Firebase successfully handled the URL")
                    }
                }
        }
    }
}
