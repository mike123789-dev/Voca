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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.spacing = 10
        stackView.addArrangedSubview(questionStackView)
        stackView.addArrangedSubview(answerStackView)
    }
    
    override func prepareForReuse() {
        subscriptions.forEach { $0.cancel() }
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
