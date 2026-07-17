//
//  ReactionbarView.swift
//  ChatFlow
//
//  Created by Arif on 17/07/2026.
//

import SwiftUI

// MARK: - Quick Reaction Bar (WhatsApp jese: 5 emoji + plus icon)

struct ReactionBarView: View {

    private let quickReactions = ["👍", "❤️", "😂", "😮", "😢"]

    let onSelect: (String) -> Void
    let onMore: () -> Void

    var body: some View {

        HStack(spacing: 10) {

            ForEach(quickReactions, id: \.self) { emoji in

                Text(emoji)
                    .font(.system(size: 26))
                    .onTapGesture {

                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()

                        onSelect(emoji)
                    }
            }

            Divider()
                .frame(height: 20)

            Button {
                onMore()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.18), radius: 8, y: 3)
        )
        .transition(.scale(scale: 0.7, anchor: .bottom).combined(with: .opacity))
    }
}

// MARK: - Full Emoji Picker (plus icon dabane par khulta hai)

struct FullEmojiPickerView: View {

    let onSelect: (String) -> Void

    @Environment(\.dismiss) private var dismiss

    private let emojis = [
        "👍", "❤️", "😂", "😮", "😢", "🙏",
        "🔥", "🎉", "👏", "😍", "😡", "🤔",
        "👌", "😴", "🥳", "💯", "😭", "🤝",
        "👀", "😎", "🤯", "🥺", "😅", "🤗"
    ]

    private let columns = Array(repeating: GridItem(.flexible()), count: 6)

    var body: some View {

        NavigationStack {

            ScrollView {

                LazyVGrid(columns: columns, spacing: 18) {

                    ForEach(emojis, id: \.self) { emoji in

                        Text(emoji)
                            .font(.system(size: 32))
                            .onTapGesture {
                                onSelect(emoji)
                                dismiss()
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Reaction Chunein")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Reaction Badge (bubble ke corner par chota pill jo lagi hui reaction dikhata hai)

struct ReactionBadgeView: View {

    let reactions: [String: String] // [userId: emoji]

    private var summary: [(emoji: String, count: Int)] {

        let counts = Dictionary(grouping: reactions.values, by: { $0 })
            .mapValues { $0.count }

        return counts
            .sorted { $0.value > $1.value }
            .map { (emoji: $0.key, count: $0.value) }
    }

    var body: some View {

        if !reactions.isEmpty {

            HStack(spacing: 2) {

                ForEach(summary, id: \.emoji) { item in

                    Text(item.emoji)
                        .font(.system(size: 12))
                }

                if reactions.count > 1 {

                    Text("\(reactions.count)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.15), radius: 3, y: 1)
            )
        }
    }
}
