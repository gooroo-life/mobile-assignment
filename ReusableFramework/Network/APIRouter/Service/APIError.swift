//
//  APIError.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/13.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import Foundation

class APIErrorDescription {
    
    static let unconnectedToTheNetwork = "Unconnected to the network.."
    static let responseFailed = "Response Failed"
    static let wrongRequest = "Wrong Request."
    static let parametersNil = "Parameters were nil."
    static let encodingFailed = "Parameter encoding failed."
    static let invalidURL = "URL is nil."
    static let invalidRequest = "invalid request."
    static let missingRequest = "Request is nil."
    static let authenticationError = "You need to be authenticated first."
    static let invalidToken = "Invalid Token."
    static let missingResponse = "Response returned with no Http response."
    static let missingData = "Response returned with no data to decode."
    static let unableToDecode = "We could not decode the response."
    static let clientError = "Client Error"
    static let serverError = "Server Error"
    static let taskExistInQueue = "Task exist in queue"
    static let unknownError = "Unknown Error"
    
}

struct APIError: Error, LocalizedError {
    
    let statusCode: Int
    let description: String

    init(statusCode: Int, description: String) {
        self.statusCode = statusCode
        self.description = description
    }
    
    init(description: String) {
        self.statusCode = -99999
        self.description = description
    }
    
}
