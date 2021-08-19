//
//  EndPoint.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/13.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import Foundation

import Foundation

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]

class EndpointDefaultSetting {
    
    static var retryTime = 3
    
}

enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

protocol Endpoint {
    
    var domain: String { get }
    
    var path: String { get }
    
    var httpMethod: HTTPMethod { get }
    
    var bodyParameters: Parameters? { get }
    
    var urlParameters: Parameters? { get }
    
    var bodyEncoding: ParameterEncoding? { get }
    
    var headers: HTTPHeaders? { get }
    
    var timeoutInterval: Double { get }
}

extension Endpoint {

    var timeoutInterval: Double {
        return 16
    }

}

protocol RequestEndpoint: Endpoint {
    
    associatedtype responseModel: Decodable
    
}
