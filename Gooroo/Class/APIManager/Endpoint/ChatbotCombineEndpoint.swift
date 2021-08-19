//
//  ChatbotCombineEndpoint.swift
//  Gooroo
//
//  Created by Frost on 2021/8/19.
//

import UIKit


struct ChatbotCombineEndpoint: RequestEndpoint {
    
    typealias responseModel = ChatbotCombineInfo
    
    var domain: String = ChatbotApiManager.domain
    
    var path: String = "combine"
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var bodyParameters: Parameters? {
        return ["input": inputs]
    }
    
    var urlParameters: Parameters?
    
    var bodyEncoding: ParameterEncoding? {
        return .urlAndJsonEncoding
    }
    
    var headers: HTTPHeaders?
    
    let inputs: [Double]
    
    init(inputs: [Double]) {
        self.inputs = inputs
    }
    
}

struct ChatbotCombineInfo: Codable {
    
    let combinedResult: String
    let inputs: [Double]

    enum CodingKeys: String, CodingKey {
        case combinedResult = "combined_result"
        case inputs = "input"
    }
    
}
