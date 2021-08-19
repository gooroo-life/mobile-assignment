//
//  ChatbotApiManager.swift
//  Gooroo
//
//  Created by Frost on 2021/8/18.
//

import UIKit

protocol ChatbotApiManagerDelegate: AnyObject {
    
    func finishAllOperations(_ apiManager: ChatbotApiManager)
    
}


class ChatbotApiManager {

    private(set) static var domain = "https://exorciser-chatbot.herokuapp.com/"

    private let router: APIRouter = APIRouter(maxConcurrentOperationCount: 5)
    weak var delegate: ChatbotApiManagerDelegate?
    
    init() {
        router.delegate = self
    }
    
    func requestProcess(input: Int,
                        completion: @escaping((Result<ChatbotProcessInfo, APIError>)->())) {
        let endpoint = ChatbotProcessEndpoint(input: input)
        
        _ = router.dataTask(endpoint: endpoint) { (result) in
            switch result {
            case .success(let info):
                completion(.success(info))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestCombine(inputs: [Double],
                        completion: @escaping((Result<ChatbotCombineInfo, APIError>)->())) {
        let endpoint = ChatbotCombineEndpoint(inputs: inputs)
        
        _ = router.dataTask(endpoint: endpoint) { (result) in
            switch result {
            case .success(let info):
                completion(.success(info))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelAllRequests() {
        router.cancelAllOperations()
    }
}

extension ChatbotApiManager: APIRouterDelegate {
    
    func finishAllOperations(_ router: APIRouter) {
        delegate?.finishAllOperations(self)
    }
    
}
