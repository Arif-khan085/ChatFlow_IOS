//
//  SplashViewModel.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

import SwiftUI
import Combine

@MainActor
final class SplashViewModel: ObservableObject {

    enum Destination {
        case splash
        case onboarding
        case login
        case home
    }

    @Published var destination: Destination = .splash

    func start() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

            if !hasSeenOnboarding {
                self.destination = .onboarding
                return
            }

            // Firebase Authentication Check
            let isLoggedIn = false

            self.destination = isLoggedIn ? .home : .login
        }
    }
}
