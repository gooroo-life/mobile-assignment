//
//  AsynchronousOperation.swift
//  TaipeiZoom
//
//  Created by Frost on 2016/5/9.
//  Copyright © 2016年 Frost Chen. All rights reserved.
//

import UIKit

class FCAsyncOperation: Operation {
    
    override var isAsynchronous: Bool { return true }
    private var _isExecuting: Bool = false
    override var isExecuting: Bool {
        get {
            return _isExecuting
        } set {
            if (_isExecuting != newValue) {
                self.willChangeValue(forKey: "isExecuting")
                _isExecuting = newValue
                self.didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    private var _isFinished: Bool = false
    override var isFinished: Bool {
        get {
            return _isFinished
        } set {
            if (_isFinished != newValue) {
                self.willChangeValue(forKey: "isFinished")
                _isFinished = newValue
                self.didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    func completeOperation() {
        if isExecuting {
            isExecuting = false
            isFinished = true
        }
    }
    
    override func start() {
        if (isCancelled) {
            isFinished = true
            return
        }
        
        isExecuting = true
        main()
    }
    
}
