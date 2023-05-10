//
//  ContentView.swift
//  Login
//
//  Created by Heeoh Son on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    @State private var email : String = ""
    @State private var password : String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Button(action: {}) {
                Image(systemName: "chevron.backward").foregroundColor(.black)
            } // navigationLnk를 사용하면 자동으로 back button 생김
            .padding(.vertical, 10)
            
            Text("Welcome back.")
                .font(.title)
                .fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 10) {
                Text("Email address")
                    .font(.system(size: 15, weight: .medium))
                TextField("Email address", text: $email)
                    .font(.subheadline)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(.gray.opacity(0.6)))
                    .padding(.bottom,5)
                Text("Password")
                    .font(.system(size: 15, weight: .medium))
                SecureField("Password", text: $password)
                    .font(.subheadline)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(.gray.opacity(0.6)))
                Button(action: {}) { Text("Forgot password?") }
                    .padding(.top, 10)
            }
            
            VStack(spacing: 15) {
                Button(action: { print("sign up bin tapped") }) {
                    Text("Log in")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .medium))
                }
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 50))
                Button(action: {}) {
                    Text("Sign up")
                        .foregroundColor(.black)
                        .font(.system(size: 17, weight: .medium))
                }
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 50).strokeBorder(.black, lineWidth: 2))
            }
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

struct ContentView_previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
