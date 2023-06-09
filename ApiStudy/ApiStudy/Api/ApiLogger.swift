//
//  ApiLogger.swift
//  ApiStudy
//
//  Created by Heeoh Son on 2023/06/29.
//

import Foundation
import Alamofire

final class ApiLogger: EventMonitor {
    let queeu = DispatchQueue(label: "WeIT_ApiLogger")
    
    func requestDidResume(_ request: Request) {
        print("ApiLogger - resuming: \(request)")
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        debugPrint("ApiLogger - finished: \(request)")
    }
}
