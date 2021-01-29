//
//  ResultView.swift
//  Voca
//
//  Created by 강병민 on 2021/01/29.
//

import UIKit

class ResultView: UIView {
    
    @IBOutlet var contentView: UIView!
    var didTapRestartButton: (() -> Void)?
    var didTapFinishButton: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitializer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitializer()
    }
    
    private func commonInitializer() {
        Bundle.main.loadNibNamed("ResultView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func didTapRestartButton(_ sender: Any) {
        didTapRestartButton?()
    }
    
    @IBAction func didTapFinishButton(_ sender: Any) {
        didTapFinishButton?()
    }
    
}
