//
//  F_ NetworkOperation.swift
//  TaipeiZoom
//
//  Created by Frost on 2016/5/9.
//  Copyright © 2016年 Frost Chen. All rights reserved.
//

import UIKit

class FCDownloadTaskOperation: FCBaseNSURLSessionOperation {
    
    typealias DownloadCompletionClosure = ((_ session: URLSession, _ downloadTask: URLSessionDownloadTask, _ location: URL)  -> Void)?
    typealias DownloadProgressClosure =  ((_ session: URLSession, _ downloadTask: URLSessionDownloadTask, _ bytesWritten: Int64, _ totalBytesWritten: Int64, _ totalBytesExpectedToWrite: Int64) -> Void)?

    var completion: DownloadCompletionClosure = nil
    var downloadProgressHandler: DownloadProgressClosure = nil
    
    func setCompletion(_ completion: ((_ session: URLSession,
                                       _ downloadTask: URLSessionDownloadTask,
                                       _ location: URL)  -> Void)?) {
        self.completion = completion
    }
    
    func setProgressHandler(_ handler: ((_ session: URLSession,
                                         _ downloadTask: URLSessionDownloadTask,
                                         _ bytesWritten: Int64,
                                         _ totalBytesWritten: Int64,
                                         _ totalBytesExpectedToWrite: Int64) -> Void)?) {
        self.downloadProgressHandler = handler
    }
    
    override func finish() {
        if(self.isCancelled == true) {
            return
        }
        
    }
    
}


// MARK: NSURLSessionDownloadDelegate methods
extension FCDownloadTaskOperation {
    
    func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: URL) {
        if(self.isCancelled == true) {
            return
        }
        
        if let completion = completion {
            completion(session, downloadTask, location)
        }
    }
    
    func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let downloadProgressClosure = downloadProgressHandler {
            downloadProgressClosure(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
        }
    }
    
}



