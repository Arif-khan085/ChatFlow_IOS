//
//  GroupView.swift
//  ChatFlow
//
//  Created by Arif on 09/07/2026.
//

import SwiftUI

struct GroupView: View {

    var body: some View {

        VStack {

            Spacer()

            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text("Groups")
                .font(.title)
                .fontWeight(.bold)

            Spacer()
        }
        .navigationTitle("Groups")
    }
}

#Preview {
    GroupView()
}
