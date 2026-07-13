//
//  ChatRow.swift
//  ChatFlow
//
//  Created by Arif on 09/07/2026.
//
import SwiftUI

struct ChatRow: View {

    let chat: ChatItem

    var body: some View {

        HStack(spacing: 15) {

            ZStack(alignment: .bottomTrailing) {

                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)

                Circle()
                    .fill(chat.user.isOnline ? .green : .gray)
                    .frame(width: 14, height: 14)
            }

            VStack(alignment: .leading, spacing: 5) {

                Text(chat.user.fullName)
                    .font(.headline)

                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer()

            Text(chat.lastMessageTime, style: .time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
