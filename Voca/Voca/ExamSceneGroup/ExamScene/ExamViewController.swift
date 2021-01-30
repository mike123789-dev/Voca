//
//  ExamViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import UIKit
import Combine

class ExamViewController: UIViewController {
    
    @IBOutlet weak var leftCountLabel: UILabel!
    @IBOutlet weak var rightCountLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stackViewContainer: StackViewContainer!
    
    let viewModel = ExamViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewContainer.dataSource = self
        setupBinding()
    }
    
    private func setupBinding() {
        viewModel.$leftCount
            .map { "\($0)" }
            .assign(to: \.text, on: leftCountLabel)
            .store(in: &subscriptions)
        viewModel.$rightCount
            .map { "\($0)" }
            .assign(to: \.text, on: rightCountLabel)
            .store(in: &subscriptions)
        viewModel.$progressPercent
            .assign(to: \.progress, on: progressView)
            .store(in: &subscriptions)
        viewModel.$currendIndex
            .map { [weak self] in
                "\($0 + 1 )  / \(self?.viewModel.vocas.count ?? 1)" }
            .assign(to: \.text, on: progressLabel)
            .store(in: &subscriptions)
    }
    
    @IBAction func didTapResetButton(_ sender: Any) {
        stackViewContainer.reloadData()
    }

}

extension ExamViewController: SwipeCardsDataSource {
    
    func numberOfCardsToShow() -> Int {
        return viewModel.vocas.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModel.vocas[index]
        return card
    }
    
    func emptyView() -> UIView? {
//        let width = view.frame.size.width - 30
//        let height = view.frame.size.height - 30
//        return ResultView(frame: CGRect(origin: .zero,
//                                        size: CGSize(width: width, height: height)))
        nil
    }
    
}
