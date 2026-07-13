//
//  WelcomeView.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {

            Spacer()

            Image("chatLogo")

            Text("Welcome to ChatFlow")

            Spacer()

            NavigationLink("Sign Up") {
                SignUpView()
            }

            NavigationLink("Log In") {
                LoginView()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
