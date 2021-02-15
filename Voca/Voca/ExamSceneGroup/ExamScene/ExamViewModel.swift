//
//  ExamViewModel.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import Foundation
import Combine

class ExamViewModel {
    var vocas: [Voca] = []
    @Published var currentIndex = 0
    @Published var progressPercent: Float = 0
    @Published var leftCount = 0
    @Published var rightCount = 0

    let willSwipePublisher = PassthroughSubject<SwipeCardDirection, Never>()
    
    func configureInitialState() {
        currentIndex = 0
        leftCount = 0
        rightCount = 0
        progressPercent = 1 / Float(vocas.count)
    }
    
}

extension ExamViewModel: SwipeStackDelegate {
    
    func willSwipeCard(to direction: SwipeCardDirection) {
        willSwipePublisher.send(direction)
    }
    
    func didSwipeCard(at index: Int, direction: SwipeCardDirection) {
        let updatedIndex = currentIndex + 1
        currentIndex = min(updatedIndex, vocas.count - 1)
        progressPercent = Float(currentIndex + 1) / Float(vocas.count)
        willSwipePublisher.send(.unknown)
        
        switch direction {
        case .left:
            leftCount += 1
        case .right:
            rightCount += 1
        default:
            break
        }
    }
    
    func didPressFavoriteButton(index: Int) {
        print("favorited : \(index)")
    }
    
    func didReset() {
        configureInitialState()
    }
    
}
