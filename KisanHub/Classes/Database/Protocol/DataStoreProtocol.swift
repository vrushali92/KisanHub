//
//  DataStoreProtocol.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 03/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

/// Provides Datasore functionality
protocol DataStore {
    
    /// CompletionHandler
    typealias ComplationHandler = (Bool) -> Void
    
    /// Loads cache memory if exists
    ///
    /// - Throws: Exception if data is not decodabale/ Data at location is not readable
    func load() throws
    
    /// Saves data in datastore
    ///
    /// - Parameters:
    ///   - data: RecordMap
    ///   - location: Location
    ///   - completionHandler: completion Handler
    func save(data: RecordMap, forLocation location: Location, with completionHandler: ComplationHandler?)
    
    /// Retrieves RecordMap for selected location
    ///
    /// - Parameter location: selected location
    /// - Returns: RecordMap if exists else return nil
    func retrieve(ForLocation location: Location) -> RecordMap?
}
