//
//  SwipeCardsDataSource.swift
//  Voca
//
//  Created by 강병민 on 2021/01/29.
//

import UIKit

protocol SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeCardView
    func emptyView() -> UIView?
}

protocol SwipeCardsDelegate: class {
    func swipeDidEnd(on view: SwipeCardView)
}
