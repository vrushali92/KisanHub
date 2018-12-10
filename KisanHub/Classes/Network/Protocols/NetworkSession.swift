//
//  NetworkSession.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

protocol NetworkSession {
    
    /// Executes the request and verfies the response
    ///
    /// - Parameters:
    ///   - request: URLRequest
    ///   - completionHandler: completionHandler
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
