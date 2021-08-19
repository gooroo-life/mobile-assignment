//
//  FCDataTaskOperation.swift
//  PetSaver
//
//  Created by Frost on 2016/5/9.
//  Copyright © 2016年 Frost Chen. All rights reserved.
//

import UIKit

class FCDataTaskOperation: FCBaseNSURLSessionOperation {
    
    var completion: ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)?
    
    func setCompletion(_ completion: ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)?) {
        self.completion = completion
    }
    
    override func finish() {
        if(self.isCancelled == true) {
            return
        }
        
        if let completion = completion {
            completion(data, response, error)
        }
    }
    
}


