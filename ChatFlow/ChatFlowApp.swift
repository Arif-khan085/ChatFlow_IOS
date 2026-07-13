//
//  ChatFlowApp.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

//import SwiftUI
//import FirebaseCore
//
//@main
//struct ChatFlowApp: App {
//    var body: some Scene {
//        WindowGroup {
//            
//            NavigationStack{
//                RootView()
//            }
//        }
//    }
//}

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        FirebaseApp.configure()
        return true
    }
}

@main
struct ChatFlowApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var authVM = AuthViewModel()

    var body: some Scene {

        WindowGroup {

            NavigationStack {
                RootView()
            }
            .environmentObject(authVM)
        }
    }
}
