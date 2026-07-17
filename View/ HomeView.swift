//
//   HomeView.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

import SwiftUI

struct HomeView: View {

    var body: some View {

        TabView {

            NavigationStack {
                ChatListView()
            }
            .tabItem {
                Label("Chats", systemImage: "message.fill")
            }

            NavigationStack {
                CallView()
            }
            .tabItem {
                Label("Calls", systemImage: "phone.fill")
            }

            NavigationStack {
                GroupView()
            }
            .tabItem {
                Label("Groups", systemImage: "person.3.fill")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
    }
}
