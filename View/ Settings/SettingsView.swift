//
//  SettingsView.swift
//  ChatFlow
//
//  Created by Arif on 09/07/2026.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {

        NavigationStack {

            List {

                // MARK: - Account

                Section("Account") {

                    Label("Profile", systemImage: "person.circle")

                    Label("Privacy", systemImage: "lock")
                }

                // MARK: - App

                Section("App") {

                    Label("Notifications", systemImage: "bell")

                    Label("Appearance", systemImage: "paintbrush")
                }

                // MARK: - Logout

                Section {

                    Button(role: .destructive) {

                        authVM.signOut()

                    } label: {

                        HStack {

                            Spacer()

                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .font(.headline)

                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
}
