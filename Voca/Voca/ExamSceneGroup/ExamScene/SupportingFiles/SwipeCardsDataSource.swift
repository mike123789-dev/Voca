//
//  SwipeCardsDataSource.swift
//  Voca
//
//  Created by 강병민 on 2021/01/29.
//

import UIKit

enum SwipeCardDirection {
    case left, right, unknown
}

protocol SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeCardView
    func emptyView() -> UIView?
}

protocol SwipeCardsDelegate: class {
    func swipeWillEnd(direction: SwipeCardDirection)
    func swipeDidEnd(on view: SwipeCardView, direction: SwipeCardDirection)
    func didPressFavoriteButton()
}

protocol SwipeStackDelegate: class {
    func willSwipeCard(to direction: SwipeCardDirection)
    func didSwipeCard(at index: Int, direction: SwipeCardDirection)
    func didPressFavoriteButton(index: Int)
    func didReset()
}
