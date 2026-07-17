//
//  PresenceManager.swift
//  ChatFlow
//
//  Created by Arif on 17/07/2026.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class PresenceManager {

    static let shared = PresenceManager()

    private let rtdb = Database.database().reference()
    private let firestore = Firestore.firestore()
    private var connectedRefHandle: DatabaseHandle?

    private init() {}

    // MARK: - Start (login hote hi call karein)

    func startMonitoring() {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        let myStatusRef = rtdb.child("status").child(uid)
        let connectedRef = rtdb.child(".info/connected")

        connectedRefHandle = connectedRef.observe(.value) { [weak self] snapshot in

            guard let self = self else { return }
            guard let connected = snapshot.value as? Bool, connected else { return }

            // Server pe register: agar connection kabhi bhi drop ho (kill, network loss, crash),
            // Firebase server khud ye value set kar dega — client ki zaroorat nahi.
            myStatusRef.onDisconnectSetValue([
                "state": "offline",
                "last_changed": ServerValue.timestamp()
            ]) { _, _ in

                // onDisconnect register hone ke baad, ab current status "online" set karein
                myStatusRef.setValue([
                    "state": "online",
                    "last_changed": ServerValue.timestamp()
                ])
            }
        }
    }

    // MARK: - Manual offline (logout ya app background pe bhi call kar sakte hain, extra safety)

    func setOffline() {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        rtdb.child("status").child(uid).setValue([
            "state": "offline",
            "last_changed": ServerValue.timestamp()
        ])
    }

    func setOnline() {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        rtdb.child("status").child(uid).setValue([
            "state": "online",
            "last_changed": ServerValue.timestamp()
        ])
    }

    // MARK: - Stop listening (logout ke waqt)

    func stopMonitoring() {

        if let handle = connectedRefHandle {
            rtdb.child(".info/connected").removeObserver(withHandle: handle)
        }

        setOffline()
    }
}
