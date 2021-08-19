//
//  Dictionary + APIExtension.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/22.
//  Copyright © 2020 Frost Chen. All rights reserved.
//
import Foundation

public extension Dictionary {
    
    func FCToHttpParametersString() -> String {
        let allowedCharacter = CharacterSet.letters.union(.decimalDigits)
        
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncoding(withAllowedCharacters: allowedCharacter)!
            let percentEscapedValue = (value as! String).addingPercentEncoding(withAllowedCharacters: allowedCharacter)!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}
