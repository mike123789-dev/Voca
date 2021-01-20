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
    
    func configure(with voca: Voca) {
        questionLabel.text = voca.question
        answerLabel.text = voca.answer
    }
    
}
