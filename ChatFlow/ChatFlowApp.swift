//
//  ChatFlowApp.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//


//import SwiftUI
//import FirebaseCore
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
//    ) -> Bool {
//
//        FirebaseApp.configure()
//        return true
//    }
//}
//
//@main
//struct ChatFlowApp: App {
//
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//
//    @StateObject private var authVM = AuthViewModel()
//
//    var body: some Scene {
//
//        WindowGroup {
//
//            NavigationStack {
//                RootView()
//            }
//            .environmentObject(authVM)
//        }
//    }
//}

//import SwiftUI
//import FirebaseCore
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
//    ) -> Bool {
//
//        FirebaseApp.configure()
//        return true
//    }
//}
//
//@main
//struct ChatFlowApp: App {
//
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//
//    @StateObject private var authVM = AuthViewModel()
//
//    @Environment(\.scenePhase) private var scenePhase
//
//    var body: some Scene {
//
//        WindowGroup {
//
//            NavigationStack {
//                RootView()
//            }
//            .environmentObject(authVM)
//        }
//        .onChange(of: scenePhase) { _, newPhase in
//
//            switch newPhase {
//
//            case .active:
//                PresenceViewModel.setOnline()
//
//            case .background, .inactive:
//                PresenceViewModel.setOffline()
//
//            @unknown default:
//                break
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

    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {

        WindowGroup {

            NavigationStack {
                RootView()
            }
            .environmentObject(authVM)
        }
        .onChange(of: scenePhase) { _, newPhase in

            switch newPhase {

            case .active:
                PresenceManager.shared.setOnline()

            case .background:
                PresenceManager.shared.setOffline()

            default:
                break
            }
        }
    }
}
