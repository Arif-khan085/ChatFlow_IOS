//
//  ActiveUserView.swift
//  ChatFlow
//
//  Created by Arif on 09/07/2026.
//

import SwiftUI

struct ActiveUserView: View {

    let icon: String
    let name: String
    var isStory: Bool = false

    var body: some View {

        VStack(spacing: 8) {

            ZStack(alignment: .bottomTrailing) {

                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .padding(10)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                isStory ? Color.cyan : Color.clear,
                                lineWidth: 3
                            )
                    )

                Circle()
                    .fill(Color.green)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    )
            }

            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)

        }

    }
}

#Preview {
    ActiveUserView(
        icon: "person.crop.circle.fill",
        name: "Julian"
    )
}
