//
//  DataStoreProtocol.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 03/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

protocol DataStore {
    
    typealias ComplationHandler = (Bool) -> Void
    
    func load() throws
    
    func save(data: RecordMap, forLocation location: Location, with completionHandler: ComplationHandler?)
    
    func retrieve(ForLocation location: Location) -> RecordMap?
}
