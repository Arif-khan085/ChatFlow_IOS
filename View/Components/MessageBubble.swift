//
//  MessageBubble.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct MessageBubble: View {

    let message: Message

    private var isCurrentUser: Bool {
        message.senderId == Auth.auth().currentUser?.uid
    }

    var body: some View {

        HStack {

            if isCurrentUser {

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {

                    Text(message.text)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(Color.teal)
                        .clipShape(RoundedRectangle(cornerRadius: 18))

                    Text(message.timestamp.dateValue(), style: .time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }

            } else {

                VStack(alignment: .leading, spacing: 4) {

                    Text(message.text)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 18))

                    Text(message.timestamp.dateValue(), style: .time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
