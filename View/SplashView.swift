//
//  SplashView.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

import SwiftUI

struct SplashView: View {

    var body: some View {

        ZStack {

            Color.blue
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Image(systemName: "message.fill")
                    .font(.system(size: 90))
                    .foregroundStyle(.white)

                Text("ChatFlow")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)

                ProgressView()
                    .tint(.white)
            }
        }
    }
}
