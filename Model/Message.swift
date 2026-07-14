//
//  Message.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

//import Foundation
//import FirebaseFirestore
//
//struct Message: Identifiable {
//
//    let id: String
//    let senderId: String
//    let text: String
//    let timestamp: Timestamp
//
//    init?(document: QueryDocumentSnapshot) {
//
//        let data = document.data()
//
//        guard
//            let senderId = data["senderId"] as? String,
//            let text = data["text"] as? String,
//            let timestamp = data["timestamp"] as? Timestamp
//        else {
//            return nil
//        }
//
//        self.id = document.documentID
//        self.senderId = senderId
//        self.text = text
//        self.timestamp = timestamp
//    }
//}


import Foundation
import FirebaseFirestore

enum MessageStatus: String {

    case sent
    case delivered
    case read
}

struct Message: Identifiable {

    let id: String
    let senderId: String
    let text: String
    let timestamp: Timestamp
    let status: MessageStatus

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

        // Default = sent
        if let statusString = data["status"] as? String,
           let messageStatus = MessageStatus(rawValue: statusString) {

            self.status = messageStatus

        } else {

            self.status = .sent
        }
    }
}


