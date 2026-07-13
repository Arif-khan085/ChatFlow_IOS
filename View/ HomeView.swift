//
//   HomeView.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//
//
//import SwiftUI
//
//struct HomeView: View {
//
//    @StateObject private var viewModel = AuthViewModel()
//
//    var body: some View {
//
//        NavigationStack {
//
//            VStack {
//
//                Text("Home Screen")
//
//                Button("Logout") {
//                    viewModel.signOut()
//                }
//            }
//        }
//    }
//}
//
//import SwiftUI
//
//struct HomeView: View {
//
//    @StateObject private var viewModel = AuthViewModel()
//
//    var body: some View {
//
//        TabView {
//
//            // MARK: - Chat
//            NavigationStack {
//                VStack(spacing: 20) {
//
//                    Text("💬 Chat Screen")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//
//                }
//                .navigationTitle("Chats")
//            }
//            .tabItem {
//                Image(systemName: "message.fill")
//                Text("Chat")
//            }
//
//            // MARK: - Call
//            NavigationStack {
//                VStack {
//
//                    Text("📞 Call Screen")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//
//                }
//                .navigationTitle("Calls")
//            }
//            .tabItem {
//                Image(systemName: "phone.fill")
//                Text("Call")
//            }
//
//            // MARK: - Group
//            NavigationStack {
//                VStack {
//
//                    Text("👥 Group Screen")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//
//                }
//                .navigationTitle("Groups")
//            }
//            .tabItem {
//                Image(systemName: "person.3.fill")
//                Text("Group")
//            }
//
//            // MARK: - Setting
//            NavigationStack {
//                VStack(spacing: 20) {
//
//                    Text("⚙️ Settings")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//
//                    Button(role: .destructive) {
//                        viewModel.signOut()
//                    } label: {
//                        Text("Logout")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                    }
//                    .padding(.horizontal)
//
//                }
//                .navigationTitle("Settings")
//            }
//            .tabItem {
//                Image(systemName: "gearshape.fill")
//                Text("Setting")
//            }
//        }
//        .tint(.blue)
//    }
//}
//
//#Preview {
//    HomeView()
//}

//import SwiftUI
//struct HomeView: View {
//
//    var body: some View {
//
//        TabView {
//
//            ChatListView()
//                .tabItem {
//                    Image(systemName: "message.fill")
//                    Text("Chats")
//                }
//
//            CallView()
//                .tabItem {
//                    Image(systemName: "phone.fill")
//                    Text("Calls")
//                }
//
//            GroupView()
//                .tabItem {
//                    Image(systemName: "person.3.fill")
//                    Text("Groups")
//                }
//
//            SettingsView()
//                .tabItem {
//                    Image(systemName: "gearshape.fill")
//                    Text("Settings")
//                }
//        }
//    }
//}

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
