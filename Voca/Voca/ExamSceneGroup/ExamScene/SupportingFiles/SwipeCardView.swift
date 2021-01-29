//
//  SwipeCardView.swift
//  Voca
//
//  Created by 강병민 on 2021/01/29.
//

import UIKit

class SwipeCardView: CardView {
    var questionLabel = UILabel()
    var answerLabel = UILabel()
    var favoriteButton = UIButton()
    weak var delegate: SwipeCardsDelegate?
    var divisor: CGFloat = 0
    var dataSource: AddVocaModel? {
        didSet {
            questionLabel.text = "\(dataSource?.question ?? "")"
            answerLabel.text = "\(dataSource?.answer ?? "")"
        }
    }
    var isAnswerHidden = true {
        didSet {
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionCrossDissolve) { [weak self] in
                guard let self = self else { return }
                self.answerLabel.isHidden = self.isAnswerHidden
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupCard()
        setupGesture()
        setupQuestionLabel()
        setupAnswerLabel()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupCard() {
        super.cornnerRadius = 10
        super.shadowOpacity = 1.0
        super.shadowOfSetWidth = .zero
        super.shadowOfSetHeight = 3
    }
    
    private func setupQuestionLabel() {
        addSubview(questionLabel)
        questionLabel.backgroundColor = .white
        questionLabel.textColor = .black
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont.systemFont(ofSize: 30)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        questionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupAnswerLabel() {
        addSubview(answerLabel)
        answerLabel.isHidden = isAnswerHidden
        answerLabel.backgroundColor = .white
        answerLabel.textColor = .black
        answerLabel.textAlignment = .center
        answerLabel.font = UIFont.systemFont(ofSize: 18)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    private func setupButton() {
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        favoriteButton.tintColor = .systemYellow
        favoriteButton.frame.size = CGSize(width: 44, height: 44)
        favoriteButton.sizeToFit()
        addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(
          target: self,
          action: #selector(handleTap)
        )
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        isAnswerHidden.toggle()
    }
    
}
