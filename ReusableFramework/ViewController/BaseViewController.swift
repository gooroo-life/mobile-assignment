//
//  BaseViewController.swift
//  CurrencyConversion
//
//  Created by Frost on 2021/7/14.
//

import UIKit
import Combine

class BaseViewController: UIViewController, CombineViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        let className = NSStringFromClass(type(of: self))
        let bundle: Bundle = Bundle(for: NSClassFromString(className)!)
        let xibName = className.components(separatedBy: ".").last!
        super.init(nibName: xibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
