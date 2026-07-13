//
//  UserRow.swift
//  ChatFlow
//
//  Created by Arif on 12/07/2026.
//

import SwiftUI

struct UserRow: View {

    let user: User

    var body: some View {

        HStack(spacing: 15) {

            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 55, height: 55)
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 5) {

                Text(user.fullName)
                    .font(.headline)

                Text(user.email)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Circle()
                .fill(user.isOnline ? Color.green : Color.gray)
                .frame(width: 12, height: 12)
        }
        .padding(.vertical, 6)
    }
}
