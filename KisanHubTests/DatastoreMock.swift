//
//  DatastoreMock.swift
//  KisanHubTests
//
//  Created by Vrushali Kulkarni on 11/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
@testable import KisanHub

final class DatastoreMock: DataStore {
    
    private let fileName: String
    private let directory: FileManager.SearchPathDirectory
    
    private var inMemoryCache: [Location: RecordMap] = [:]
    private var isLoaded: Bool = false
    
    private lazy var location = ""
    
    init(fileName: String = "", directory: FileManager.SearchPathDirectory = .documentDirectory) {
        self.fileName = fileName
        self.directory = directory
    }
    
    func load() throws { }
    
    func save(data: RecordMap, forLocation location: Location, with completionHandler: ComplationHandler?) {
        
        self.inMemoryCache[location] = data
    }
    
    func retrieve(ForLocation location: Location) -> RecordMap? {
        return self.inMemoryCache[location]
    }
    
    func hasStoredResponse(forLocation location: Location) -> Bool {
        return self.inMemoryCache.keys.contains(location)
    }
}
