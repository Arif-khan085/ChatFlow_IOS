//
//  UserViewModel.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class UserViewModel: ObservableObject {

    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    private let db = Firestore.firestore()

    init() {
        fetchUsers()
    }

    func fetchUsers() {

        guard let currentUID = Auth.auth().currentUser?.uid else {
            return
        }

        isLoading = true

        db.collection("users")
            .order(by: "fullName")
            .getDocuments { [weak self] snapshot, error in

                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.isLoading = false
                }

                if let error = error {

                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }

                    return
                }

                guard let documents = snapshot?.documents else {
                    return
                }

                var tempUsers: [User] = []

                for document in documents {

                    if document.documentID == currentUID {
                        continue
                    }

                    if let user = User(document: document) {
                        tempUsers.append(user)
                    }
                }

                DispatchQueue.main.async {
                    self.users = tempUsers
                }
            }
    }
}
