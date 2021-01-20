//
//  VocaCollectionViewCell.swift
//  Voca
//
//  Created by 강병민 on 2021/01/20.
//

import Foundation
import UIKit

class VocaCollectionViewCell: UICollectionViewListCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            UIView.transition(with: answerLabel,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                guard let self = self else { return }
                                if self.isSelected {
                                    self.contentView.backgroundColor = UIColor(named: "Accent")
                                    self.answerLabel.isHidden = false
                                } else {
                                    self.contentView.backgroundColor = .none
                                    self.answerLabel.isHidden = true
                                }
                              })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with voca: Voca) {
        questionLabel.text = voca.question
        answerLabel.text = voca.answer
        accessories = [.reorder(displayed: .whenEditing, options: .init())]
    }
    
}
