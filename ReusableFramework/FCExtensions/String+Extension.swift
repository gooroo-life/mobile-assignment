//
//  F_String_Extensions.swift
//  TaipeiZoom
//
//  Created by Frost on 2015/5/8.
//  Copyright © 2015年 Frost Chen. All rights reserved.
//

import UIKit

extension String {

    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
 
    func FCStringHeightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func FCStringWidthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func FCGetOneLineStringWidth(font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = self + "  "
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        
        return size
    }
    
    enum StringType {
        case empty
        case email
        case number
        case englishAndNumber
        case alphanumericsAndSymbolsAndUTF
        case normal
    }
    
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isEnglishAndNumber() -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        
        for char in self.unicodeScalars {
            if characterset.contains(char) {
                
            }
            else {
                return false
            }
        }
        
        return true
    }
    
    func isAlphanumericsAndSymbolsAndUTF() -> Bool {
        var characterset = CharacterSet()
        characterset.formUnion(.alphanumerics)
        characterset.formUnion(.punctuationCharacters)
        characterset.formUnion(.symbols)
        //        characterset.insert(charactersIn: "!@#$%&")
        
        for char in self.unicodeScalars {
            if characterset.contains(char) {
                
            }
            else {
                return false
            }
        }
        
        return true
    }
    
    func ckeckIsLength(greater: Int, less: Int) -> Bool {
        return (self.count >= greater) && (self.count <= less)
    }
    
    func isNumber() -> Bool {
        return NumberFormatter().number(from: self) != nil
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func checkStringType() -> StringType {
        let text = self.trim()
        
        if(text.isEmpty) {
            return .empty
        }
        
        if(text.isValidEmail()) {
            return .email
        }
        
        if(text.isNumber()) {
            return .number
        }
        
        if(text.isEnglishAndNumber()) {
            return .englishAndNumber
        }
        
        if(text.isAlphanumericsAndSymbolsAndUTF()) {
            return .alphanumericsAndSymbolsAndUTF
        }
        
        return .normal
    }
    
}
