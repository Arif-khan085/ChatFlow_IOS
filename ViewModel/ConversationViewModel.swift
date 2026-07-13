//
//  ConversationViewModel.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//
import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class ConversationViewModel: ObservableObject {

    private let db = Firestore.firestore()

    func createOrGetConversation(
        otherUserId: String,
        completion: @escaping (String) -> Void
    ) {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        db.collection("conversations")
            .whereField("participants", arrayContains: currentUID)
            .getDocuments { snapshot, error in

                if let documents = snapshot?.documents {

                    for document in documents {

                        let data = document.data()

                        if let participants = data["participants"] as? [String],
                           participants.contains(otherUserId) {

                            completion(document.documentID)
                            return
                        }
                    }
                }

                let ref = self.db.collection("conversations").document()

                ref.setData([
                    "participants": [currentUID, otherUserId],
                    "lastMessage": "",
                    "lastMessageTime": Timestamp()
                ]) { error in

                    if error == nil {
                        completion(ref.documentID)
                    }
                }
            }
    }
}
