//
//  UIAlertController+Extensions.swift
//  Voca
//
//  Created by 강병민 on 2021/02/14.
//

import UIKit

extension UIAlertController {
    func addOneTextField(handler: ((String) -> Void)?) {
        let contentVC = OneTextFieldViewController()
        setValue(contentVC, forKey: "contentViewController")
        contentVC.isValidated = { [weak self] isValidate in
            self?.actions.last?.isEnabled = isValidate
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "추가",
                                 style: .default,
                                 handler: { _ in
                                    handler?(contentVC.textFieldString)
                                 })
        //alert가 처음 표시될때는 textfield가 비어있으므로 isEnabled = false로 초기화한다.
        okAction.isEnabled = false
        addAction(cancelAction)
        addAction(okAction)
    }
    
    func addTwoTextField(firstText: String, secondText: String, handler: ((String, String) -> Void)?) {
       let contentVC = TwoTextFieldViewController()
        contentVC.firstTextFieldString = firstText
        contentVC.secondTextFieldString = secondText
        contentVC.isValidated = { [weak self] isValidate in
            self?.actions.last?.isEnabled = isValidate
        }
        
        setValue(contentVC, forKey: "contentViewController")
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "수정",
                                 style: .default,
                                 handler: { _ in
                                    handler?(contentVC.firstTextFieldString,
                                             contentVC.secondTextFieldString)
                                 })
        addAction(cancelAction)
        addAction(okAction)
    }

}
