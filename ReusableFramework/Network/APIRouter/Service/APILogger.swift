//
//  APILogger.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/13.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import Foundation

class APILogger {
    
    static func log(request: URLRequest) {
        #if DEBUG
        
        print("- - - - - - - - - - SEND REQUEST - - - - - - - - - - \n")
        defer { print("- - - - - - - - - - END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = urlComponents?.query != nil ? "?\(urlComponents?.query ?? "")" : ""
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = "\(urlAsString) \n\n\(method) \(path)\(query) HTTP/1.1 \nHOST: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n\(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
        
        #endif
    }
    
    static func printJsonStringFromData(data: Data, message: String) {
        #if DEBUG
        print("- - - - - - - - - - Print JsonString From Data START - - - - - - - - - - \n")
        defer { print("- - - - - - - - - - Print Json String From Data END - - - - - - - - - - \n") }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                 print("message: \(message)\njsonString: \(json)")
            } else {
                print("message: \(message)\njsonString: parse jason string failed.")
            }
        } catch {
            print("message: \(message)\njsonString: parse jason string failed.")
        }
        
        #endif
    }
    
    static func log(response: URLResponse) {
        #if DEBUG
        #endif
    }
}
