//
//  InfoView.swift
//  Voca
//
//  Created by 강병민 on 2021/01/30.
//

import UIKit

class InfoView: UIView {
    
    var infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        alpha = 0
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLabel() {
        addSubview(infoLabel)
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 20)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func configure(isOkay: Bool, percentage: CGFloat) {
        alpha = percentage
        if isOkay {
            infoLabel.text = "O"
            backgroundColor = .systemGreen
        } else {
            infoLabel.text = "X"
            backgroundColor = .systemRed
        }
    }
    
    func reset() {
        alpha = 0
        infoLabel.text = ""
        backgroundColor = .clear
    }
    
}
