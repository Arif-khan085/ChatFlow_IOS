//
//  RootView.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//


import SwiftUI

struct RootView: View {

    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var splashVM = SplashViewModel()

    var body: some View {

        Group {

            switch splashVM.destination {

            case .splash:
                SplashView()

            case .onboarding:
                OnboardingView()

            case .login:
                LoginView()

            case .home:
                if authVM.isLoggedIn {
                    HomeView()
                } else {
                    LoginView()
                }
            }
        }
        .onAppear {

            authVM.checkUser()

            if authVM.isLoggedIn {
                splashVM.destination = .home
            } else {
                splashVM.start()
            }
        }
        .onChange(of: authVM.isLoggedIn) { _, loggedIn in
            splashVM.destination = loggedIn ? .home : .login
        }
    }
}
