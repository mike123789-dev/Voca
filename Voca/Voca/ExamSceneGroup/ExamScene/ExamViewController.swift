//
//  ExamViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import UIKit

class ExamViewController: UIViewController {
    
    var vocas: [AddVocaModel] = TestData.section3.vocas
    var stackContainer: StackViewContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackContainter()
        stackContainer.dataSource = self
    }
    
    private func setupStackContainter() {
        stackContainer = StackViewContainer()
        view.addSubview(stackContainer)
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: 400).isActive = true
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

extension ExamViewController: SwipeCardsDataSource {
    
    func numberOfCardsToShow() -> Int {
        return vocas.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = vocas[index]
        return card
    }
    
    func emptyView() -> UIView? {
        let width = view.frame.size.width - 30
        let height = view.frame.size.height - 30
        return ResultView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: width, height: height)))
    }
    
}
