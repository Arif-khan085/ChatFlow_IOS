//
//  ChatRow.swift
//  ChatFlow
//
//  Created by Arif on 09/07/2026.
//


import SwiftUI
import FirebaseFirestore

struct ChatRow: View {

    let chat: ChatItem
    let searchText: String

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

                Text(highlighted(chat.user.fullName))
                    .font(.headline)

                Text(highlighted(chat.lastMessage))
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

    // MARK: - Highlight Search Text

    private func highlighted(_ text: String) -> AttributedString {

        var attributed = AttributedString(text)

        guard !searchText.isEmpty else {
            return attributed
        }

        var searchStart = attributed.startIndex

        while let range = attributed[searchStart...].range(
            of: searchText,
            options: .caseInsensitive
        ) {

            attributed[range].backgroundColor = .orange
            attributed[range].foregroundColor = .white

            searchStart = range.upperBound
        }

        return attributed
    }
}

#Preview {

    ChatRow(
        chat: ChatItem(
            id: "1",
            conversationId: "1",
            user: User(
                id: "1",
                fullName: "Arif Ullah",
                email: "arif@gmail.com",
                profileImage: "",
                isOnline: true,
                createdAt: Timestamp(date: Date())
            ),
            lastMessage: "Hello Arif, How are you?",
            lastMessageTime: Date()
        ),
        searchText: "arif"
    )
}
