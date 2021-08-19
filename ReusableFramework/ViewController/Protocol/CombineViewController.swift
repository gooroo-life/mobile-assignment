//
//  CombineViewController.swift
//  CurrencyConversion
//
//  Created by Frost on 2021/7/14.
//

import Combine

protocol CombineViewController: AnyObject {
    
    var cancellables: Set<AnyCancellable> { get set }
    
}
