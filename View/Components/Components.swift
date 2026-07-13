//
//  Components.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

import SwiftUI
// MARK: - Custom Text Field

struct CustomTextField: View {

    let placeholder: String
    @Binding var text: String
    let icon: String

    var body: some View {

        HStack(spacing: 15) {

            Image(systemName: icon)
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

        }
        .padding()
        .frame(height: 56)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}


// MARK: - Secure Password Field

struct SecureInputField: View {

    @Binding var password: String
    @Binding var showPassword: Bool

    var body: some View {

        HStack(spacing: 15) {

            Image(systemName: "lock")
                .foregroundColor(.gray)

            if showPassword {

                TextField("Password", text: $password)

            } else {

                SecureField("Password", text: $password)
            }

            Button {

                showPassword.toggle()

            } label: {

                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }

        }
        .padding()
        .frame(height: 56)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}


// MARK: - Gradient Button

struct GradientButton: View {

    let title: String
    var action: () -> Void

    var body: some View {

        Button(action: action) {

            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(

                    LinearGradient(
                        colors: [
                            Color.cyan,
                            Color.blue
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}


// MARK: - Social Button

struct SocialButton: View {

    let title: String
    let image: String
    let isSystemImage: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {

                if isSystemImage {
                    Image(systemName: image)
                        .font(.title3)
                } else {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                }

                Text(title)
                    .fontWeight(.medium)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8)
        }
    }
}
