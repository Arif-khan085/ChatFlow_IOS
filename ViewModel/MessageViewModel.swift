////
////  MessageViewModel.swift
////  ChatFlow
////
////  Created by Arif on 12/07/2026.
////
//
//
//
//import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//import Combine
//
//class MessageViewModel: ObservableObject {
//
//    @Published var messages: [Message] = []
//    @Published var messageText: String = ""
//    @Published var isLoading = false
//    @Published var replyingTo: Message?
//    @Published var isOtherUserTyping = false
//
//    private let db = Firestore.firestore()
//    private var typingListener: ListenerRegistration?
//    private var typingTimer: Timer?
//
//    let conversationId: String
//
//    init(conversationId: String) {
//        self.conversationId = conversationId
//        listenForMessages()
//        listenForTyping()
//    }
//
//    deinit {
//        typingListener?.remove()
//        typingTimer?.invalidate()
//
//        // conversation chhodte waqt apna typing status hata dein
//        if let currentUID = Auth.auth().currentUser?.uid {
//            db.collection("conversations")
//                .document(conversationId)
//                .updateData([
//                    "typingUserIds": FieldValue.arrayRemove([currentUID])
//                ])
//        }
//    }
//
//    // MARK: - Listen Messages
//
//    func listenForMessages() {
//
//        guard let currentUID = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        db.collection("conversations")
//            .document(conversationId)
//            .collection("messages")
//            .order(by: "timestamp")
//            .addSnapshotListener { [weak self] snapshot, error in
//
//                guard let self = self else { return }
//                guard let documents = snapshot?.documents else { return }
//
//                DispatchQueue.main.async {
//
//                    self.messages = documents.compactMap {
//                        Message(document: $0)
//                    }.filter { message in
//                        !message.deletedFor.contains(currentUID)
//                    }
//                }
//
//                for document in documents {
//
//                    let data = document.data()
//
//                    let senderId = data["senderId"] as? String ?? ""
//                    let status = data["status"] as? String ?? MessageStatus.sent.rawValue
//
//                    if senderId != currentUID &&
//                        status != MessageStatus.read.rawValue {
//
//                        document.reference.updateData([
//                            "status": MessageStatus.read.rawValue
//                        ])
//                    }
//                }
//            }
//    }
//
//    // MARK: - Listen Typing Status
//
//    func listenForTyping() {
//
//        guard let currentUID = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        typingListener = db.collection("conversations")
//            .document(conversationId)
//            .addSnapshotListener { [weak self] snapshot, error in
//
//                guard let self = self else { return }
//                guard let data = snapshot?.data() else { return }
//
//                let typingIds = data["typingUserIds"] as? [String] ?? []
//
//                DispatchQueue.main.async {
//                    self.isOtherUserTyping = typingIds.contains { $0 != currentUID }
//                }
//            }
//    }
//
//    // MARK: - Update Typing Status (MessageInputView se call hoga)
//
//    func userIsTyping() {
//
//        guard let currentUID = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        db.collection("conversations")
//            .document(conversationId)
//            .updateData([
//                "typingUserIds": FieldValue.arrayUnion([currentUID])
//            ])
//
//        // 3 second baad khud ba khud "typing" hata dein agar user ne likhna band kar diya
//        typingTimer?.invalidate()
//        typingTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
//            self?.stopTyping()
//        }
//    }
//
//    func stopTyping() {
//
//        guard let currentUID = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        typingTimer?.invalidate()
//
//        db.collection("conversations")
//            .document(conversationId)
//            .updateData([
//                "typingUserIds": FieldValue.arrayRemove([currentUID])
//            ])
//    }
//
//    // MARK: - Send Message
//
//    func sendMessage() {
//
//        guard let currentUID = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        let text = messageText
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//
//        guard !text.isEmpty else {
//            return
//        }
//
//        var data: [String: Any] = [
//
//            "senderId": currentUID,
//            "text": text,
//            "timestamp": Timestamp(),
//            "status": MessageStatus.sent.rawValue,
//            "deletedFor": []
//        ]
//
//        if let replyMsg = replyingTo {
//            data["replyToText"] = replyMsg.text
//            data["replyToSenderId"] = replyMsg.senderId
//        }
//
//        db.collection("conversations")
//            .document(conversationId)
//            .collection("messages")
//            .addDocument(data: data) { [weak self] error in
//
//                guard let self = self else { return }
//
//                if let error = error {
//
//                    print(error.localizedDescription)
//                    return
//                }
//
//                self.db.collection("conversations")
//                    .document(self.conversationId)
//                    .updateData([
//
//                        "lastMessage": text,
//                        "lastMessageTime": Timestamp()
//                    ])
//
//                DispatchQueue.main.async {
//
//                    self.messageText = ""
//                    self.replyingTo = nil
//                }
//            }
//
//        // message bhejte hi typing status hata dein
//        stopTyping()
//    }
//
//    // MARK: - Delete For Everyone
//
//    func deleteForEveryone(message: Message) {
//
//        db.collection("conversations")
//            .document(conversationId)
//            .collection("messages")
//            .document(message.id)
//            .delete { error in
//
//                if let error = error {
//
//                    print(error.localizedDescription)
//                }
//            }
//    }
//
//    // MARK: - Delete For Me
//
//    func deleteForMe(message: Message) {
//
//        guard let currentUID = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        DispatchQueue.main.async {
//            self.messages.removeAll { $0.id == message.id }
//        }
//
//        db.collection("conversations")
//            .document(conversationId)
//            .collection("messages")
//            .document(message.id)
//            .updateData([
//
//                "deletedFor": FieldValue.arrayUnion([currentUID])
//
//            ]) { error in
//
//                if let error = error {
//
//                    print(error.localizedDescription)
//                }
//            }
//    }
//
//    // MARK: - Edit Message
//
//    func editMessage(
//        message: Message,
//        newText: String
//    ) {
//
//        let text = newText
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//
//        guard !text.isEmpty else {
//            return
//        }
//
//        db.collection("conversations")
//            .document(conversationId)
//            .collection("messages")
//            .document(message.id)
//            .updateData([
//
//                "text": text
//
//            ]) { error in
//
//                if let error = error {
//
//                    print(error.localizedDescription)
//                }
//            }
//    }
//}
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class MessageViewModel: ObservableObject {

    @Published var messages: [Message] = []
    @Published var messageText: String = ""
    @Published var isLoading = false
    @Published var replyingTo: Message?
    @Published var isOtherUserTyping = false

    private let db = Firestore.firestore()
    private var typingListener: ListenerRegistration?
    private var typingTimer: Timer?

    let conversationId: String

    init(conversationId: String) {
        self.conversationId = conversationId
        listenForMessages()
        listenForTyping()
    }

    deinit {
        typingListener?.remove()
        typingTimer?.invalidate()

        // conversation chhodte waqt apna typing status hata dein
        if let currentUID = Auth.auth().currentUser?.uid {
            db.collection("conversations")
                .document(conversationId)
                .updateData([
                    "typingUserIds": FieldValue.arrayRemove([currentUID])
                ])
        }
    }

    // MARK: - Listen Messages

    func listenForMessages() {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        db.collection("conversations")
            .document(conversationId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] snapshot, error in

                guard let self = self else { return }
                guard let documents = snapshot?.documents else { return }

                DispatchQueue.main.async {

                    self.messages = documents.compactMap {
                        Message(document: $0)
                    }.filter { message in
                        !message.deletedFor.contains(currentUID)
                    }
                }

                for document in documents {

                    let data = document.data()

                    let senderId = data["senderId"] as? String ?? ""
                    let status = data["status"] as? String ?? MessageStatus.sent.rawValue

                    if senderId != currentUID &&
                        status != MessageStatus.read.rawValue {

                        document.reference.updateData([
                            "status": MessageStatus.read.rawValue
                        ])
                    }
                }
            }
    }

    // MARK: - Listen Typing Status

    func listenForTyping() {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        typingListener = db.collection("conversations")
            .document(conversationId)
            .addSnapshotListener { [weak self] snapshot, error in

                guard let self = self else { return }
                guard let data = snapshot?.data() else { return }

                let typingIds = data["typingUserIds"] as? [String] ?? []

                DispatchQueue.main.async {
                    self.isOtherUserTyping = typingIds.contains { $0 != currentUID }
                }
            }
    }

    // MARK: - Update Typing Status (MessageInputView se call hoga)

    func userIsTyping() {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        db.collection("conversations")
            .document(conversationId)
            .updateData([
                "typingUserIds": FieldValue.arrayUnion([currentUID])
            ])

        // 3 second baad khud ba khud "typing" hata dein agar user ne likhna band kar diya
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.stopTyping()
        }
    }

    func stopTyping() {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        typingTimer?.invalidate()

        db.collection("conversations")
            .document(conversationId)
            .updateData([
                "typingUserIds": FieldValue.arrayRemove([currentUID])
            ])
    }

    // MARK: - Send Message

    func sendMessage() {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        let text = messageText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else {
            return
        }

        var data: [String: Any] = [

            "senderId": currentUID,
            "text": text,
            "timestamp": Timestamp(),
            "status": MessageStatus.sent.rawValue,
            "deletedFor": []
        ]

        if let replyMsg = replyingTo {
            data["replyToText"] = replyMsg.text
            data["replyToSenderId"] = replyMsg.senderId
        }

        db.collection("conversations")
            .document(conversationId)
            .collection("messages")
            .addDocument(data: data) { [weak self] error in

                guard let self = self else { return }

                if let error = error {

                    print(error.localizedDescription)
                    return
                }

                self.db.collection("conversations")
                    .document(self.conversationId)
                    .updateData([

                        "lastMessage": text,
                        "lastMessageTime": Timestamp()
                    ])

                DispatchQueue.main.async {

                    self.messageText = ""
                    self.replyingTo = nil
                }
            }

        // message bhejte hi typing status hata dein
        stopTyping()
    }

    // MARK: - Delete For Everyone

    func deleteForEveryone(message: Message) {

        db.collection("conversations")
            .document(conversationId)
            .collection("messages")
            .document(message.id)
            .delete { error in

                if let error = error {

                    print(error.localizedDescription)
                }
            }
    }

    // MARK: - Delete For Me

    func deleteForMe(message: Message) {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        DispatchQueue.main.async {
            self.messages.removeAll { $0.id == message.id }
        }

        db.collection("conversations")
            .document(conversationId)
            .collection("messages")
            .document(message.id)
            .updateData([

                "deletedFor": FieldValue.arrayUnion([currentUID])

            ]) { error in

                if let error = error {

                    print(error.localizedDescription)
                }
            }
    }

    // MARK: - Edit Message

    func editMessage(
        message: Message,
        newText: String
    ) {

        let text = newText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else {
            return
        }

        db.collection("conversations")
            .document(conversationId)
            .collection("messages")
            .document(message.id)
            .updateData([

                "text": text

            ]) { error in

                if let error = error {

                    print(error.localizedDescription)
                }
            }
    }

    // MARK: - Toggle Reaction (WhatsApp jese emoji react)

    func toggleReaction(message: Message, emoji: String) {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        let ref = db.collection("conversations")
            .document(conversationId)
            .collection("messages")
            .document(message.id)

        // agar wahi emoji dubara laga rahe hain tho reaction hata dein (toggle off)
        if message.reactions[currentUID] == emoji {

            ref.updateData([
                "reactions.\(currentUID)": FieldValue.delete()
            ]) { error in

                if let error = error {
                    print(error.localizedDescription)
                }
            }

        } else {

            ref.updateData([
                "reactions.\(currentUID)": emoji
            ]) { error in

                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
