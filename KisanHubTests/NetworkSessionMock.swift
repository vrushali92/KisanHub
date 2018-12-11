//
//  NetworkSessionMock.swift
//  KisanHubTests
//
//  Created by Vrushali Kulkarni on 10/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
@testable import KisanHub

final class NetworkSessionMock: NetworkSession {
    
    enum  NetworkSessionMockError: Error {
        case responseIsNotSet
    }
    var request: URLRequestConvertible?
    var url: URL?
    var response: Result<Data>?
    
    func execute(request: URLRequestConvertible, with completionHandler: @escaping (Result<Data>) -> Void) {
        
        do {
            self.request = request
            self.url = try request.asURLRequest().url
            guard let response = self.response else {
                completionHandler(.failed(NetworkSessionMockError.responseIsNotSet))
                return
            }
            completionHandler(response)
        } catch {
            completionHandler(.failed(error))
        }
    }
}
