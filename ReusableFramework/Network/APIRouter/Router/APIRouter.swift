//
//  APIRouter.swift
//  FCApiManager
//
//  Created by Frost Chen on 2020/4/21.
//  Copyright © 2020 Frost Chen. All rights reserved.
//

import UIKit

@objc protocol APIRouterDelegate: AnyObject {
    
    @objc optional func finishAllOperations(_ router: APIRouter)
    
}

class APIRouter: NSObject {
    
    private(set) var queue: OperationQueue = OperationQueue()
    var operations = [Int: FCBaseNSURLSessionOperation]()
    private(set) var session: URLSession!
    private(set) var maxConcurrentOperationCount: Int = 3
    private(set) var observation: NSKeyValueObservation?
    weak var delegate: APIRouterDelegate?
    
    override init() {
        super.init()
        self.initQueue(queue: &queue)
        session = self.initSession()
    }
    
    init(maxConcurrentOperationCount: Int) {
        super.init()
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
        self.initQueue(queue: &queue)
        session = self.initSession()
    }
    
    private func initQueue(queue: inout OperationQueue) {
        queue.name = "\(String(describing: Self.self))_APIRouterQueue"
        queue.maxConcurrentOperationCount = self.maxConcurrentOperationCount
        
        observation = queue.observe(\.operationCount, options: [.new]) {
            [unowned self] (queue, change) in
            if change.newValue! == 0 {
                self.delegate?.finishAllOperations?(self)
            }
        }
    }
    
    private func initSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        return URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    private func checkIsTaskExistInQueue(task: URLSessionTask) -> Bool {
        let taskURLString = task.currentRequest?.url?.FCGetAbsoluteURLStringWithoutPort()
        var isExistInQueue = false
        
        for op in queue.operations {
            if let op = op as? FCBaseNSURLSessionOperation {
                let URLString = op.task.currentRequest?.url?.FCGetAbsoluteURLStringWithoutPort()
                
                if(URLString == taskURLString) {
                    isExistInQueue = true
                    break
                }
            }
        }
        return isExistInQueue
    }

    func cancelAllOperations() {
        queue.cancelAllOperations()
        operations.removeAll()
        queue = OperationQueue()
        self.initQueue(queue: &queue)
    }
}

//MARK: Send Request

extension APIRouter {
    
    func dataTask<T: RequestEndpoint>(endpoint: T, completion: @escaping (Result<T.responseModel, APIError>) -> Void) -> FCDataTaskOperation? {
        do {
            let request = try self.buildRequest(endpoint: endpoint)
            APILogger.log(request: request)
            
            let task: URLSessionTask = session.dataTask(with: request)
            let operation: FCDataTaskOperation = FCDataTaskOperation(task: task, endPoint: endpoint)
            
            operation.setCompletion { (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    let apiError = APIError(description: APIErrorDescription.missingResponse)
                    completion(.failure(apiError))
                    
                    return
                }
                
                guard (200..<300 ~= httpResponse.statusCode) else {
                    var description = "statusCode: \(httpResponse.statusCode)"
                   
                    if let data = data {
                        let errorText = String(data: data, encoding: String.Encoding.utf8) ?? ""
                        description = description + ": " + errorText
                    }
                    
                    let apiError = APIError(statusCode: httpResponse.statusCode, description: description)
                    completion(.failure(apiError))
                    return
                }
                
                guard let data = data else {
                    let apiError = APIError(description: APIErrorDescription.missingData)
                    completion(.failure(apiError))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(T.responseModel.self, from: data)
                    completion(.success(model))
                } catch {
                    let apiError = APIError(description: APIErrorDescription.unableToDecode)
                    completion(.failure(apiError))
                }
            }
            
            operations[operation.task.taskIdentifier] = operation
            queue.addOperation(operation)
            return operation
            
        } catch {
            let error = APIError(description: APIErrorDescription.wrongRequest)
            completion(.failure(error))
        }
        
        return nil
    }
    
}

//MARK: Retry Operation

extension APIRouter {
    
    @objc func retryOperation(operation: FCBaseNSURLSessionOperation, task: URLSessionTask) {
        do {
            let endpoint: Endpoint = operation.endPoint
            let retryRequest = try buildRequest(endpoint: endpoint)
            
            var retryTask: URLSessionTask?
            
            if(task is URLSessionDownloadTask) {
                retryTask = self.session?.downloadTask(with: retryRequest)
            } else if(task is URLSessionUploadTask) {
                //retryTask = self.session?.uploadTask(with: request, from: data)
                //TODO
            } else if(task is URLSessionDataTask) {
                retryTask = self.session?.dataTask(with: retryRequest)
            }
            
            if let retryTask = retryTask {
                operation.task = retryTask
                operations[operation.task.taskIdentifier] = operation
                operation.retryTask()
            } else {
                operation.finish()
                operation.completeOperation()
                operations.removeValue(forKey: operation.task.taskIdentifier)
            }
            
        } catch {
            operation.finish()
            operation.completeOperation()
            operations.removeValue(forKey: operation.task.taskIdentifier)
        }
    }
    
    @objc func checkShouldRetryOperation(operation: FCBaseNSURLSessionOperation, task: URLSessionTask) {
        if(operation.retryCount > 0) {
            operations.removeValue(forKey: task.taskIdentifier)
            self.retryOperation(operation: operation, task: task)
        } else {
            operation.finish()
            operation.completeOperation()
            operations.removeValue(forKey: operation.task.taskIdentifier)
        }
    }
    
    private func checkResponseIsValid(response: URLResponse?) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else {
            return false
        }
        
        let isStatusCodeValid = (200...299).contains(httpResponse.statusCode)
        return isStatusCodeValid
    }
}


//MARK: Build Request

extension APIRouter {
    
    private func buildRequest(endpoint: Endpoint) throws -> URLRequest {
        let urlString = endpoint.domain + "\(endpoint.path)"
        
        guard let url = URL(string: urlString)  else {
            let error = APIError(description: APIErrorDescription.invalidURL)
            throw error
        }
        
        var request = URLRequest(url: url, timeoutInterval: endpoint.timeoutInterval)

        request.httpMethod = endpoint.httpMethod.rawValue
        
        do {
            if(endpoint.bodyEncoding == nil) {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } else {
                try self.configureParameters(bodyParameters: endpoint.bodyParameters,
                                             bodyEncoding: endpoint.bodyEncoding!,
                                             urlParameters: endpoint.urlParameters,
                                             request: &request)
            }
            
            if let headers = endpoint.headers {
                self.addHeaders(headers, request: &request)
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    private func addHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func configureParameters(bodyParameters: Parameters?,
                                    bodyEncoding: ParameterEncoding,
                                    urlParameters: Parameters?,
                                    request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
}

extension APIRouter: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        //print("\(bytesSent)")
    }
        
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let key = task.taskIdentifier
        guard let operation = operations[key] else {
            return
        }

        operations.removeValue(forKey: key)
        operation.response = task.response
        operation.error = error

        let isResponseValid = self.checkResponseIsValid(response: operation.response)
        if(operation.error != nil || isResponseValid == false) { //Failed, retry
            if let error = error as NSError? {
                if error.code == NSURLErrorCancelled { //cancel
                    operation.finish()
                    operation.completeOperation()
                    return
                }
            }

            self.checkShouldRetryOperation(operation: operation, task: task)
        } else { // Successed
            if let operation = operation as? FCDataTaskOperation { // return DataTask appendData
                operation.finish()
                operation.completeOperation()
            }
        }
    }
    
}

extension APIRouter: URLSessionDataDelegate {
    
    // MARK: Append Data
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let operation: FCDataTaskOperation? = operations[dataTask.taskIdentifier] as? FCDataTaskOperation
        
        if let operation = operation {
            if(operation.data == nil) {
                operation.data = Data()
            }
            operation.data!.append(data)
        }
    }
    
}

extension APIRouter: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let operation: FCDownloadTaskOperation? = operations[downloadTask.taskIdentifier] as? FCDownloadTaskOperation
        
        if let operation = operation {
            operation.URLSession(session: session, downloadTask: downloadTask, didFinishDownloadingToURL: location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let operation: FCDownloadTaskOperation? = operations[downloadTask.taskIdentifier] as? FCDownloadTaskOperation
        
        if let operation = operation {
            operation.URLSession(session: session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        }
    }
    
}
