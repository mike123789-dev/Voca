//
//  ExamViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import UIKit
import Combine

class ExamViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var leftCountLabel: UILabel!
    @IBOutlet weak var leftCountView: UIView!
    @IBOutlet var leftCountViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCountLabel: UILabel!
    @IBOutlet weak var rightCountView: UIView!
    @IBOutlet var rightCountViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stackViewContainer: StackViewContainer!
    
    weak var coordinator: ExamCoordinator?
    let viewModel = ExamViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configureInitialState()
        stackViewContainer.dataSource = self
        stackViewContainer.delegate = self.viewModel
        setupBinding()
        setupConstraints(isActive: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stackViewContainer.removeFromSuperview()
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
            .sink(receiveValue: { [weak self] value in
                UIView.animate(withDuration: 0.4) {
                    self?.progressView.setProgress(value, animated: true)
                }
            })
            .store(in: &subscriptions)
        viewModel.$currentIndex
            .map { [weak self] in
                "\($0 + 1 )  / \(self?.viewModel.vocas.count ?? 1)" }
            .assign(to: \.text, on: progressLabel)
            .store(in: &subscriptions)
        viewModel.willSwipePublisher
            .sink { [weak self] direction in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 3.0,
                               options: .curveEaseInOut,
                               animations: {
                                switch direction {
                                case .left:
                                    self.leftCountViewWidthConstraint.isActive = true
                                case .right:
                                    self.rightCountViewWidthConstraint.isActive = true
                                case .unknown:
                                    self.leftCountViewWidthConstraint.isActive = false
                                    self.rightCountViewWidthConstraint.isActive = false
                                }
                                self.view.layoutIfNeeded()
                                
                               },
                               completion: nil)
            }
            .store(in: &subscriptions)
    }
    
    private func setSize(_ view: UIView, to length: CGFloat) {
        view.heightAnchor.constraint(equalToConstant: length).isActive = true
        view.widthAnchor.constraint(equalToConstant: length).isActive = true
    }
    
    private func setupConstraints(isActive: Bool) {
        leftCountViewWidthConstraint.isActive = isActive
        rightCountViewWidthConstraint.isActive = isActive
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
