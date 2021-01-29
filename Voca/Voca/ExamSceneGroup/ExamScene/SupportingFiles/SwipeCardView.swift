//
//  SwipeCardView.swift
//  Voca
//
//  Created by 강병민 on 2021/01/29.
//

import UIKit

class SwipeCardView: CardView {
    var label = UILabel()
    var moreButton = UIButton()
    weak var delegate: SwipeCardsDelegate?
    var divisor: CGFloat = 0
    
    var dataSource: AddVocaModel? {
        didSet {
            label.text = "\(dataSource?.question ?? "") : \(dataSource?.answer ?? "")"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupCard()
        setupLabelView()
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
    
    private func setupLabelView() {
        addSubview(label)
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupButton() {
        addSubview(moreButton)
        moreButton.titleLabel?.text = "더"
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        moreButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
