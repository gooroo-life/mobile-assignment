//
//  ViewController.swift
//  Gooroo
//
//  Created by Frost on 2021/8/18.
//

import UIKit
import Combine

class HomeViewController: UIViewController, CombineViewController {

    var cancellables = Set<AnyCancellable>()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.text = "100"
        textField.borderStyle = UITextField.BorderStyle.line
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 2
        textField.clearButtonMode = .never
        textField.contentVerticalAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    } ()
    
    lazy var sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = .blue
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendButtonDidTouch), for: .touchUpInside)
        
        return sendButton
    } ()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    } ()
    
    var vm = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        bindVM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func initUI() {
        self.initTextField()
        self.initSendButton()
        self.initTableView()
    }
    
    private func initTextField() {
        view.addSubview(textField)
        textField.delegate = self
        
        textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                        constant: 20).isActive = true
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                       constant: 20).isActive = true

        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func initSendButton() {
        view.addSubview(sendButton)
        
        sendButton.topAnchor.constraint(equalTo: textField.topAnchor,
                                        constant: 0).isActive = true
        sendButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                        constant: -20).isActive = true
        sendButton.leftAnchor.constraint(equalTo: textField.rightAnchor,
                                        constant: 20).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendButton.heightAnchor.constraint(equalTo: textField.heightAnchor,
                                           constant: 0).isActive = true
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor,
                                        constant: 20).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                        constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                        constant: 00).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                          constant: 0).isActive = true
    }
    
    private func bindVM() {
        vm.$results
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (results) in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
        
        vm.$isAllValueProcessFinished
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (isFinished) in
                if(isFinished) {
                    self?.requestCombine()
                }
            }.store(in: &cancellables)
        
        vm.$combineInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (info) in
                if let info = info {
                    FCToastView.showMessage(message: "CombinedResult: \(info.combinedResult)")
                }
                
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
    private func requestCombine() {
        guard vm.combineInfo == nil else {
            return
        }
        
        FCToastView.showMessage(message: "Request combine")
        
        vm.requestCombine { errorMessage in
            DispatchQueue.main.async {
                FCToastView.showMessage(message: errorMessage)
            }
        }
    }
    
    private func requestAllProcesses() {
        FCToastView.showMessage(message: "Request all processes")
        
        for i in 0..<vm.values.count {
            let input = vm.values[i]
            vm.requestProcess(input: input) { errorMessage in
                FCToastView.showMessage(message: errorMessage)
            }
        }
    }
    
    @objc func sendButtonDidTouch() {
        textField.resignFirstResponder()
        
        let value = Int(textField.text ?? "0") ?? 0
        vm.initValues(value)
        requestAllProcesses()
    }
    
}

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 3
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.values.count + vm.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isResult = indexPath.row < vm.results.count
        let isFirstTenCells = indexPath.row < 10
        let isAllFinished = vm.combineInfo != nil
        
        let cell = UITableViewCell()
        var textColor = UIColor.darkText
        
        if(isResult) {
            textColor = isAllFinished && isFirstTenCells ? UIColor.blue : textColor
            let result = vm.results[indexPath.row]
            cell.textLabel?.text = "\(result.input): \(result.processedValue)"
        } else {
            cell.textLabel?.text = "\(vm.values[indexPath.row - vm.results.count])"
        }
        
        cell.textLabel?.textColor = textColor
        
        return cell
    }

}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
