//
//  FCBaseNSURLSessionOperation.swift
//  PetSaver
//
//  Created by Frost on 2016/5/9.
//  Copyright © 2016年 Frost Chen. All rights reserved.
//

import UIKit

class FCBaseNSURLSessionOperation: FCAsyncOperation {
    
    var task: URLSessionTask!
    var endPoint: Endpoint!
    var retryCount = 2
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(task: URLSessionTask, endPoint: Endpoint) {
        self.task = task
        self.endPoint = endPoint
        super.init()
    }
    
    override func cancel() {
        task.cancel()
        super.cancel()
    }
    
    override func main() {
        task.resume()
    }

    func retryTask(isForce: Bool = false) {
        if(isForce == false) {
            if(retryCount > 0) {
                self.task.resume()
                retryCount = retryCount - 1
            }
        }
        else { //force
            self.task.resume()
        }
    }
    
    func finish() {
        
    }
}

