//
//  DataStoreProtocol.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 03/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

protocol DataStoreProtocol {
    
    func load() throws
    
    func save(data: ResultMap, forLocation location: Location, with completionHandler: @escaping ((Bool) -> Void))
    
    func retrieve(ForLocation location: Location) -> RecordMap?
}
