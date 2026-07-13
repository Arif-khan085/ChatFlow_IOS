//
//  UserListView.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

import SwiftUI

struct UserListView: View {

    @StateObject private var vm = UserViewModel()
    @StateObject private var conversationVM = ConversationViewModel()

    @State private var selectedUser: User?
    @State private var conversationId: String = ""
    @State private var openChat = false

    var body: some View {

        NavigationStack {

            Group {

                if vm.isLoading {

                    ProgressView()

                } else if vm.users.isEmpty {

                    VStack(spacing: 15) {

                        Image(systemName: "person.3")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        Text("No Users Found")
                            .font(.headline)

                    }

                } else {

                    List(vm.users) { user in

                        Button {

                            conversationVM.createOrGetConversation(
                                otherUserId: user.id
                            ) { id in

                                DispatchQueue.main.async {

                                    conversationId = id
                                    selectedUser = user
                                    openChat = true
                                }
                            }

                        } label: {

                            UserRow(user: user)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }

            }
            .navigationTitle("New Chat")

            .navigationDestination(isPresented: $openChat) {

                if let user = selectedUser {

                    ChatView(
                        conversationId: conversationId,
                        user: user
                    )

                }
            }
        }
    }
}

#Preview {
    UserListView()
}
