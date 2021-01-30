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
    var remainingcards: Int = 0
    
    var cardViews: [SwipeCardView] = []
    var visibleCards: [SwipeCardView] {
        return subviews as? [SwipeCardView] ?? []
    }
    
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
        resetCards()
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingcards = numberOfCardsToShow
        
        //스택에 뷰를 추가하기 (최대 3개의 카드를 보여줄것이다)
        for i in 0..<min(numberOfCardsToShow, cardsToBeVisible) {
            addCardView(cardView: datasource.card(at: i), atIndex: i)
        }
    }
    
    func resetCards() {
        cardViews = []
        for views in visibleCards {
            views.removeFromSuperview()
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
    
    private func addEmptyView() {
        if visibleCards.count == 0 {
            guard let datasource = dataSource,
                  let emptyView = datasource.emptyView(),
                  let superview = superview else { return }
            self.addSubview(emptyView)
            //TODO: emptyview 위치 조절해주기
            emptyView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.transition(with: self,
                                  duration: 0.5,
                                  options: [.transitionFlipFromBottom],
                                  animations: {
                                    emptyView.isHidden = false
                                  })
            }
            
        }
        
    }
}

extension StackViewContainer: SwipeCardsDelegate {
    func swipeDidEnd(on view: SwipeCardView, direction: SwipeCardDirection) {
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()
        
        if remainingcards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - remainingcards
            addCardView(cardView: datasource.card(at: newIndex), atIndex: 2)
        }
        for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
            UIView.animate(withDuration: 0.2,
                           animations: { [weak self] in
                            guard let self = self else { return }
                            cardView.center = self.center
                            self.setCardFrame(cardView: cardView, at: cardIndex)
                            self.layoutIfNeeded()
                           },
                           completion: nil)
        }
        addEmptyView()
    }
}
