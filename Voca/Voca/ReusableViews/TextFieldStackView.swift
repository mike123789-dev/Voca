//
//  TextFieldStackView.swift
//  Voca
//
//  Created by 강병민 on 2021/01/23.
//

import UIKit
import Combine

class TextFieldStackView: UIStackView {
    let titleLabel = UILabel()
    let textField = UITextField()
    let hintLabel = UILabel()
    var didTextFieldChange: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        titleLabel.textAlignment = .left
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        hintLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        hintLabel.textAlignment = .left
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(textField)
        addArrangedSubview(hintLabel)
        
        axis = NSLayoutConstraint.Axis.vertical
        distribution = UIStackView.Distribution.equalSpacing
        alignment = UIStackView.Alignment.fill
        spacing = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(title: String, textfieldString: String?) {
        titleLabel.text = title
        textField.text = textfieldString
    }
     
    @objc func textFieldDidChange(_ textField: UITextField) {
        didTextFieldChange?(textField.text ?? "")
    }

}
