//
//  ContentView.swift
//  ApiStudy
//
//  Created by Heeoh Son on 2023/06/29.
//

import SwiftUI

struct UserInfo {
    var username: String = ""
    var email: String? = nil
    var nickname: String = ""
    var phoneNumber: String? = nil
    var gender: String = ""
    var birthday: [Int] = []
    
    static func getDummy() -> Self {
        return UserInfo(username: "KAKAO_1234", email: "test@test.com", nickname: "testNickname", gender: "M", birthday: [1999, 10, 10])
    }
}

struct ContentView: View {
    @State var userInfo = UserInfo()
    @StateObject var authVM = AuthVM()

//    @State private var validationMessage: String = "닉네임을 입력한 후 중복 확인 버튼을 눌러 주세요!"
    
    var body : some View {
        
        VStack(spacing: 20) {
            // username
            VStack(alignment: .leading, spacing: 5) {
                Text("User Name")
                TextField("User Name", text: $userInfo.username)
                    .customTextFieldStyle()
            }
            
            // nickname
            VStack(alignment: .leading, spacing: 5) {
                Text("Nickname")
                TextField("Nickname", text: $userInfo.nickname)
                    .customTextFieldStyle()
            }
            
            // email
            VStack(alignment: .leading, spacing: 5) {
                Text("Email Address")
                TextField("Email Address", text: $userInfo.email.toUnwrapped(defaultValue: ""))
                    .customTextFieldStyle()
            }
            
            // phone number
            VStack(alignment: .leading, spacing: 5) {
                Text("Phone Number")
                TextField("Phone Number", text: $userInfo.phoneNumber.toUnwrapped(defaultValue: ""))
                    .customTextFieldStyle()
            }
            
            // sign up buttom
            Button(action: {
                authVM.kakaoRegister(username: userInfo.username, email: userInfo.email, phoneNumber: userInfo.phoneNumber, nickname: userInfo.nickname, gender: "M", birthday: [1999, 10, 10]) { isSuccess, errorMessage in
                    print("SignUp Button")
                    if isSuccess == true {
                        print("success")
                    } else if let message = errorMessage {
                        print(message)
                    } else {
                        print("unknown error")
                    }
                }
            }) {
                Text("sign up")
            }
            .padding(.vertical, 50)
        }
        .padding(.horizontal, 20)
    }
}

struct SighUpView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(.gray.opacity(0.6)))
            .padding(.bottom, 5)
    }
}

extension TextField {
    func customTextFieldStyle() -> some View {
        self.modifier(CustomTextFieldStyle())
    }
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
