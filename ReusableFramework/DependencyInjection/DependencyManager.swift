//
//  DependencyManager.swift
//  CurrencyConversion
//
//  Created by Frost on 2021/8/2.
//

//Example:
//func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//    DependencyManager.shared.register(dependency: CurrencyAPIManager())
//
//    return true
//}
//
//@InjectObject var apiManager: CurrencyAPIManager

import Foundation

@propertyWrapper
struct InjectObject<T> {
    
    private let key: String
    private let manager: DependencyManager
    
    var wrappedValue: T {
        get { manager.resolve(key: key) }
    }
    
    init(_ key: String = String(reflecting: T.self), manager: DependencyManager = DependencyManager.shared) {
        self.key = key
        self.manager = manager
    }
    
}

class DependencyManager {
    
    private var dependencies: [String: Any] = [:]
    static let shared = DependencyManager()
    
    func register<T>(key: String = String(reflecting: T.self), dependency: T) {
        dependencies[key] = dependency
    }
    
    func unRegisterAll() {
        dependencies.removeAll()
    }
    
    func resolve<T>(key: String) -> T {
        guard let dependency = dependencies[key] else {
            fatalError("\(key) has not been added as an injectable object.")
        }
        
        return dependency as! T
    }
    
}
