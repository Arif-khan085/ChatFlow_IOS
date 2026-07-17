//
//  AuthViewModel.swift
//  ChatFlow
//
//  Created by Arif on 08/07/2026.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isLoggedIn = false

    private let db = Firestore.firestore()

    // MARK: - Check User Login

    init() {
        checkUser()
    }

    func checkUser() {
        isLoggedIn = Auth.auth().currentUser != nil
    }

    // MARK: - Sign Up

    func signUp(
        fullName: String,
        email: String,
        password: String
    ) {

        isLoading = true
        errorMessage = ""

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in

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

            guard let user = result?.user else { return }

            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = fullName

            changeRequest.commitChanges { _ in

                let userData: [String: Any] = [
                    "uid": user.uid,
                    "fullName": fullName,
                    "email": email,
                    "createdAt": Timestamp(),
                    "profileImage": "",
                    "isOnline": true
                ]

                self.db.collection("users").document(user.uid).setData(userData) { error in

                    if let error = error {
                        DispatchQueue.main.async {
                            self.errorMessage = error.localizedDescription
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                    }
                }
            }
        }
    }

    // MARK: - Sign In

    func signIn(
        email: String,
        password: String
    ) {

        isLoading = true
        errorMessage = ""

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in

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

            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
        }
    }

    // MARK: - Sign Out

    func signOut() {

        do {
            try Auth.auth().signOut()

            print("✅ Logout Success")
            print("Current User:", Auth.auth().currentUser as Any)

            isLoggedIn = false

        } catch {

            print("❌ Logout Error:", error.localizedDescription)
        }
    }

    // MARK: - Reset Password

    func resetPassword(email: String) {

        isLoading = true
        errorMessage = ""

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in

            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

