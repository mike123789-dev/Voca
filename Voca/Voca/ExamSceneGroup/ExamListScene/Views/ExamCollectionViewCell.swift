//
//  ExamCollectionViewCell.swift
//  Voca
//
//  Created by 강병민 on 2021/01/31.
//

import UIKit

class ExamCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var folderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var vocaCountLabel: UILabel!
    @IBOutlet weak var favoriteVocaCountLabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    @IBOutlet weak var RecentScoreLabel: UILabel!
    
    func configure(with folder: VocaSectionModel) {
        folderLabel.text = folder.title
//        dateLabel.text = folder.date.description
        vocaCountLabel.text = "총 \(folder.vocas.count) 단어"
        favoriteVocaCountLabel.text = "😃"
        averageScoreLabel.text = "70 %"
        RecentScoreLabel.text = "80 %"
    }
    
}
