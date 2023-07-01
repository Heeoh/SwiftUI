//
//  AuthApiService.swift
//  ApiStudy
//
//  Created by Heeoh Son on 2023/06/29.
//

import Foundation
import Alamofire
import Combine

struct EmptyResponse: Codable {}

struct ErrorResponse: Codable, Error {
    var errorMessage: String?
}

enum ResponseData {
    case empty(EmptyResponse)
    case error(ErrorResponse)
}

// 인증 관련 api 호출
enum AuthApiService {
    static func kakaoRegister(username: String, email: String?, phoneNumber: String?, nickname: String, gender: String, birthday: [Int]) -> AnyPublisher<Result<EmptyResponse, ErrorResponse>, AFError> {
        print("AuthApiService - kakaoRegister() called")
        return Future { promise in
            ApiClient.shared.session
                .request(AuthRouter.kakaoRegister(username: username, email: email, phoneNumber: phoneNumber, nickname: nickname, gender: gender, birthday: birthday))
                .validate()
                .responseDecodable(of: EmptyResponse.self, decoder: JSONDecoder()) { response in
                    switch response.result {
                    case .success(let value):
                        if response.response?.statusCode == 200 {
                            promise(.success(.success(value)))
                        } else {
                            let error = ErrorResponse(errorMessage: "Failed with status code: \(response.response?.statusCode ?? 0)")
                            promise(.success(.failure(error)))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}


//enum AuthApiService {
//    static func kakaoRegister(username: String, email: String?, phoneNumber: String?, nickname: String, gender: String, birthday: [Int]) -> AnyPublisher<EmptyResponse, AFError> {
//        print("AuthApiService - kakaoRegister() called")
//        return ApiClient.shared.session
//            .request(AuthRouter.kakaoRegister(username: username, email: email, phoneNumber: phoneNumber, nickname: nickname, gender: gender, birthday: birthday))
//            .publishDecodable(type: EmptyResponse.self)
//            .value()
//            .eraseToAnyPublisher()
//    }
//}
