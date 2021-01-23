//
//  TextFieldStackView.swift
//  Voca
//
//  Created by 강병민 on 2021/01/23.
//

import UIKit
import Combine

class TextFieldStackView: UIViewController {
    
    let titleLabel = UILabel()
    let textField = UITextField()
    let hintLabel = UILabel()
    let stackView = UIStackView()
    @Published var textFieldString = ""
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStackView()
        textfieldSubscription()
    }
    
    func setupViews() {
        titleLabel.text = "폴더명"
        titleLabel.textAlignment = .left
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        hintLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        hintLabel.textAlignment = .left
    }
    
    func setupStackView() {
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 10
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(hintLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
    
    func textfieldSubscription() {
        $textFieldString
            .sink { [weak self] string in
                if string.isEmpty {
                    self?.hintLabel.text = "입력해주세요!"
                } else {
                    self?.hintLabel.text = " "
                }
            }
            .store(in: &subscriptions)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textFieldString = textField.text ?? ""
    }
    
}
