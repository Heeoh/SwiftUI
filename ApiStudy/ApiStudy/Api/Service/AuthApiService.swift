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

struct ErrorResponse: Codable {
    var errorMessage: String
}

enum ResponseData {
    case empty
    case error(ErrorResponse)
}

// 인증 관련 api 호출
enum AuthApiService {
    static func kakaoRegister(username: String, email: String?, phoneNumber: String?, nickname: String, gender: String, birthday: [Int]) -> AnyPublisher<ErrorResponse, AFError> {
        print("AuthApiService - kakaoRegister() called")
        return ApiClient.shared.session
            .request(AuthRouter.kakaoRegister(username: username, email: email, phoneNumber: phoneNumber, nickname: nickname, gender: gender, birthday: birthday))
//            .publishResponse()
//            .tryMap { response -> ResponseData in
//                guard let statusCode = response.response?.statusCode else {
//                    throw AFError.responseValidationFailed(reason: .unacceptableStatusCode)
//                }
//
//                switch statusCode {
//                case 201:
//                    return .empty
//                case 409:
//                    guard let data = response.data else {
//                        throw AFError.responseSerializationFailed(reason: .inputDataNil)
//                    }
//                    let decoder = JSONDecoder()
//                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
//                    return .error(errorResponse)
//                default:
//                    throw AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode))
//                }
//            }
            .publishDecodable(type: ErrorResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
}
