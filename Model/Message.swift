//
//  Message.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable {

    let id: String
    let senderId: String
    let text: String
    let timestamp: Timestamp

    init?(document: QueryDocumentSnapshot) {

        let data = document.data()

        guard
            let senderId = data["senderId"] as? String,
            let text = data["text"] as? String,
            let timestamp = data["timestamp"] as? Timestamp
        else {
            return nil
        }

        self.id = document.documentID
        self.senderId = senderId
        self.text = text
        self.timestamp = timestamp
    }
}
