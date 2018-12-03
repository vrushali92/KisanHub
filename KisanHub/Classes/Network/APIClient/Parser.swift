//
//  Parser.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

func parse<T: Decodable>(toType: T.Type, data: Data) throws -> T {
    return try JSONDecoder().decode(T.self, from: data)
}
