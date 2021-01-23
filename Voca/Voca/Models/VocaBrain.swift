//
//  VocaBrain.swift
//  LearnCombine
//
//  Created by 강병민 on 2021/01/20.
//

import Foundation

class VocaBrain {
    let voca: VocaModel
    let addedDate = Date()
    var isFavorite: Bool = false
    
    private var correctCount = 0
    private var wrongCount = 0
    
    var totalCount: Int {
        correctCount + wrongCount
    }
    var correctAnswerRate: Double {
        Double(correctCount)/Double(totalCount)
    }
    
    init(voca: VocaModel) {
        self.voca = voca
    }
    
    func answerWrong() {
        wrongCount += 1
    }
    func answerCorrect() {
        correctCount += 1
    }
    
}
