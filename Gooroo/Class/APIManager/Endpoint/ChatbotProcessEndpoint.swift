//
//  ChatbotProcessEndpoint.swift
//  Gooroo
//
//  Created by Frost on 2021/8/19.
//

import Foundation

struct ChatbotProcessEndpoint: RequestEndpoint {
    
    typealias responseModel = ChatbotProcessInfo

    var domain: String = ChatbotApiManager.domain

    var path: String = "process"

    var httpMethod: HTTPMethod {
        return .get
    }

    var bodyParameters: Parameters?

    var urlParameters: Parameters? {
        return ["input": "\(input)"]
    }

    var bodyEncoding: ParameterEncoding? {
        return .urlAndJsonEncoding
    }

    var headers: HTTPHeaders?
    
    let input: Int
    
    init(input: Int) {
        self.input = input
    }
    
}

struct ChatbotProcessInfo: Codable {
    
    let input: String
    let processedValue: Double

    enum CodingKeys: String, CodingKey {
        case input = "input"
        case processedValue = "processed_input"
    }
    
}
