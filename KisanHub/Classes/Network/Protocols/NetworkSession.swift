//
//  NetworkSession.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
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

protocol NetworkSession {
    func execute(request: URLRequestConvertible, with completionHandler: @escaping (Result<Data>) -> Void)
}

extension URLSession: NetworkSession {
    
    private typealias DataTaskCompletionCallback = (Data?, URLResponse?, Error?) -> Void
    
    func execute(request: URLRequestConvertible, with completionHandler: @escaping (Result<Data>) -> Void) {
        
        do {
            let urlRequest = try request.asURLRequest()
            print(urlRequest)
            let completion: DataTaskCompletionCallback = { (data, response, error) in
                if let error = error {
                    completionHandler(.failed(error))
                }
                
                guard let response = response as? HTTPURLResponse, NetworkConstants.acceptableStatusCodes.contains(response.statusCode) else {
                    completionHandler(.failed(ResponseError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completionHandler(.failed(ResponseError.noDataAvailable))
                    return
                }
                completionHandler(.success(data))
            }
            
            let task = self.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
            
        } catch {
            completionHandler(.failed(error))
        }
    }
}
