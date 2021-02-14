//
//  BackgroundDecorationView.swift
//  Voca
//
//  Created by 강병민 on 2021/02/14.
//

import UIKit

class BackgroundDecorationView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
