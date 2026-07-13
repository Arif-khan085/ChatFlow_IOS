//
//  ChatItem.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

import Foundation

struct ChatItem: Identifiable {

    let id: String
    let conversationId: String
    let user: User
    let lastMessage: String
    let lastMessageTime: Date
}
