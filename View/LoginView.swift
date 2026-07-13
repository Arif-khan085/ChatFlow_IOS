//
//  LoginView.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

//import SwiftUI
//
//struct LoginView: View {
//
//    @State private var email = ""
//    @State private var password = ""
//    @State private var showPassword = false
//
//    var body: some View {
//
//        NavigationStack {
//
//            ScrollView(showsIndicators: false) {
//
//                VStack(alignment: .leading, spacing: 25) {
//                    
//                    
//                    
//                    // MARK: Header
//
//                    VStack(alignment: .leading, spacing: 8) {
//
//                        Text("Welcome Back")
//                            .font(.system(size: 38, weight: .bold))
//
//                        Text("Sign in to continue your conversations with ChatFlow.")
//                            .font(.subheadline)
//                            .foregroundStyle(.gray)
//                    }
//
//                    // MARK: Email
//
//                    VStack(alignment: .leading, spacing: 8) {
//
//                        Text("EMAIL")
//                            .font(.caption)
//                            .fontWeight(.semibold)
//                            .foregroundStyle(.gray)
//
//                        CustomTextField(
//                            placeholder: "name@example.com",
//                            text: $email,
//                            icon: "envelope"
//                        )
//                    }
//
//                    // MARK: Password
//
//                    VStack(alignment: .leading, spacing: 8) {
//
//                        HStack {
//
//                            Text("PASSWORD")
//                                .font(.caption)
//                                .fontWeight(.semibold)
//                                .foregroundStyle(.gray)
//
//                            Spacer()
//
//                            Button("Forgot Password?") {
//
//                            }
//                            .font(.caption)
//                            .foregroundStyle(.cyan)
//                        }
//
//                        SecureInputField(
//                            password: $password,
//                            showPassword: $showPassword
//                        )
//                    }
//
//                    // MARK: Login Button
//
//                    GradientButton(title: "Log In") {
//
//                        print("Login")
//                    }
//
//                    // MARK: Divider
//
//                    HStack (alignment: .center, spacing: 12) {
//
//                        Rectangle()
//                            .fill(.gray.opacity(0.3))
//                            .frame(height: 1)
//
//                        Text("Or continue with")
//                            .font(.subheadline)
//                            .foregroundStyle(.gray)
//                            .fixedSize()
//
//                        Rectangle()
//                            .fill(.gray.opacity(0.3))
//                            .frame(height: 1)
//                    }
//
//                    // MARK: Social Buttons
//
//                    HStack(spacing: 16) {
//
//                        SocialButton(
//                            title: "Apple",
//                            image: "apple.logo",
//                            isSystemImage: true
//                        ) {
//                        }
//
//                        SocialButton(
//                            title: "Google",
//                           image: "google_image",
//                            isSystemImage: false
//                        ) {
//
//                        }
//                    }
//
//                    // MARK: Bottom
//
//                    HStack {
//
//                        Spacer()
//
//                        Text("Don't have an account?")
//                            .foregroundStyle(.gray)
//
//
//                        NavigationLink {
//                            SignUpView()
//                                .navigationBarBackButtonHidden(true)
//                        } label: {
//                            Text("Sign Up")
//                                .foregroundStyle(.cyan)
//                        }
//                        .foregroundStyle(.cyan)
//
//                        Spacer()
//                    }
//
//                    Spacer(minLength: 20)
//                }
//                .padding(24)
//            }
//            .background(Color(.systemGray6))
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//#Preview {
//    LoginView()
//}



import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @StateObject private var viewModel = AuthViewModel()


    var body: some View {

        NavigationStack {

            ZStack {

                // Background
                Color(.systemGray6)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {

                    VStack(alignment: .leading, spacing: 25) {

                        // MARK: Header

                        VStack(alignment: .leading, spacing: 8) {

                            Text("Welcome Back")
                                .font(.system(size: 38, weight: .bold))

                            Text("Sign in to continue your conversations with ChatFlow.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }

                        // MARK: Email

                        VStack(alignment: .leading, spacing: 8) {

                            Text("EMAIL")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray)

                            CustomTextField(
                                placeholder: "name@example.com",
                                text: $email,
                                icon: "envelope"
                            )
                        }

                        // MARK: Password

                        VStack(alignment: .leading, spacing: 8) {

                            HStack {

                                Text("PASSWORD")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray)

                                Spacer()

                                Button("Forgot Password?") {

                                }
                                .font(.caption)
                                .foregroundStyle(.cyan)
                            }

                            SecureInputField(
                                password: $password,
                                showPassword: $showPassword
                            )
                        }

                        // MARK: Login Button

                        GradientButton(title: "Log In") {
                            viewModel.signIn(
                                    email: email,
                                    password: password
                                )
                        }

                        // MARK: Divider

                        HStack(spacing: 12) {

                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)

                            Text("Or continue with")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .fixedSize(horizontal: true, vertical: false)

                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                        }

                        // MARK: Social Login

                        HStack(spacing: 16) {

                            SocialButton(
                                title: "Apple",
                                image: "apple.logo",
                                isSystemImage: true
                            ) {

                            }

                            SocialButton(
                                title: "Google",
                                image: "google_image",
                                isSystemImage: false
                            ) {

                            }
                        }

                        // MARK: Bottom

                        HStack(spacing: 4) {

                            Spacer()

                            Text("Don't have an account?")
                                .foregroundStyle(.gray)

                            NavigationLink {
                                SignUpView()
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.cyan)
                            }

                            Spacer()
                        }
                        .padding(.top, 10)

                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 30)
                }
                .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                    HomeView()
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginView()
}
