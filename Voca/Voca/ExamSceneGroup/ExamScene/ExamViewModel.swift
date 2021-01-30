//
//  ExamViewModel.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import Foundation

class ExamViewModel {
    var vocas: [AddVocaModel] = TestData.section3.vocas
    @Published var currendIndex = 0
    @Published var progressPercent: Float = 0
    @Published var leftCount = 0
    @Published var rightCount = 0
}
