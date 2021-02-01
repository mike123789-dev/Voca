//
//  CustomAlertViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/22.
//

import UIKit
import Combine

class CustomAlertViewController: UIAlertController {
    
    enum CustomAlertType {
        case addVoca, addFolder
    }
    @Published var isValid: Bool = false
    var subscriptions = Set<AnyCancellable>()
    var textHandler: ((String) -> Void)?
    var cancelAction: UIAlertAction!
    var okAction: UIAlertAction!
    
    convenience init(type: CustomAlertType) {
        switch type {
        case .addFolder:
            self.init(title: "폴더 추가",
                      message: nil,
                      preferredStyle: .alert)
        case .addVoca:
            self.init(title: "단어 추가",
                      message: nil,
                      preferredStyle: .alert)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
    }
    
    private func setupView() {
        
        let contentVC = TextFieldStackViewController()
        contentVC.stackView.textField.text = "hello"
        setValue(contentVC, forKey: "contentViewController")
        contentVC.$textFieldString
            .sink {[weak self ] text in
                if text.isEmpty {
                    self?.isValid = false
                } else {
                    self?.isValid = true
                }
            }
            .store(in: &subscriptions)
        
        cancelAction = UIAlertAction(title: "취소", style: .cancel)
        okAction = UIAlertAction(title: "추가",
                                 style: .default,
                                 handler: { [weak self] _ in
                                    self?.textHandler?(contentVC.textFieldString)
                                 })
        addAction(cancelAction)
        addAction(okAction)
        
    }
    
    private func setupBinding() {
        $isValid
            .sink { [weak self] isValid in
                self?.okAction.isEnabled = isValid
            }
            .store(in: &subscriptions)
    }
    
}
