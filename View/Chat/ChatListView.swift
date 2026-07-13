

import SwiftUI


struct ChatListView: View {

    @StateObject private var vm = ChatListViewModel()

    @State private var showUsers = false

    var body: some View {

        NavigationStack {

            ZStack(alignment: .bottomTrailing) {

                VStack(spacing: 0) {

                    // MARK: - Header

                    HStack {

                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.gray)

                        Spacer()

                        Text("ChatFlow")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.teal)

                        Spacer()

                        Button {

                            // Search Feature

                        } label: {

                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 24))
                                .foregroundColor(.teal)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background(Color.white)

                    Divider()

                    // MARK: - Chat List

                    if vm.chats.isEmpty {

                        Spacer()

                        VStack(spacing: 15) {

                            Image(systemName: "message")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)

                            Text("No Conversations Yet")
                                .font(.headline)

                            Text("Tap + to start a new chat.")
                                .foregroundColor(.gray)
                        }

                        Spacer()

                    } else {

                        List(vm.chats) { chat in

                            NavigationLink {

                                ChatView(
                                    conversationId: chat.conversationId,
                                    user: chat.user
                                )

                            } label: {

                                ChatRow(chat: chat)
                            }

                        }
                        .listStyle(.plain)
                    }
                }
                .background(Color(.systemGroupedBackground))
                .navigationBarBackButtonHidden(true)

                // MARK: - Floating Button

                Button {

                    showUsers = true

                } label: {

                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.teal)
                        .clipShape(Circle())
                        .shadow(radius: 5)

                }
                .padding(.trailing, 20)
                .padding(.bottom, 30)
            }
            .sheet(isPresented: $showUsers) {

                UserListView()
            }
        }
    }
}

#Preview {
    ChatListView()
}
