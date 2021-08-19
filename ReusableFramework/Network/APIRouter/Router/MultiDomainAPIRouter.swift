//
//  APIRouter.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/13.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import Foundation

class MultiDomainAPIRouter: APIRouter {

    @objc override func retryOperation(operation: FCBaseNSURLSessionOperation, task: URLSessionTask) {
        operations.removeValue(forKey: task.taskIdentifier)
        
        MultiDomainAPISetting.shared.nextDomain()
        super.retryOperation(operation: operation, task: task)
    }
}
