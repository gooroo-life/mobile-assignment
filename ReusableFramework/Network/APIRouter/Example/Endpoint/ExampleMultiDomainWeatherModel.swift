//
//  ExampleMultiDomainWeatherModel.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/22.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import UIKit

/*
 https://app.quicktype.io/
 
 [
   {
     "title": "London",
     "location_type": "City",
     "woeid": 44418,
     "latt_long": "51.506321,-0.12714"
   }
 ]
*/

class ExampleMultiDomainWeatherRequest: RequestEndpoint {
    typealias responseModel = ExampleWeatherInfo

    var domain: String {
        return MultiDomainAPISetting.shared.currentDomain
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
