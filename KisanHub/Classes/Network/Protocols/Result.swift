//
//  Result.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

/**
 Used to represent state of an operation or process.
 - success: The operation is successful and has provided associated value.
 - failed: The operation has failed and has resulted in error.
 */
enum Result<Value> {
    
    case success(Value)
    case failed(Error)
    
    var value: Value? {
        guard case let Result.success(value) = self else {
            return nil
        }
        return value
    }
    
    var failed: Error? {
        guard case let Result.failed(error) = self else {
            return nil
        }
        return error
    }
}

extension Result: Equatable where Value: Equatable {
    static func == (lhs: Result<Value>, rhs: Result<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsValue), .success(let rhsValue)):
            return lhsValue == rhsValue
            
        case (.failed(let lhsError), .failed(let rhsError)):
            return ((lhsError as NSError).isEqual((rhsError as NSError)))
            
        default:
            return false
        }
        
    }
}
