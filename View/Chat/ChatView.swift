//
//  ChatView.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//




//import SwiftUI
//import FirebaseAuth
//import UIKit
//
//struct ChatView: View {
//
//    let conversationId: String
//    let user: User
//
//    @StateObject private var vm: MessageViewModel
//    @StateObject private var presenceVM: PresenceViewModel
//
//    @State private var selectedMessage: Message?
//
//    @State private var showDeleteMenu = false
//    @State private var showMoreMenu = false
//    @State private var showEditSheet = false
//    @State private var editedText = ""
//
//    init(conversationId: String, user: User) {
//
//        self.conversationId = conversationId
//        self.user = user
//
//        _vm = StateObject(
//            wrappedValue: MessageViewModel(
//                conversationId: conversationId
//            )
//        )
//
//        _presenceVM = StateObject(
//            wrappedValue: PresenceViewModel(
//                otherUserId: user.id
//            )
//        )
//    }
//
//    private var isSelectedMessageCurrentUser: Bool {
//        selectedMessage?.senderId == Auth.auth().currentUser?.uid
//    }
//
//    var body: some View {
//
//        VStack(spacing: 0) {
//
//            ScrollViewReader { proxy in
//
//                ScrollView {
//
//                    LazyVStack(spacing: 12) {
//
//                        ForEach(vm.messages) { message in
//
//                            MessageBubble(
//                                message: message,
//                                viewModel: vm,
//                                onLongPress: {
//                                    selectedMessage = message
//                                },
//                                onSwipeReply: {
//                                    vm.replyingTo = message
//                                }
//                            )
//                            .id(message.id)
//                        }
//
//                        // MARK: - Typing Indicator Bubble
//
//                        if vm.isOtherUserTyping {
//
//                            HStack {
//
//                                Text("\(user.fullName) is typing...")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                                    .padding(.horizontal, 14)
//                                    .padding(.vertical, 8)
//                                    .background(Color(.systemGray5))
//                                    .clipShape(Capsule())
//
//                                Spacer()
//                            }
//                            .padding(.horizontal)
//                            .id("typingIndicator")
//                        }
//                    }
//                    .padding(.vertical)
//                }
//                .onChange(of: vm.messages.count) { _, _ in
//
//                    if let last = vm.messages.last {
//
//                        withAnimation {
//                            proxy.scrollTo(last.id, anchor: .bottom)
//                        }
//                    }
//                }
//                .onChange(of: vm.isOtherUserTyping) { _, isTyping in
//
//                    if isTyping {
//                        withAnimation {
//                            proxy.scrollTo("typingIndicator", anchor: .bottom)
//                        }
//                    }
//                }
//            }
//
//            Divider()
//
//            // MARK: - Reply Preview Bar
//
//            if let replyMsg = vm.replyingTo {
//
//                HStack {
//
//                    VStack(alignment: .leading, spacing: 2) {
//
//                        Text("Replying to")
//                            .font(.caption2)
//                            .foregroundColor(.teal)
//
//                        Text(replyMsg.text)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                            .lineLimit(1)
//                    }
//
//                    Spacer()
//
//                    Button {
//                        vm.replyingTo = nil
//                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.vertical, 8)
//                .background(Color(.systemGray6))
//            }
//
//            MessageInputView(
//                message: $vm.messageText,
//                onSend: {
//                    vm.sendMessage()
//                },
//                onTyping: {
//                    vm.userIsTyping()
//                }
//            )
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//
//            // MARK: - Custom Title: Name + Typing/Online Status
//
//            ToolbarItem(placement: .principal) {
//
//                VStack(spacing: 2) {
//
//                    Text(user.fullName)
//                        .font(.headline)
//
//                    if vm.isOtherUserTyping {
//
//                        Text("typing...")
//                            .font(.caption2)
//                            .foregroundColor(.teal)
//
//                    } else {
//
//                        Text(presenceVM.statusText)
//                            .font(.caption2)
//                            .foregroundColor(presenceVM.isOnline ? .teal : .gray)
//                    }
//                }
//            }
//
//            if selectedMessage != nil {
//
//                ToolbarItem(placement: .topBarTrailing) {
//
//                    Button {
//                        showDeleteMenu = true
//                    } label: {
//                        Image(systemName: "trash")
//                    }
//                }
//
//                ToolbarItem(placement: .topBarTrailing) {
//
//                    Button {
//                        showMoreMenu = true
//                    } label: {
//                        Image(systemName: "ellipsis")
//                    }
//                }
//            }
//        }
//
//        // MARK: - Delete Menu
//
//        .confirmationDialog(
//            "Delete Message",
//            isPresented: $showDeleteMenu
//        ) {
//
//            if isSelectedMessageCurrentUser {
//
//                Button("Delete for Everyone", role: .destructive) {
//                    if let msg = selectedMessage {
//                        vm.deleteForEveryone(message: msg)
//                    }
//                    selectedMessage = nil
//                }
//            }
//
//            Button("Delete for Me", role: .destructive) {
//                if let msg = selectedMessage {
//                    vm.deleteForMe(message: msg)
//                }
//                selectedMessage = nil
//            }
//
//            Button("Cancel", role: .cancel) {
//                selectedMessage = nil
//            }
//        }
//
//        // MARK: - More Menu
//
//        .confirmationDialog(
//            "Message",
//            isPresented: $showMoreMenu
//        ) {
//
//            Button("Copy") {
//                if let msg = selectedMessage {
//                    UIPasteboard.general.string = msg.text
//                }
//                selectedMessage = nil
//            }
//
//            Button("Share") {
//
//                if let msg = selectedMessage {
//
//                    let vc = UIActivityViewController(
//                        activityItems: [msg.text],
//                        applicationActivities: nil
//                    )
//
//                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                       let root = scene.windows.first?.rootViewController {
//
//                        root.present(vc, animated: true)
//                    }
//                }
//                selectedMessage = nil
//            }
//
//            if isSelectedMessageCurrentUser {
//
//                Button("Edit") {
//                    if let msg = selectedMessage {
//                        editedText = msg.text
//                        showEditSheet = true
//                    }
//                }
//            }
//
//            Button("Cancel", role: .cancel) {
//                selectedMessage = nil
//            }
//        }
//
//        // MARK: - Edit Sheet
//
//        .sheet(isPresented: $showEditSheet) {
//
//            NavigationStack {
//
//                VStack {
//
//                    TextField(
//                        "Message",
//                        text: $editedText
//                    )
//                    .textFieldStyle(.roundedBorder)
//                    .padding()
//
//                    Spacer()
//                }
//                .navigationTitle("Edit Message")
//                .toolbar {
//
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button("Cancel") {
//                            showEditSheet = false
//                            selectedMessage = nil
//                        }
//                    }
//
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Button("Save") {
//
//                            if let msg = selectedMessage {
//                                vm.editMessage(
//                                    message: msg,
//                                    newText: editedText
//                                )
//                            }
//
//                            showEditSheet = false
//                            selectedMessage = nil
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

import SwiftUI
import FirebaseAuth
import UIKit

struct ChatView: View {

    let conversationId: String
    let user: User

    @StateObject private var vm: MessageViewModel
    @StateObject private var presenceVM: PresenceViewModel

    @State private var selectedMessage: Message?
    @State private var messageToEdit: Message?   // NEW: Edit flow ke liye alag state (selectedMessage se decouple)

    @State private var showDeleteMenu = false
    @State private var showMoreMenu = false
    @State private var showEditSheet = false
    @State private var editedText = ""

    init(conversationId: String, user: User) {

        self.conversationId = conversationId
        self.user = user

        _vm = StateObject(
            wrappedValue: MessageViewModel(
                conversationId: conversationId
            )
        )

        _presenceVM = StateObject(
            wrappedValue: PresenceViewModel(
                otherUserId: user.id
            )
        )
    }

    private var isSelectedMessageCurrentUser: Bool {
        selectedMessage?.senderId == Auth.auth().currentUser?.uid
    }

    var body: some View {

        VStack(spacing: 0) {

            ScrollViewReader { proxy in

                ScrollView {

                    LazyVStack(spacing: 12) {

                        ForEach(vm.messages) { message in

                            MessageBubble(
                                message: message,
                                viewModel: vm,
                                onLongPress: {
                                    selectedMessage = message
                                },
                                onSwipeReply: {
                                    vm.replyingTo = message
                                },
                                onActionComplete: {
                                    // NEW: reaction select ya reaction bar dismiss hote hi
                                    // top toolbar (trash/ellipsis) bhi hide ho jaye
                                    selectedMessage = nil
                                }
                            )
                            .id(message.id)
                        }

                        // MARK: - Typing Indicator Bubble

                        if vm.isOtherUserTyping {

                            HStack {

                                Text("\(user.fullName) is typing...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray5))
                                    .clipShape(Capsule())

                                Spacer()
                            }
                            .padding(.horizontal)
                            .id("typingIndicator")
                        }
                    }
                    .padding(.vertical)
                }
                .onChange(of: vm.messages.count) { _, _ in

                    if let last = vm.messages.last {

                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: vm.isOtherUserTyping) { _, isTyping in

                    if isTyping {
                        withAnimation {
                            proxy.scrollTo("typingIndicator", anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // MARK: - Reply Preview Bar

            if let replyMsg = vm.replyingTo {

                HStack {

                    VStack(alignment: .leading, spacing: 2) {

                        Text("Replying to")
                            .font(.caption2)
                            .foregroundColor(.teal)

                        Text(replyMsg.text)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }

                    Spacer()

                    Button {
                        vm.replyingTo = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
            }

            MessageInputView(
                message: $vm.messageText,
                onSend: {
                    vm.sendMessage()
                },
                onTyping: {
                    vm.userIsTyping()
                }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            // MARK: - Custom Title: Name + Typing/Online Status

            ToolbarItem(placement: .principal) {

                VStack(spacing: 2) {

                    Text(user.fullName)
                        .font(.headline)

                    if vm.isOtherUserTyping {

                        Text("typing...")
                            .font(.caption2)
                            .foregroundColor(.teal)

                    } else {

                        Text(presenceVM.statusText)
                            .font(.caption2)
                            .foregroundColor(presenceVM.isOnline ? .teal : .gray)
                    }
                }
            }

            if selectedMessage != nil {

                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        showDeleteMenu = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        showMoreMenu = true
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }

        // MARK: - Delete Menu

        .confirmationDialog(
            "Delete Message",
            isPresented: $showDeleteMenu
        ) {

            if isSelectedMessageCurrentUser {

                Button("Delete for Everyone", role: .destructive) {
                    if let msg = selectedMessage {
                        vm.deleteForEveryone(message: msg)
                    }
                    selectedMessage = nil
                }
            }

            Button("Delete for Me", role: .destructive) {
                if let msg = selectedMessage {
                    vm.deleteForMe(message: msg)
                }
                selectedMessage = nil
            }

            Button("Cancel", role: .cancel) {
                selectedMessage = nil
            }
        }
        // NEW: agar dialog ko outside-tap se dismiss kiya jaye (koi button na dabaya ho)
        // tab bhi selection/toolbar clear ho jaye
        .onChange(of: showDeleteMenu) { _, isShowing in
            if !isShowing {
                selectedMessage = nil
            }
        }

        // MARK: - More Menu

        .confirmationDialog(
            "Message",
            isPresented: $showMoreMenu
        ) {

            Button("Copy") {
                if let msg = selectedMessage {
                    UIPasteboard.general.string = msg.text
                }
                selectedMessage = nil
            }

            Button("Share") {

                if let msg = selectedMessage {

                    let vc = UIActivityViewController(
                        activityItems: [msg.text],
                        applicationActivities: nil
                    )

                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let root = scene.windows.first?.rootViewController {

                        root.present(vc, animated: true)
                    }
                }
                selectedMessage = nil
            }

            if isSelectedMessageCurrentUser {

                Button("Edit") {

                    if let msg = selectedMessage {
                        messageToEdit = msg          // NEW: edit ke liye alag se save
                        editedText = msg.text
                        showEditSheet = true
                    }

                    selectedMessage = nil            // toolbar turant hide ho jaye
                }
            }

            Button("Cancel", role: .cancel) {
                selectedMessage = nil
            }
        }
        // NEW: More menu bhi outside-tap se dismiss ho tho toolbar clear ho
        .onChange(of: showMoreMenu) { _, isShowing in
            if !isShowing {
                selectedMessage = nil
            }
        }

        // MARK: - Edit Sheet

        .sheet(isPresented: $showEditSheet) {

            NavigationStack {

                VStack {

                    TextField(
                        "Message",
                        text: $editedText
                    )
                    .textFieldStyle(.roundedBorder)
                    .padding()

                    Spacer()
                }
                .navigationTitle("Edit Message")
                .toolbar {

                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            showEditSheet = false
                            messageToEdit = nil
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {

                            if let msg = messageToEdit {
                                vm.editMessage(
                                    message: msg,
                                    newText: editedText
                                )
                            }

                            showEditSheet = false
                            messageToEdit = nil
                        }
                    }
                }
            }
        }
    }
}


