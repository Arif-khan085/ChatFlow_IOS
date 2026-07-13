//
//  CallView.swift
//  ChatFlow
//
//  Created by Arif on 09/07/2026.
//

import SwiftUI

struct CallView: View {

    var body: some View {

        VStack {

            Spacer()

            Image(systemName: "phone.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)

            Text("Calls")
                .font(.title)
                .fontWeight(.bold)

            Spacer()
        }
        .navigationTitle("Calls")
    }
}

#Preview {
    CallView()
}
