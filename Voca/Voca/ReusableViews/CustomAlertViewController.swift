//
//  CustomAlertViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/22.
//

import UIKit
import Combine

extension UIAlertController {
    
    class func create(title: String?, preferredStyle: UIAlertController.Style) -> UIAlertController {
        return UIAlertController(title: title, message: nil, preferredStyle: preferredStyle)
    }
    
}

class VocaAlertController {
    enum CustomAlertType {
        case addVoca, addFolder, modifyVoca
    }
    
    private var alertController: UIAlertController!
    let alertType: CustomAlertType
    
    @Published var isValid: Bool = false
    var subscriptions = Set<AnyCancellable>()
    var firstTextHandler: ((String) -> Void)?
    var secondTextHandler: ((String) -> Void)?
    var cancelAction: UIAlertAction!
    var okAction: UIAlertAction!
    
    var firstText: String?
    var secondText: String?
    
    init(alertType: CustomAlertType) {
        self.alertType = alertType
        var title = ""
        switch alertType {
        case .addFolder:
            title = "폴더 추가"
        case .addVoca:
            title = "단어 추가"
        case .modifyVoca:
            title = "단어 수정"
        }
        alertController = UIAlertController.create(title: title, preferredStyle: .alert)
        setup()
    }
    
    private func setup() {
        switch alertType {
        case .addFolder:
            setupAddFolder()
        case .addVoca:
            setupAddVoca()
        case .modifyVoca:
            setupModifyVoca()
        }
        setupBinding()
    }
    
    private func setupAddFolder() {
//        let contentVC = OneTextFieldViewController()
//        alertController.setValue(contentVC, forKey: "contentViewController")
//        contentVC.$textFieldString
//            .sink {[weak self ] text in
//                print(text)
//                if text.isEmpty {
//                    self?.isValid = false
//                } else {
//                    self?.isValid = true
//                }
//            }
//            .store(in: &subscriptions)
//        print(contentVC.$textFieldString)
//        print(contentVC.subscriptions)
//        
//        cancelAction = UIAlertAction(title: "취소", style: .cancel)
//        okAction = UIAlertAction(title: "추가",
//                                 style: .default,
//                                 handler: { [weak self] _ in
//                                    self?.firstTextHandler?(contentVC.textFieldString)
//                                 })
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
    }
    
    private func setupAddVoca() {
        
    }
    
    private func setupModifyVoca() {
//        let contentVC = TwoTextFieldViewController()
//        contentVC.secondTextFieldString = "되고있나?"
//        alertController.setValue(contentVC, forKey: "contentViewController")
//        Publishers.CombineLatest(contentVC.$firstTextFieldString, contentVC.$secondTextFieldString)
//            .sink { [weak self] (first, second) in
//                print(first)
//                print(second)
//
//                if first.isEmpty || second.isEmpty {
//                    self?.isValid = false
//                } else {
//                    self?.isValid = true
//                }
//            }
//            .store(in: &subscriptions)
//        
//        cancelAction = UIAlertAction(title: "취소", style: .cancel)
//        okAction = UIAlertAction(
//            title: "추가",
//            style: .default,
//            handler: { [weak self] _ in
//                self?.firstTextHandler?(contentVC.firstTextFieldString)
//                self?.secondTextHandler?(contentVC.secondTextFieldString)
//            })
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
    }
    
    private func setupBinding() {
        $isValid
            .sink { [weak self] isValid in
                self?.okAction.isEnabled = isValid
            }
            .store(in: &subscriptions)
    }

    func present(inViewController controller: UIViewController) {
        controller.present(alertController, animated: true)
    }
    
}
