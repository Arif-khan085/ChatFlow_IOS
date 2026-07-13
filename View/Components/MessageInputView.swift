//
//  MessageInputView.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

import SwiftUI

struct MessageInputView: View {

    @Binding var message: String

    let onSend: () -> Void

    var body: some View {

        HStack(spacing: 12) {

            TextField("Type a message...", text: $message)
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(Capsule())

            Button(action: onSend) {

                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.teal)
                    .clipShape(Circle())
            }
        }
        .padding()
    }
}
