//
//  Dictionary+WeatherReportService.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 03/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

extension Dictionary where Key == Metrics, Value == WeatherReportService {
    
    func execute(withSession session: NetworkSession, completionHandler handler: @escaping CompletionHandler) {
        
        let group = DispatchGroup()
        var responseMap = RecordMap()
        
        for key in self.keys {
            guard let service = self[key] else { continue }
            group.enter()
            service.execute(withSession: session) { result in
                responseMap[key] = result.value
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.global()) {
            
            guard !responseMap.isEmpty else { return }
            
            handler(Result.success(responseMap))
        }
    }
}
