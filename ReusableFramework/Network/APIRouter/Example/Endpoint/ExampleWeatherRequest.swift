//
//  WeatherModelExample.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/17.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

/*
https://www.metaweather.com/api/location/search/?query=london
*/

import UIKit

class ExampleWeatherRequest: RequestEndpoint {
    typealias responseModel = ExampleWeatherInfo
    
    var domain: String {
        return "https://www.metaweather.com"
    }
    
    var path: String {
        return "/api/location/search"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var bodyParameters: Parameters?
    
    var urlParameters: Parameters? {
        return [
            "query": "london",
        ]
    }
    
    var bodyEncoding: ParameterEncoding? {
        return .urlAndJsonEncoding
    }
    
    var headers: HTTPHeaders?
}
