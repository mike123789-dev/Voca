//
//  VocaAddTableViewCell.swift
//  Voca
//
//  Created by 강병민 on 2021/01/27.
//

import UIKit
import Combine

class VocaAddTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var indicatorView: UIView!
    let questionStackView = TextFieldStackView()
    let answerStackView = TextFieldStackView()
    var subscriptions = Set<AnyCancellable>()
    let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                          y: 0.0,
                                          width: UIScreen.main.bounds.size.width,
                                          height: 44.0))

    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.spacing = 10
        stackView.addArrangedSubview(questionStackView)
        stackView.addArrangedSubview(answerStackView)
        setupToolbar()
    }
    
    override func prepareForReuse() {
        subscriptions.forEach { $0.cancel() }
    }
    
    private func setupToolbar() {
        let upButton = UIBarButtonItem(image: UIImage(systemName: "chevron.up"),
                                         style: .plain,
                                         target: questionStackView.textField,
                                         action: #selector(UITextField.becomeFirstResponder))
        upButton.width = 50

        let downButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"),
                                           style: .plain,
                                           target: answerStackView.textField,
                                           action: #selector(UITextField.becomeFirstResponder))
        downButton.width = 50

        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let keyboardButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapDoneButton))
        toolBar.items = [upButton, downButton, flexible, keyboardButton]
        questionStackView.textField.inputAccessoryView = toolBar
        answerStackView.textField.inputAccessoryView = toolBar
    }
    
    @objc func didTapUpButton(sender: Any) {
        
    }
    @objc func didTapDownButton(sender: Any) {
        
    }
    @objc func didTapDoneButton(sender: Any) {
        endEditing(true)
    }

    func configure(with viewModel: VocaAddCellViewModel) {
        questionStackView.configure(title: viewModel.questionTitle,
                                    textfieldString: viewModel.questionText)
        questionStackView.didTextFieldChange = { text in
            viewModel.questionText = text
        }
        answerStackView.configure(title: viewModel.answerTitle,
                                  textfieldString: viewModel.answerText)
        answerStackView.didTextFieldChange = { text in
            viewModel.answerText = text
        }
        
        viewModel.$isValid
            .sink { [weak self] isValid in
                guard let self = self else { return }
                if isValid {
                    self.indicatorView.backgroundColor = .systemGreen
                } else {
                    self.indicatorView.backgroundColor = .systemRed
                }
            }
            .store(in: &subscriptions)
    }
    
}
