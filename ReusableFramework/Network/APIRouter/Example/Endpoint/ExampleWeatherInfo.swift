//
//  WeatherModelExample.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/17.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

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

import Foundation

typealias ExampleWeatherInfo = [ExampleWeatherInfoElement]

// MARK: - ExampleWeatherInfoElement
struct ExampleWeatherInfoElement: Codable {
    let title, locationType: String
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}


