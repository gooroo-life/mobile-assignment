//
//  URL + APIExtension.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/22.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import Foundation

public extension URL {
    
    func FCGetAbsoluteURLStringWithoutPort() -> String {
        var absoluteUrlString: String = self.absoluteString
        let portString: String? = "\(String(describing: self.port))"
        
        if let portString = portString {
            absoluteUrlString =  absoluteUrlString.replacingOccurrences(of: portString, with: "")
        }
        return absoluteUrlString
    }
    
}

