//
//  ChatViewModel.swift
//  ChatFlow
//
//  Created by Arif on 09/07/2026.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class ChatListViewModel: ObservableObject {

    @Published var chats: [ChatItem] = []
    @Published var searchText: String = ""

    private let db = Firestore.firestore()

    init() {
        fetchChats()
    }

    // MARK: - Filtered Chats

    var filteredChats: [ChatItem] {

        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return chats
        }

        return chats.filter {

            $0.user.fullName.localizedCaseInsensitiveContains(searchText)
            ||
            $0.lastMessage.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Fetch Chats

    func fetchChats() {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        db.collection("conversations")
            .whereField("participants", arrayContains: currentUID)
            .order(by: "lastMessageTime", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in

                guard let self = self else { return }

                guard let documents = snapshot?.documents else {
                    return
                }

                self.chats.removeAll()

                for document in documents {

                    guard let conversation = Conversation(document: document) else {
                        continue
                    }

                    guard let otherUID = conversation.participants.first(where: {
                        $0 != currentUID
                    }) else {
                        continue
                    }

                    self.fetchUser(
                        uid: otherUID,
                        conversation: conversation
                    )
                }
            }
    }

    // MARK: - Fetch User

    private func fetchUser(
        uid: String,
        conversation: Conversation
    ) {

        db.collection("users")
            .document(uid)
            .getDocument { [weak self] snapshot, error in

                guard let self = self else { return }

                guard
                    let snapshot = snapshot,
                    snapshot.exists
                else {
                    return
                }

                let data = snapshot.data() ?? [:]

                guard
                    let fullName = data["fullName"] as? String,
                    let email = data["email"] as? String,
                    let profileImage = data["profileImage"] as? String,
                    let isOnline = data["isOnline"] as? Bool,
                    let createdAt = data["createdAt"] as? Timestamp
                else {
                    return
                }

                let user = User(
                    id: uid,
                    fullName: fullName,
                    email: email,
                    profileImage: profileImage,
                    isOnline: isOnline,
                    createdAt: createdAt
                )

                DispatchQueue.main.async {

                    self.chats.append(
                        ChatItem(
                            id: conversation.id,
                            conversationId: conversation.id,
                            user: user,
                            lastMessage: conversation.lastMessage,
                            lastMessageTime: conversation.lastMessageTime.dateValue()
                        )
                    )

                    self.chats.sort {
                        $0.lastMessageTime > $1.lastMessageTime
                    }
                }
            }
    }
}
