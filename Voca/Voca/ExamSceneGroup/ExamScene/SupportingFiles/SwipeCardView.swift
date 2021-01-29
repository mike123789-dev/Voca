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
        super.isEfficient = false
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
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        
    }
    
    @objc func handleTap() {
        isAnswerHidden.toggle()
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? SwipeCardView else { return }
        let translation = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2,
                                              y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + translation.x,
                              y: centerOfParentContainer.y + translation.y)
        
        switch sender.state {
        case .ended:
            if translation.x > 100 {
                delegate?.swipeDidEnd(on: card, direction: .right)
                UIView.animate(withDuration: 1,
                               animations: {
                                card.center = CGPoint(x: card.center.x + 200,
                                                      y: card.center.y + 75)
                                card.alpha = 0
                                self.layoutIfNeeded()
                               },
                               completion: nil)
                return
            } else if translation.x < -100 {
                delegate?.swipeDidEnd(on: card, direction: .left)
                UIView.animate(withDuration: 1,
                               animations: {
                                card.center = CGPoint(x: card.center.x - 200,
                                                      y: card.center.y + 75)
                                card.alpha = 0
                                self.layoutIfNeeded()
                               },
                               completion: nil)
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                print(CGPoint(x: self.frame.width / 2, y: self.frame.height / 2))
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(translation.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
        default:
            break
        }
    }
    
}
