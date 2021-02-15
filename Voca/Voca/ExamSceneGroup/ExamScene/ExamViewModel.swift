//
//  ExamViewModel.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import Foundation
import Combine

protocol ExamDelegate: class {
    func save()
}

class ExamViewModel {
    var vocas: [Voca] = []
    @Published var currentIndex = 0
    @Published var progressPercent: Float = 0
    @Published var leftCount = 0
    @Published var rightCount = 0
    
    let didSwipePublisher = PassthroughSubject<Void, Never>()
    weak var delegate: ExamDelegate?
    
    func configureInitialState() {
        currentIndex = 0
        leftCount = 0
        rightCount = 0
        progressPercent = 1 / Float(vocas.count)
    }
    
    func swipe(_ voca: Voca, at direction: SwipeCardDirection) {
        let updatedIndex = currentIndex + 1
        currentIndex = min(updatedIndex, vocas.count - 1)
        progressPercent = Float(currentIndex + 1) / Float(vocas.count)
        didSwipePublisher.send()
        
        switch direction {
        case .left:
            leftCount += 1
        case .right:
            rightCount += 1
        default:
            break
        }
    }
    
    func toggleFavorite(_ voca: Voca, to isFavorite: Bool) {
        voca.isFavorite.toggle()
        delegate?.save()
    }

}

extension ExamViewModel: SwipeStackDelegate {
    func didReset() {
        configureInitialState()
    }
}
