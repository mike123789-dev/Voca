//
//  TextFieldStackViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import Foundation
import Combine
import UIKit

class TextFieldStackViewController: UIViewController {
    
    let stackView = TextFieldStackView()
    @Published var textFieldString = ""
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        textfieldSubscription()
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        stackView.didTextFieldChange = { [weak self] text in
            self?.textFieldString = text
        }
        stackView.configure(title: "폴더명", textfieldString: "")
    }
    
    func textfieldSubscription() {
        $textFieldString
            .sink { [weak self] string in
                if string.isEmpty {
                    self?.stackView.hintLabel.text = "입력해주세요!"
                } else {
                    self?.stackView.hintLabel.text = " "
                }
            }
            .store(in: &subscriptions)
    }

}
