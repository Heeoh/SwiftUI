//
//  LoginView.swift
//  MovieRankng
//
//  Created by Heeoh Son on 2023/05/18.
//

import SwiftUI

enum Field {
    case email
    case password
}

struct LoginView: View {
    // MARK: PROPERTIES
    @FocusState private var focusField: Field?
    
    @State private var email : String = ""
    @State private var password : String = ""
    
    // MARK: BODY
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                // welcome text
                Text("Welcome back.")
                    .font(.title)
                    .fontWeight(.semibold)
                
                loginInputField
                
                loginButtonField
                
                Spacer()
            }
        }.padding(.horizontal, 30)
    }
    
    // MARK: LOGIN INPUT FIELD
    /// email address and password text fields
    var loginInputField: some View {
        VStack(alignment: .leading, spacing: 10) {
            // email field
            Text("Email address")
                .font(.system(size: 15, weight: .medium))
            TextField("Email address", text: $email)
                .font(.subheadline)
                .padding()
                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(.gray.opacity(0.6)))
                .focused($focusField, equals: .email)
                .padding(.bottom, 5)
            
            // password field
            Text("Password")
                .font(.system(size: 15, weight: .medium))
            SecureField("Password", text: $password)
                .font(.subheadline)
                .padding()
                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(.gray.opacity(0.6)))
                .focused($focusField, equals: .password)
                .padding(.bottom, 10)
            
            // button to find password
            Button(action: {}) { Text("Forgot password?") }
        }
    }
    
    // MARK: LOGIN BUTTON FIELD
    /// log in and sign up buttons
    var loginButtonField: some View {
        VStack(spacing: 15) {
            // login button
            // become active after getting email and password input
            Button(action: {
                if email.isEmpty {
                    focusField = .email
                    print("Please enter your email address")
                } else if password.isEmpty {
                    focusField = .password
                    print("Please enter your password")
                } else {
                    print("Log in")
                }
            }) {
                Text("Log in")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
            }
            .background(RoundedRectangle(cornerRadius: 50))
            
            // sign up button
            Button(action: { print("Sign up") }) {
                Text("Sign up")
                    .foregroundColor(.black)
                    .font(.system(size: 17, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
            }
            .background(RoundedRectangle(cornerRadius: 50).strokeBorder(.black, lineWidth: 2))
        }
    }
}

// MARK: PREVIEW
struct LoginView_previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

