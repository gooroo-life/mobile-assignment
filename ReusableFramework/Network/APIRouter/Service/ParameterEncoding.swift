//
//  ParameterEncoding.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/13.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import Foundation

protocol ParameterEncoder {
    
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
    
}

enum ParameterEncoding {
    case formBodyEncoding
    case urlAndJsonEncoding
    
    func encode(urlRequest: inout URLRequest,
                       bodyParameters: Parameters?,
                       urlParameters: Parameters?) throws {
        do {
            switch self {
            case .formBodyEncoding:
                guard let bodyParameters = bodyParameters else { return }
                FormBodyParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            case .urlAndJsonEncoding:
                if let urlParameters = urlParameters {
                    try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                }
                
                if let bodyParameters = bodyParameters {
                    try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                }
            }
        } catch {
            throw error
        }
    }
}

struct FormBodyParameterEncoder: ParameterEncoder {
    
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) {
        let allowedCharacter = CharacterSet.letters.union(.decimalDigits)
        var httpBody: String = ""
        
        for (key, value) in parameters {
            let percentEncodingValue = (value as! String).addingPercentEncoding(withAllowedCharacters: allowedCharacter)!
            httpBody = httpBody.count == 0 ? "\(key)=\(percentEncodingValue)" : "\(httpBody)&\(key)=\(percentEncodingValue)"
        }
        
        urlRequest.httpBody = httpBody.data(using: .utf8)
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
    
}

struct URLParameterEncoder: ParameterEncoder {
    
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else {
            let error = APIError(description: APIErrorDescription.invalidURL)
            throw error
        }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false),
            !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
    }
    
}

struct JSONParameterEncoder: ParameterEncoder {
    
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard parameters.count > 0 else {
            return
        }
        
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters,
                                                        options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            let error = APIError(description: APIErrorDescription.encodingFailed)
            throw error
        }
    }
    
}
