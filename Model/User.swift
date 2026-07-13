//
//  User.swift
//  ChatFlow
//
//  Created by Arif on 08/07/2026.
//


//import Foundation
//
//struct User: Identifiable, Codable {
//
//    var id: String
//    var fullName: String
//    var email: String
//    var profileImageURL: String?
//
//    init(
//        id: String,
//        fullName: String,
//        email: String,
//        profileImageURL: String? = nil
//    ) {
//        self.id = id
//        self.fullName = fullName
//        self.email = email
//        self.profileImageURL = profileImageURL
//    }
//}

import Foundation
import FirebaseFirestore

struct User: Identifiable {

    let id: String
    let fullName: String
    let email: String
    let profileImage: String
    let isOnline: Bool
    let createdAt: Timestamp

    // MARK: - Initialize from Firestore QueryDocumentSnapshot

    init?(document: QueryDocumentSnapshot) {

        let data = document.data()

        guard
            let fullName = data["fullName"] as? String,
            let email = data["email"] as? String,
            let profileImage = data["profileImage"] as? String,
            let isOnline = data["isOnline"] as? Bool,
            let createdAt = data["createdAt"] as? Timestamp
        else {
            return nil
        }

        self.id = document.documentID
        self.fullName = fullName
        self.email = email
        self.profileImage = profileImage
        self.isOnline = isOnline
        self.createdAt = createdAt
    }

    // MARK: - Initialize Manually

    init(
        id: String,
        fullName: String,
        email: String,
        profileImage: String,
        isOnline: Bool,
        createdAt: Timestamp
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.profileImage = profileImage
        self.isOnline = isOnline
        self.createdAt = createdAt
    }
}
