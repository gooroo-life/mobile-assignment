//
//  Encodable + Extention.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/13.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import Foundation

extension Encodable {
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
}
