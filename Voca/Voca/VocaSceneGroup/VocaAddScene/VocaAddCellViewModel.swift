//
//  VocaAddCellViewModel.swift
//  Voca
//
//  Created by 강병민 on 2021/01/27.
//

import Foundation
import Combine

class VocaAddCellViewModel {
    let questionTitle = "단어"
    let answerTitle = "뜻"
    @Published var questionText = "" {
        didSet { validate() }
    }
    @Published var answerText = "" {
        didSet { validate() }
    }
    @Published var isValid = false
        
    private func validate() {
        if questionText.isEmpty || answerText.isEmpty {
            isValid = false
        } else {
            isValid = true
        }
    }
}
