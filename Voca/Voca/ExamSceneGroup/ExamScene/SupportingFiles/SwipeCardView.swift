//
//  SwipeCardView.swift
//  Voca
//
//  Created by 강병민 on 2021/01/29.
//

import UIKit
import Combine

class SwipeCardView: CardView {
    var questionLabel = UILabel()
    var answerLabel = UILabel()
    var favoriteButton = UIButton()
    var infoView = SwipeCardInfoView()
    weak var delegate: SwipeCardsDelegate?
    var dataSource: Voca? {
        didSet {
            questionLabel.text = "\(dataSource?.question ?? "")"
            answerLabel.text = "\(dataSource?.answer ?? "")"
            if dataSource?.isFavorite ?? true {
                favoriteButton.isSelected = true
            } else {
                favoriteButton.isSelected = false
            }
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
    var divisor: CGFloat = 0
    let swipeThreshold: CGFloat = 100
    
    let willSwipePublisher = PassthroughSubject<SwipeCardDirection, Never>()
    let didSwipePublisher = PassthroughSubject<(SwipeCardDirection, Voca), Never>()
    let didPressFavoritePublisher = PassthroughSubject<(Bool, Voca), Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupCard()
        setupGesture()
        setupInfoView()
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
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        favoriteButton.tintColor = .systemYellow
        favoriteButton.sizeToFit()
        favoriteButton.addTarget(self,
                                 action: #selector(didTapFavoriteButton),
                                 for: .touchUpInside)
        addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.centerYAnchor.constraint(equalTo: infoView.centerYAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -10).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupInfoView() {
        addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        infoView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                    action: #selector(handlePanGesture)))
    }
    
    @objc func didTapFavoriteButton() {
        guard let voca = dataSource else { return }
        favoriteButton.isSelected.toggle()
        didPressFavoritePublisher.send((favoriteButton.isSelected, voca))
    }
    
    @objc func handleTap() {
        isAnswerHidden.toggle()
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? SwipeCardView,
              let voca = dataSource else { return }
        let translation = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2,
                                              y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + translation.x,
                              y: centerOfParentContainer.y + translation.y)
        
        switch sender.state {
        case .ended:
            if translation.x > swipeThreshold {
                delegate?.didSwipe(on: card)
                didSwipePublisher.send((.right, voca))
                UIView.animate(withDuration: 1,
                               animations: {
                                card.center = CGPoint(x: card.center.x + 200,
                                                      y: card.center.y + 75)
                                card.alpha = 0
                                self.layoutIfNeeded()
                               },
                               completion: nil)
                return
            } else if translation.x < -swipeThreshold {
                delegate?.didSwipe(on: card)
                didSwipePublisher.send((.left, voca))
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
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.infoView.reset()
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(translation.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            configureInfoView(difference: translation.x)
            if translation.x > swipeThreshold {
                willSwipePublisher.send(.right)
            } else if translation.x < -swipeThreshold {
                willSwipePublisher.send(.left)
            } else {
                willSwipePublisher.send(.unknown)
            }
        default:
            break
        }
    }
    
    func configureInfoView(difference: CGFloat) {
        let diff = min(abs(difference), swipeThreshold)
        let diffPercentage = diff / swipeThreshold
        if difference > 0 {
            infoView.configure(isOkay: true, percentage: diffPercentage)
        } else if difference < 0 {
            infoView.configure(isOkay: false, percentage: diffPercentage)
        } else {
            infoView.reset()
        }
    }
    
}
