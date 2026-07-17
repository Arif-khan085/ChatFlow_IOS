//
//  PresenceViewModel.swift.swift
//  ChatFlow
//
//  Created by Arif on 17/07/2026.
//

import Foundation
import FirebaseDatabase
import Combine

class PresenceViewModel: ObservableObject {

    @Published var isOnline: Bool = false
    @Published var lastSeen: Date?

    private let rtdb = Database.database().reference()
    private var handle: DatabaseHandle?

    private let otherUserId: String

    init(otherUserId: String) {
        self.otherUserId = otherUserId
        listenToPresence()
    }

    deinit {
        if let handle = handle {
            rtdb.child("status").child(otherUserId).removeObserver(withHandle: handle)
        }
    }

    private func listenToPresence() {

        handle = rtdb.child("status").child(otherUserId)
            .observe(.value) { [weak self] snapshot in

                guard let self = self else { return }
                guard let data = snapshot.value as? [String: Any] else { return }

                DispatchQueue.main.async {

                    self.isOnline = (data["state"] as? String) == "online"

                    if let millis = data["last_changed"] as? Double {
                        self.lastSeen = Date(timeIntervalSince1970: millis / 1000)
                    }
                }
            }
    }

    var statusText: String {

        if isOnline {
            return "Online"
        }

        guard let lastSeen = lastSeen else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.timeStyle = .short

        let calendar = Calendar.current

        if calendar.isDateInToday(lastSeen) {
            return "Last seen today at \(formatter.string(from: lastSeen))"
        } else if calendar.isDateInYesterday(lastSeen) {
            return "Last seen yesterday at \(formatter.string(from: lastSeen))"
        } else {
            formatter.dateStyle = .medium
            return "Last seen \(formatter.string(from: lastSeen))"
        }
    }
}
