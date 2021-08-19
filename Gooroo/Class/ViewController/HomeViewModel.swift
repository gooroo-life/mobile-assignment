//
//  HomeViewModel.swift
//  Gooroo
//
//  Created by Frost on 2021/8/19.
//

import UIKit

class HomeViewModel {

    @InjectObject var apiManager: ChatbotApiManager
    var values: [Int] = []
    @Published private(set) var results: [ChatbotProcessInfo] = []
    @Published private(set) var isAllValueProcessFinished: Bool = false
    @Published private(set) var combineInfo: ChatbotCombineInfo?

    init() {
        apiManager.delegate = self
    }
    
    private func clearAllActions() {
        isAllValueProcessFinished = false
        apiManager.cancelAllRequests()
        combineInfo = nil
        results.removeAll()
        values.removeAll()
    }
    
    func initValues(_ count: Int) {
        clearAllActions()
        
        for i in 0..<count {
            values.append(i)
        }
    }
    
    func requestProcess(input: Int, errorHandler: ((String) -> ())? = nil) {
        apiManager.requestProcess(input: input) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let info):
                let input = Int(info.input) ?? 0
                if let index = self.values.firstIndex(of: input) {
                    self.values.remove(at: index)
                }
                
                self.results.append(info)
                self.results.sort() {
                    let s0 = Int($0.input) ?? 0
                    let s1 = Int($1.input) ?? 0
                    return s0 > s1
                }
            case .failure(let error):
                errorHandler?(error.description)
            }
        }
    }
    
    func requestCombine(errorHandler: ((String) -> ())? = nil) {        
        let count = results.count >= 10 ? 10 : results.count
        var inputs: [Double] = []
        for i in 0..<count {
            inputs.append(results[i].processedValue)
        }
        
        apiManager.requestCombine(inputs: inputs) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let info):
                self.combineInfo = info
            case .failure(let error):
                errorHandler?(error.description)
            }
        }
    }
    
}

extension HomeViewModel: ChatbotApiManagerDelegate {
    
    func finishAllOperations(_ apiManager: ChatbotApiManager) {
        isAllValueProcessFinished = true
    }
    
}
