//
//  APISetting.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/17.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import Foundation

class MultiDomainAPISetting {
    
    static let shared = MultiDomainAPISetting()
    
    private let domains: [String] = ["https://www.metaweather.com1", "https://www.metaweather.com2", "https://www.metaweather.com"]
    var currentDomainIndex: Int = 0
    var currentDomain: String {
        return domains[currentDomainIndex]
    }
    
    func nextDomain() {
        currentDomainIndex = (currentDomainIndex + 1) % domains.count
    }
    
}
