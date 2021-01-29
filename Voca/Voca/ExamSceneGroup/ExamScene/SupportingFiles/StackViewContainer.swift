//
//  StackViewContainer.swift
//  Voca
//
//  Created by 강병민 on 2021/01/29.
//

import UIKit

class StackViewContainer: UIView {
    
    var numberOfCardsToShow: Int = 0
    var cardsToBeVisible: Int = 3
    var cardViews: [SwipeCardView] = []
    var remainingcards: Int = 0
    
    let horizontalInset: CGFloat = 10.0
    let verticalInset: CGFloat = 10.0

    var dataSource: SwipeCardsDataSource? {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func reloadData() {
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingcards = numberOfCardsToShow
        
        //스택에 뷰를 추가하는것 (최대 3개의 카드를 보여줄것이다)
        for i in 0..<min(numberOfCardsToShow, cardsToBeVisible) {
            addCardView(cardView: datasource.card(at: i), atIndex: i)
        }
        
    }
    
    private func addCardView(cardView: SwipeCardView, atIndex index: Int) {
        cardView.delegate = self
        setCardFrame(cardView: cardView, at: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingcards -= 1
    }
    
    //화면에 보여줄 카드 뷰의 frame을 정해주자
    private func setCardFrame(cardView: SwipeCardView, at index: Int) {
        var cardViewFrame = bounds
        let horizontalInset = CGFloat(index) * self.horizontalInset
        let verticalInset = CGFloat(index) * self.verticalInset
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
}

extension StackViewContainer: SwipeCardsDelegate {
    func swipeDidEnd(on view: SwipeCardView) {
        print("did end!")
    }
}
