//
//  DataStore.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 03/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

final class DataStore: DataStoreProtocol {
    
    private let fileName: String
    
    private let directory: FileManager.SearchPathDirectory
    private var inMemoryCache: [Location: RecordMap] = [:]
    private var isLoaded: Bool = false
    
    private lazy var location = FileManager.default.urls(for: self.directory, in: .userDomainMask)[0].appendingPathComponent(self.fileName)
    
    init(fileName: String, directory: FileManager.SearchPathDirectory) {
        self.fileName = fileName
        self.directory = directory
    }
    
    func save(data: ResultMap, forLocation location: Location, with completionHandler: @escaping ((Bool) -> Void)) {
        
        do {

            try self.load()
            self.inMemoryCache[location] = data.reduce(into: [Metrics: [Record]](), { base, element in
                if let records = element.value.value {
                    base[element.key] = records
                }
            })
            self.write(with: completionHandler)
        } catch {
            completionHandler(false)
        }
        
    }
    
    func retrieve(ForLocation location: Location) -> RecordMap? {
        do {
            try self.load()
            return self.inMemoryCache[location]
        } catch {
            return nil
        }
    }
    
    func load() throws {
        guard !self.isLoaded else { return }
        print(self.location.absoluteString)
        
        if !FileManager.default.fileExists(atPath: self.location.path) {
            FileManager.default.createFile(atPath: self.location.path, contents: nil, attributes: nil)
        }
        
        do {
            let data = try Data(contentsOf: self.location)
            
            guard !data.isEmpty else {
                self.isLoaded = true
                return
            }
            
            self.inMemoryCache = try JSONDecoder().decode([Location: RecordMap].self, from: data)
            self.isLoaded = true
        } catch {
            throw error
        }
    }
    
    private func write(with completionHandler: @escaping ((Bool) -> Void)) {
        
        DispatchQueue.global(qos: .background).async { [cache = self.inMemoryCache, path = self.location] in
            do {

                let encoder = JSONEncoder()
                encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
                let data = try encoder.encode(cache)
                try data.write(to: path, options: [.completeFileProtectionUnlessOpen, .atomic])
                completionHandler(true)
            } catch {
                print(error)
                completionHandler(false)
            }
        }
    }
}
