//
//  OnboardingView.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

import SwiftUI

struct OnboardingView: View {

    var body: some View {

        VStack(spacing: 30) {

            Spacer()

            Image(systemName: "message.badge.fill")
                .font(.system(size: 120))
                .foregroundStyle(.blue)

            Text("Welcome to ChatFlow")
                .font(.largeTitle)
                .bold()

            Text("Connect with friends securely and instantly.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            NavigationLink("Get Started") {

                LoginView()
                    .navigationBarBackButtonHidden(true)

            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom,40)
        }
        .padding()
        .onDisappear {

            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        }
    }
}
