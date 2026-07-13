//
//  SignUpView.swift
//  ChatFlow
//
//  Created by Arif on 07/07/2026.
//

import SwiftUI
import Combine

struct SignUpView: View {
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @StateObject private var viewModel = AuthViewModel()
//    @State var isLoggedIn = false
    
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    @State private var agreeTerms = false
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 30) {
                    
                    // MARK: Header
                    
                    VStack(spacing: 10) {
                        
                        Text("Create Account")
                            .font(.system(size: 42, weight: .bold))
                        
                        Text("Join ChatFlow and connect with the world.")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }
                    .padding(.top,40)
                    
                    // MARK: Full Name
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("FULL NAME")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        CustomTextField(
                            placeholder: "John Doe",
                            text: $fullName,
                            icon: "person"
                        )
                    }
                    
                    // MARK: Email
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("EMAIL ADDRESS")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        CustomTextField(
                            placeholder: "name@example.com",
                            text: $email,
                            icon: "envelope"
                        )
                    }
                    
                    // MARK: Password
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("PASSWORD")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        SecureInputField(
                            password: $password,
                            showPassword: $showPassword
                        )
                    }
                    
                    // MARK: Confirm Password
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("CONFIRM PASSWORD")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        HStack {
                            
                            Image(systemName: "lock")
                                .foregroundStyle(.gray)
                            
                            if showConfirmPassword {
                                
                                TextField("Confirm Password",
                                          text: $confirmPassword)
                                
                            } else {
                                
                                SecureField("Confirm Password",
                                            text: $confirmPassword)
                            }
                            
                            Button {
                                
                                showConfirmPassword.toggle()
                                
                            } label: {
                                
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding()
                        .frame(height: 56)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.05),
                                radius: 8,
                                x: 0,
                                y: 4)
                    }
                    
                    // MARK: Terms
                    
                    HStack(alignment: .top) {
                        
                        Button {
                            
                            agreeTerms.toggle()
                            
                        } label: {
                            
                            Image(systemName:
                                    agreeTerms
                                  ? "checkmark.square.fill"
                                  : "square")
                            .font(.title3)
                            .foregroundStyle(.cyan)
                        }
                        
                        Text("By creating an account, I agree to the ")
                        +
                        Text("Terms of Service")
                            .foregroundStyle(.cyan)
                        +
                        Text(" and ")
                        +
                        Text("Privacy Policy.")
                            .foregroundStyle(.cyan)
                        
                        Spacer()
                        
                    }
                    .font(.footnote)
                    
                    // MARK: Sign Up Button
                    
                    GradientButton(title: "Sign Up") {
                        
                        viewModel.signUp(
                            fullName: fullName,
                            email: email,
                            password: password
                        )
                    }
                    
                    // MARK: Bottom
                    
                    HStack {
                        
                        Spacer()
                        
                        Text("Already have an account?")
                            .foregroundStyle(.gray)
                        
                        NavigationLink("Login") {
                            
                            LoginView()
                        }
                        .foregroundStyle(.cyan)
                        
                        Spacer()
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(20)
            }
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                HomeView()
            }
            .background(Color(.systemGray6))
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    SignUpView()
}
