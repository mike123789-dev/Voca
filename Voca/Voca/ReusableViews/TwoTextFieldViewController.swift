//
//  SecondTextFieldViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/02/14.
//

import Foundation
import Combine
import UIKit

class TwoTextFieldViewController: UIViewController {
    
    let firstStackView = TextFieldStackView()
    let secondStackView = TextFieldStackView()
    var firstTextFieldString = ""
    var secondTextFieldString = ""
    var isValidated: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
    }
    
    func setupStackView() {
        view.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        view.addSubview(stackView)

        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        stackView.addArrangedSubview(firstStackView)
        firstStackView.didTextFieldChange = { [weak self] text in
            guard let self = self else { return }
            self.firstTextFieldString = text
            self.isValidated?(self.isValidate())
        }
        firstStackView.configure(title: "단어",
                                 textfieldString: firstTextFieldString)

        stackView.addArrangedSubview(secondStackView)
        secondStackView.didTextFieldChange = { [weak self] text in
            guard let self = self else { return }
            self.secondTextFieldString = text
            self.isValidated?(self.isValidate())
        }
        secondStackView.configure(title: "뜻",
                                  textfieldString: secondTextFieldString)

    }

    private func isValidate() -> Bool {
        if firstTextFieldString.isEmpty || secondTextFieldString.isEmpty {
            return false
        } else {
            return true
        }
    }
    
}
