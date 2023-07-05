//
//  AuthApiService.swift
//  ApiStudy
//
//  Created by Heeoh Son on 2023/06/29.
//

import Foundation
import Alamofire
import Combine

struct EmptyResponse : Codable {}

// 1. Error 타입 정의
enum APIError: Error {
    case BAD_REQUEST(ErrorData)             // 400 Bad request / Request is invalid
    case UNAUTHORIZED(ErrorData)            // 401 Token is invalid / Unauthenticated Access
    case FORBIDDEN(ErrorData)               // 403 Permission is invalid
    case METHOD_NOT_ALLOWED(ErrorData)      // 405 Http Method is invalid
    case CONFLICT(ErrorData)                // 409 Request resource already exists
    case INTERNAL_SERVER_ERROR(ErrorData)   // 500 Internal server error
    case unknown
}
 
// 2. ErrorData 안에 들어갈 정보 선언
struct ErrorData: Codable {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "errorMessage"
    }
}

struct APIService {
    // 4. Resonse 선언
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: DataRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, APIError> {
        return request
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { result -> Response<T> in
                debugPrint(result)
                let statusCode = result.response?.statusCode ?? 0
                
                switch statusCode {
                case 200, 201:
                    if let data = result.data { // 응답이 성공이고 result가 있을 때
                        let value = try decoder.decode(T.self, from: data)
                        return Response(value: value, response: result.response!)
                    } else { // 응답이 성공이고 result가 없을 때 Empty를 리턴
                        return Response(value: EmptyResponse() as! T, response: result.response!)
                    }
                case 400...500:
                    if let errorData = result.data {
                        // TODO: api 2-2 카카오 로그인 토큰 유효성 실패의 경우 디코딩 타입이 다름
                        let value = try decoder.decode(ErrorData.self, from: errorData)
                        
                        switch statusCode {
                        case 400:
                            throw APIError.BAD_REQUEST(value)
                        case 401:
                            throw APIError.UNAUTHORIZED(value)
                        case 403:
                            throw APIError.FORBIDDEN(value)
                        case 405:
                            throw APIError.METHOD_NOT_ALLOWED(value)
                        case 409:
                            throw APIError.CONFLICT(value)
                        case 500:
                            throw APIError.INTERNAL_SERVER_ERROR(value)
                        default:
                            throw APIError.unknown
                        }
                    } else {
                        throw APIError.unknown
                    }
                default:
                    throw APIError.unknown
                }
            }
            .mapError({ (error) -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .unknown
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

 /// 인증 관련 api 호출
enum AuthApiService {
    static let agent = APIService()
    
    static func kakaoRegister(username: String, email: String?, phoneNumber: String?, nickname: String, gender: String, birthday: [Int]) -> AnyPublisher<EmptyResponse, APIError> {
        print("AuthApiService - kakaoRegister() called")
        
        let request = ApiClient.shared.session.request(AuthRouter.kakaoRegister(username: username, email: email, phoneNumber: phoneNumber, nickname: nickname, gender: gender, birthday: birthday))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

