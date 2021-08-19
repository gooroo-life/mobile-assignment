//
//  ApiManager.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/14.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import Foundation

final class MultiDomainAPIManager: ApiManagerProtocol {
    
    var router: APIRouter = MultiDomainAPIRouter(maxConcurrentOperationCount: 5)
    
}

extension MultiDomainAPIManager {
    
    func requestExampleWeather(completion: @escaping((Result<ExampleWeatherInfo, APIError>)->())) {
        let model = ExampleMultiDomainWeatherRequest()

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

