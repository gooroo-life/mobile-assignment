//
//  ExampleAPIManager.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/17.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import UIKit

final class ExampleAPIManager: ApiManagerProtocol {
    
    var router: APIRouter = APIRouter()
    
}

extension ExampleAPIManager {
    
    func requestExampleWeather(completion: @escaping((Result<ExampleWeatherInfo, APIError>)->())) {
        let model = ExampleWeatherRequest()
        
        _ = router.dataTask(endpoint: model) { (result) in
            switch result {
            case .success(let res):
                completion(.success(res))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

/* Example:
 ExampleAPIManager().requestExampleWeather { (result) in
     switch result {
     case .success(let info):
     print("")
     case .failure(let error):
         break
     }
 }
 */
