//
//  Request.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 10/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

protocol DecodableDataService: URLRequestConvertible {
    associatedtype Response: Decodable
    
    func execute(withSession session: NetworkSession, completionHandler handler: @escaping (Result<Response>) -> Void)
}

extension DecodableDataService {
    func execute(withSession session: NetworkSession, completionHandler handler: @escaping (Result<Response>) -> Void) {
        
        let complationHandle: ((Result<Data>) -> Void) = { response in
            switch response {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(Response.self, from: data)
                    handler(.success(result))
                } catch {
                    handler(.failed(error))
                }
            case .failed(let error):
                handler(.failed(error))
            }
        }
        
        session.execute(request: self, with: complationHandle)
    }
}
