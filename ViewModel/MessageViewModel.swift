//
//  MessageViewModel.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class MessageViewModel: ObservableObject {

    @Published var messages: [Message] = []
    @Published var messageText: String = ""
    @Published var isLoading = false

    private let db = Firestore.firestore()

    let conversationId: String

    init(conversationId: String) {
        self.conversationId = conversationId
        listenForMessages()
    }

    // MARK: - Listen Realtime Messages

    func listenForMessages() {

        db.collection("conversations")
            .document(conversationId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] snapshot, error in

                guard let self = self else { return }

                guard let documents = snapshot?.documents else {
                    return
                }

                DispatchQueue.main.async {

                    self.messages = documents.compactMap {
                        Message(document: $0)
                    }
                }
            }
    }

    // MARK: - Send Message

    func sendMessage() {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else {
            return
        }

        let data: [String: Any] = [
            "senderId": currentUID,
            "text": text,
            "timestamp": Timestamp()
        ]

        db.collection("conversations")
            .document(conversationId)
            .collection("messages")
            .addDocument(data: data) { [weak self] error in

                guard let self = self else { return }

                if error == nil {

                    self.db.collection("conversations")
                        .document(self.conversationId)
                        .updateData([
                            "lastMessage": text,
                            "lastMessageTime": Timestamp()
                        ])

                    DispatchQueue.main.async {
                        self.messageText = ""
                    }
                }
            }
    }
}
