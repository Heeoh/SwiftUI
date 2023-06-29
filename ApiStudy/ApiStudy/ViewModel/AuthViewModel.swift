//
//  SighUpViewModel.swift
//  ApiStudy
//
//  Created by Heeoh Son on 2023/06/29.
//

import Foundation
import Alamofire
import Combine

class AuthVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var loggedInUser: UserInfo? = nil
    
    /// 회원가입
    func kakaoRegister(username: String, email: String?, phoneNumber: String?, nickname: String, gender: String, birthday: [Int]) {
        print("AuthVM - kakaoRegister() called")
        
        AuthApiService.kakaoRegister(username: username, email: email, phoneNumber: phoneNumber, nickname: nickname, gender: gender, birthday: birthday)
            .sink { completion in
                switch completion {
                case .finished:
                    print("API 통신이 완료되었습니다.")
                case .failure(let error):
                    print("API 통신 중 에러가 발생했습니다: \(error)")
                }
            } receiveValue: { response in
                print(response)
            }.store(in: &subscription)
        
        
    }
}
