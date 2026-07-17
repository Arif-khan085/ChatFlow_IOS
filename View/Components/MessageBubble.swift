//
//  MessageBubble.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//



//
//import SwiftUI
//import FirebaseAuth
//import UIKit
//import FirebaseCore
//
//struct MessageBubble: View {
//
//    let message: Message
//    @ObservedObject var viewModel: MessageViewModel
//    let onLongPress: () -> Void
//    let onSwipeReply: () -> Void
//
//    @State private var dragOffset: CGFloat = 0
//    private let swipeThreshold: CGFloat = 60
//
//    private var isCurrentUser: Bool {
//        message.senderId == Auth.auth().currentUser?.uid
//    }
//
//    var body: some View {
//
//        HStack {
//
//            if isCurrentUser {
//
//                Spacer()
//
//                VStack(alignment: .trailing, spacing: 4) {
//
//                    replyPreview
//
//                    Text(message.text)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 10)
//                        .foregroundColor(.white)
//                        .background(Color.teal)
//                        .clipShape(RoundedRectangle(cornerRadius: 18))
//                        .onLongPressGesture {
//                            onLongPress()
//                        }
//
//                    HStack(spacing: 4) {
//
//                        Text(message.timestamp.dateValue(), style: .time)
//                            .font(.caption2)
//
//                        tickView
//                    }
//                }
//
//            } else {
//
//                VStack(alignment: .leading, spacing: 4) {
//
//                    replyPreview
//
//                    Text(message.text)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 10)
//                        .background(Color(.systemGray5))
//                        .clipShape(RoundedRectangle(cornerRadius: 18))
//                        .onLongPressGesture {
//                            onLongPress()
//                        }
//
//                    Text(message.timestamp.dateValue(), style: .time)
//                        .font(.caption2)
//                }
//
//                Spacer()
//            }
//        }
//        .padding(.horizontal)
//        .offset(x: dragOffset)
//        .overlay(
//            // Reply icon jo swipe karte waqt fade in hota hai
//            Image(systemName: "arrowshape.turn.up.left.fill")
//                .foregroundColor(.gray)
//                .opacity(Double(dragOffset / swipeThreshold))
//                .offset(x: isCurrentUser ? -30 : 20)
//            , alignment: isCurrentUser ? .leading : .leading
//        )
//        .gesture(
//            DragGesture()
//                .onChanged { value in
//
//                    // sirf right swipe allow karein
//                    if value.translation.width > 0 {
//                        dragOffset = min(value.translation.width, swipeThreshold + 20)
//                    }
//                }
//                .onEnded { value in
//
//                    if value.translation.width > swipeThreshold {
//                        onSwipeReply()
//
//                        // halka haptic feedback
//                        let generator = UIImpactFeedbackGenerator(style: .light)
//                        generator.impactOccurred()
//                    }
//
//                    withAnimation(.spring()) {
//                        dragOffset = 0
//                    }
//                }
//        )
//    }
//
//    // MARK: - Reply Quote (agar ye message kisi aur ka reply hai)
//
//    @ViewBuilder
//    private var replyPreview: some View {
//
//        if let replyText = message.replyToText {
//
//            VStack(alignment: .leading, spacing: 2) {
//
//                Text(replyText)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .lineLimit(2)
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 6)
//            }
//            .background(Color(.systemGray6))
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .overlay(
//                Rectangle()
//                    .fill(Color.teal)
//                    .frame(width: 3)
//                , alignment: .leading
//            )
//        }
//    }
//
//    @ViewBuilder
//    private var tickView: some View {
//
//        switch message.status {
//
//        case .sent:
//
//            Image(systemName: "checkmark")
//                .font(.caption2)
//                .foregroundColor(.gray)
//
//        case .delivered:
//
//            HStack(spacing: -6) {
//                Image(systemName: "checkmark")
//                Image(systemName: "checkmark")
//            }
//            .font(.caption2)
//            .foregroundColor(.gray)
//
//        case .read:
//
//            HStack(spacing: -6) {
//                Image(systemName: "checkmark")
//                Image(systemName: "checkmark")
//            }
//            .font(.caption2)
//            .foregroundColor(.blue)
//        }
//    }
//}

//import SwiftUI
//import FirebaseAuth
//import UIKit
//import FirebaseCore
//
//struct MessageBubble: View {
//
//    let message: Message
//    @ObservedObject var viewModel: MessageViewModel
//    let onLongPress: () -> Void
//    let onSwipeReply: () -> Void
//
//    @State private var dragOffset: CGFloat = 0
//    private let swipeThreshold: CGFloat = 60
//
//    // MARK: - Reaction Bar State
//
//    @State private var showReactionBar = false
//    @State private var showFullEmojiPicker = false
//
//    private var isCurrentUser: Bool {
//        message.senderId == Auth.auth().currentUser?.uid
//    }
//
//    var body: some View {
//
//        HStack {
//
//            if isCurrentUser {
//
//                Spacer()
//
//                VStack(alignment: .trailing, spacing: 4) {
//
//                    replyPreview
//
//                    bubbleContent
//
//                    HStack(spacing: 4) {
//
//                        Text(message.timestamp.dateValue(), style: .time)
//                            .font(.caption2)
//
//                        tickView
//                    }
//                }
//
//            } else {
//
//                VStack(alignment: .leading, spacing: 4) {
//
//                    replyPreview
//
//                    bubbleContent
//
//                    Text(message.timestamp.dateValue(), style: .time)
//                        .font(.caption2)
//                }
//
//                Spacer()
//            }
//        }
//        .padding(.horizontal)
//        .offset(x: dragOffset)
//        .overlay(
//            // Reply icon jo swipe karte waqt fade in hota hai
//            Image(systemName: "arrowshape.turn.up.left.fill")
//                .foregroundColor(.gray)
//                .opacity(Double(dragOffset / swipeThreshold))
//                .offset(x: isCurrentUser ? -30 : 20)
//            , alignment: isCurrentUser ? .leading : .leading
//        )
//        .gesture(
//            DragGesture()
//                .onChanged { value in
//
//                    // sirf right swipe allow karein
//                    if value.translation.width > 0 {
//                        dragOffset = min(value.translation.width, swipeThreshold + 20)
//                    }
//                }
//                .onEnded { value in
//
//                    if value.translation.width > swipeThreshold {
//                        onSwipeReply()
//
//                        // halka haptic feedback
//                        let generator = UIImpactFeedbackGenerator(style: .light)
//                        generator.impactOccurred()
//                    }
//
//                    withAnimation(.spring()) {
//                        dragOffset = 0
//                    }
//                }
//        )
//        // MARK: - Reaction Bar dismiss karne ke liye background tap
//        .background(
//            Color.clear
//        )
//        .sheet(isPresented: $showFullEmojiPicker) {
//
//            FullEmojiPickerView { emoji in
//                viewModel.toggleReaction(message: message, emoji: emoji)
//            }
//        }
//    }
//
//    // MARK: - Bubble + Long Press + Reaction Bar Overlay
//
//    @ViewBuilder
//    private var bubbleContent: some View {
//
//        Text(message.text)
//            .padding(.horizontal, 16)
//            .padding(.vertical, 10)
//            .foregroundColor(isCurrentUser ? .white : .primary)
//            .background(isCurrentUser ? Color.teal : Color(.systemGray5))
//            .clipShape(RoundedRectangle(cornerRadius: 18))
//            .onLongPressGesture {
//
//                let generator = UIImpactFeedbackGenerator(style: .medium)
//                generator.impactOccurred()
//
//                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                    showReactionBar = true
//                }
//
//                // purana behavior barqarar: message select ho tho delete/edit menu bhi mil jaye
//                onLongPress()
//            }
//            .overlay(alignment: .top) {
//
//                if showReactionBar {
//
//                    ReactionBarView(
//                        onSelect: { emoji in
//
//                            viewModel.toggleReaction(message: message, emoji: emoji)
//
//                            withAnimation {
//                                showReactionBar = false
//                            }
//                        },
//                        onMore: {
//
//                            withAnimation {
//                                showReactionBar = false
//                            }
//
//                            showFullEmojiPicker = true
//                        }
//                    )
//                    .offset(y: -54)
//                    .zIndex(1)
//                    .onTapGesture { } // taake background tap na lage
//                }
//            }
//            .overlay(alignment: isCurrentUser ? .bottomTrailing : .bottomLeading) {
//
//                ReactionBadgeView(reactions: message.reactions)
//                    .offset(y: 12)
//            }
//            // reaction bar ke bahar tap karne par band ho jaye
//            .onTapGesture {
//
//                if showReactionBar {
//
//                    withAnimation {
//                        showReactionBar = false
//                    }
//                }
//            }
//    }
//
//    // MARK: - Reply Quote (agar ye message kisi aur ka reply hai)
//
//    @ViewBuilder
//    private var replyPreview: some View {
//
//        if let replyText = message.replyToText {
//
//            VStack(alignment: .leading, spacing: 2) {
//
//                Text(replyText)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .lineLimit(2)
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 6)
//            }
//            .background(Color(.systemGray6))
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .overlay(
//                Rectangle()
//                    .fill(Color.teal)
//                    .frame(width: 3)
//                , alignment: .leading
//            )
//        }
//    }
//
//    @ViewBuilder
//    private var tickView: some View {
//
//        switch message.status {
//
//        case .sent:
//
//            Image(systemName: "checkmark")
//                .font(.caption2)
//                .foregroundColor(.gray)
//
//        case .delivered:
//
//            HStack(spacing: -6) {
//                Image(systemName: "checkmark")
//                Image(systemName: "checkmark")
//            }
//            .font(.caption2)
//            .foregroundColor(.gray)
//
//        case .read:
//
//            HStack(spacing: -6) {
//                Image(systemName: "checkmark")
//                Image(systemName: "checkmark")
//            }
//            .font(.caption2)
//            .foregroundColor(.blue)
//        }
//    }
//}

import SwiftUI
import FirebaseAuth
import UIKit
import FirebaseCore

struct MessageBubble: View {

    let message: Message
    @ObservedObject var viewModel: MessageViewModel
    let onLongPress: () -> Void
    let onSwipeReply: () -> Void
    let onActionComplete: () -> Void   // NEW: reaction select/dismiss hone par parent ko batane ke liye

    @State private var dragOffset: CGFloat = 0
    private let swipeThreshold: CGFloat = 60

    // MARK: - Reaction Bar State

    @State private var showReactionBar = false
    @State private var showFullEmojiPicker = false

    private var isCurrentUser: Bool {
        message.senderId == Auth.auth().currentUser?.uid
    }

    var body: some View {

        HStack {

            if isCurrentUser {

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {

                    replyPreview

                    bubbleContent

                    HStack(spacing: 4) {

                        Text(message.timestamp.dateValue(), style: .time)
                            .font(.caption2)

                        tickView
                    }
                }

            } else {

                VStack(alignment: .leading, spacing: 4) {

                    replyPreview

                    bubbleContent

                    Text(message.timestamp.dateValue(), style: .time)
                        .font(.caption2)
                }

                Spacer()
            }
        }
        .padding(.horizontal)
        .offset(x: dragOffset)
        .overlay(
            // Reply icon jo swipe karte waqt fade in hota hai
            Image(systemName: "arrowshape.turn.up.left.fill")
                .foregroundColor(.gray)
                .opacity(Double(dragOffset / swipeThreshold))
                .offset(x: isCurrentUser ? -30 : 20)
            , alignment: isCurrentUser ? .leading : .leading
        )
        .gesture(
            DragGesture()
                .onChanged { value in

                    // sirf right swipe allow karein
                    if value.translation.width > 0 {
                        dragOffset = min(value.translation.width, swipeThreshold + 20)
                    }
                }
                .onEnded { value in

                    if value.translation.width > swipeThreshold {
                        onSwipeReply()

                        // halka haptic feedback
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }

                    withAnimation(.spring()) {
                        dragOffset = 0
                    }
                }
        )
        // MARK: - Reaction Bar dismiss karne ke liye background tap
        .background(
            Color.clear
        )
        .sheet(isPresented: $showFullEmojiPicker) {

            FullEmojiPickerView { emoji in
                viewModel.toggleReaction(message: message, emoji: emoji)
                onActionComplete()   // NEW: emoji pick hote hi toolbar/selection clear
            }
        }
    }

    // MARK: - Bubble + Long Press + Reaction Bar Overlay

    @ViewBuilder
    private var bubbleContent: some View {

        Text(message.text)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundColor(isCurrentUser ? .white : .primary)
            .background(isCurrentUser ? Color.teal : Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .onLongPressGesture {

                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()

                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showReactionBar = true
                }

                // purana behavior barqarar: message select ho tho delete/edit menu bhi mil jaye
                onLongPress()
            }
            .overlay(alignment: .top) {

                if showReactionBar {

                    ReactionBarView(
                        onSelect: { emoji in

                            viewModel.toggleReaction(message: message, emoji: emoji)

                            withAnimation {
                                showReactionBar = false
                            }

                            onActionComplete()   // NEW: reaction select hote hi toolbar bhi hide ho
                        },
                        onMore: {

                            withAnimation {
                                showReactionBar = false
                            }

                            showFullEmojiPicker = true
                        }
                    )
                    .offset(y: -54)
                    .zIndex(1)
                    .onTapGesture { } // taake background tap na lage
                }
            }
            .overlay(alignment: isCurrentUser ? .bottomTrailing : .bottomLeading) {

                ReactionBadgeView(reactions: message.reactions)
                    .offset(y: 12)
            }
            // reaction bar ke bahar tap karne par band ho jaye
            .onTapGesture {

                if showReactionBar {

                    withAnimation {
                        showReactionBar = false
                    }

                    onActionComplete()   // NEW: bahar tap karke dismiss karne par bhi selection clear
                }
            }
    }

    // MARK: - Reply Quote (agar ye message kisi aur ka reply hai)

    @ViewBuilder
    private var replyPreview: some View {

        if let replyText = message.replyToText {

            VStack(alignment: .leading, spacing: 2) {

                Text(replyText)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                Rectangle()
                    .fill(Color.teal)
                    .frame(width: 3)
                , alignment: .leading
            )
        }
    }

    @ViewBuilder
    private var tickView: some View {

        switch message.status {

        case .sent:

            Image(systemName: "checkmark")
                .font(.caption2)
                .foregroundColor(.gray)

        case .delivered:

            HStack(spacing: -6) {
                Image(systemName: "checkmark")
                Image(systemName: "checkmark")
            }
            .font(.caption2)
            .foregroundColor(.gray)

        case .read:

            HStack(spacing: -6) {
                Image(systemName: "checkmark")
                Image(systemName: "checkmark")
            }
            .font(.caption2)
            .foregroundColor(.blue)
        }
    }
}
