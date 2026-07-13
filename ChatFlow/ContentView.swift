//
//  ContentView.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        RootView()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
