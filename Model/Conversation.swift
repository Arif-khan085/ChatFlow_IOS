//
//  Conversation.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

import Foundation
import FirebaseFirestore

struct Conversation: Identifiable {

    let id: String
    let participants: [String]
    let lastMessage: String
    let lastMessageTime: Timestamp

    init?(document: QueryDocumentSnapshot) {

        let data = document.data()

        guard
            let participants = data["participants"] as? [String],
            let lastMessage = data["lastMessage"] as? String,
            let lastMessageTime = data["lastMessageTime"] as? Timestamp
        else {
            return nil
        }

        self.id = document.documentID
        self.participants = participants
        self.lastMessage = lastMessage
        self.lastMessageTime = lastMessageTime
    }
}
