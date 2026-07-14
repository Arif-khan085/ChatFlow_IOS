//
//  MessageBubble.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

//import SwiftUI
//import FirebaseAuth
//import FirebaseCore
//
//struct MessageBubble: View {
//
//    let message: Message
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
//                    Text(message.text)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 10)
//                        .foregroundColor(.white)
//                        .background(Color.teal)
//                        .clipShape(RoundedRectangle(cornerRadius: 18))
//
//                    Text(message.timestamp.dateValue(), style: .time)
//                        .font(.caption2)
//                        .foregroundColor(.gray)
//                }
//
//            } else {
//
//                VStack(alignment: .leading, spacing: 4) {
//
//                    Text(message.text)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 10)
//                        .background(Color(.systemGray5))
//                        .clipShape(RoundedRectangle(cornerRadius: 18))
//
//                    Text(message.timestamp.dateValue(), style: .time)
//                        .font(.caption2)
//                        .foregroundColor(.gray)
//                }
//
//                Spacer()
//            }
//        }
//        .padding(.horizontal)
//    }
//}

//
//import SwiftUI
//import FirebaseAuth
//import FirebaseCore
//
//struct MessageBubble: View {
//
//    let message: Message
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
//                    Text(message.text)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 10)
//                        .foregroundColor(.white)
//                        .background(Color.teal)
//                        .clipShape(RoundedRectangle(cornerRadius: 18))
//
//                    HStack(spacing: 4) {
//
//                        Text(message.timestamp.dateValue(), style: .time)
//                            .font(.caption2)
//                            .foregroundColor(.gray)
//
//                        tickView
//                    }
//                }
//
//            } else {
//
//                VStack(alignment: .leading, spacing: 4) {
//
//                    Text(message.text)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 10)
//                        .background(Color(.systemGray5))
//                        .clipShape(RoundedRectangle(cornerRadius: 18))
//
//                    Text(message.timestamp.dateValue(), style: .time)
//                        .font(.caption2)
//                        .foregroundColor(.gray)
//                }
//
//                Spacer()
//            }
//        }
//        .padding(.horizontal)
//    }
//
//    // MARK: - Tick View
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
//
//                Image(systemName: "checkmark")
//                Image(systemName: "checkmark")
//            }
//            .font(.caption2)
//            .foregroundColor(.gray)
//
//        case .read:
//
//            HStack(spacing: -6) {
//
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

    @State private var showMenu = false
    @State private var showEditSheet = false
    @State private var editedText = ""

    private var isCurrentUser: Bool {
        message.senderId == Auth.auth().currentUser?.uid
    }

    var body: some View {

        HStack {

            if isCurrentUser {

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {

                    Text(message.text)
                        .padding(.horizontal,16)
                        .padding(.vertical,10)
                        .foregroundColor(.white)
                        .background(Color.teal)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .onLongPressGesture {

                            editedText = message.text
                            showMenu = true
                        }

                    HStack(spacing:4){

                        Text(message.timestamp.dateValue(),style:.time)
                            .font(.caption2)

                        tickView
                    }

                }

            } else {

                VStack(alignment:.leading,spacing:4){

                    Text(message.text)
                        .padding(.horizontal,16)
                        .padding(.vertical,10)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius:18))
                        .onLongPressGesture {

                            showMenu = true
                        }

                    Text(message.timestamp.dateValue(),style:.time)
                        .font(.caption2)

                }

                Spacer()
            }

        }
        .padding(.horizontal)

        .confirmationDialog(
            "Message",
            isPresented: $showMenu
        ) {

            Button("📋 Copy") {

                UIPasteboard.general.string = message.text
            }

            Button("📤 Share") {

                let vc = UIActivityViewController(
                    activityItems: [message.text],
                    applicationActivities: nil
                )

                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let root = scene.windows.first?.rootViewController {

                    root.present(vc, animated: true)
                }
            }

            if isCurrentUser {

                Button("✏️ Edit") {

                    showEditSheet = true
                }

                Button("🗑 Delete for Everyone", role: .destructive) {

                    viewModel.deleteForEveryone(message: message)
                }
            }

            Button("🗑 Delete for Me", role: .destructive) {

                // Next Step
            }

            Button("Cancel", role: .cancel){}
        }

        .sheet(isPresented: $showEditSheet){

            NavigationStack{

                VStack{

                    TextField(
                        "Message",
                        text: $editedText
                    )
                    .textFieldStyle(.roundedBorder)
                    .padding()

                    Spacer()

                }
                .navigationTitle("Edit Message")
                .toolbar{

                    ToolbarItem(placement:.topBarLeading){

                        Button("Cancel"){

                            showEditSheet = false
                        }
                    }

                    ToolbarItem(placement:.topBarTrailing){

                        Button("Save"){

                            viewModel.editMessage(
                                message: message,
                                newText: editedText
                            )

                            showEditSheet = false
                        }
                    }

                }

            }

        }

    }

    @ViewBuilder
    private var tickView: some View {

        switch message.status {

        case .sent:

            Image(systemName:"checkmark")
                .font(.caption2)
                .foregroundColor(.gray)

        case .delivered:

            HStack(spacing:-6){

                Image(systemName:"checkmark")
                Image(systemName:"checkmark")
            }
            .font(.caption2)
            .foregroundColor(.gray)

        case .read:

            HStack(spacing:-6){

                Image(systemName:"checkmark")
                Image(systemName:"checkmark")
            }
            .font(.caption2)
            .foregroundColor(.blue)
        }

    }

}
