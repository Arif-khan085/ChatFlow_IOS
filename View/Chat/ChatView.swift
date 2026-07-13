//
//  ChatView.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

import SwiftUI

struct ChatView: View {

    let conversationId: String
    let user: User

    @StateObject private var vm: MessageViewModel

    init(conversationId: String, user: User) {

        self.conversationId = conversationId
        self.user = user

        _vm = StateObject(
            wrappedValue: MessageViewModel(
                conversationId: conversationId
            )
        )
    }

    var body: some View {

        VStack(spacing: 0) {

            ScrollViewReader { proxy in

                ScrollView {

                    LazyVStack(spacing: 12) {

                        ForEach(vm.messages) { message in

                            MessageBubble(message: message)
                                .id(message.id)
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
            }

            Divider()

            MessageInputView(
                message: $vm.messageText
            ) {

                vm.sendMessage()
            }
        }
        .navigationTitle(user.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
