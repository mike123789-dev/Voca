//
//  TextFieldStackViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import Foundation
import Combine
import UIKit

class OneTextFieldViewController: UIViewController {
    
    let stackView = TextFieldStackView()
    var textFieldString = ""
    var isValidated: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        stackView.didTextFieldChange = { [weak self] text in
            guard let self = self else { return }
            self.textFieldString = text
            self.isValidated?(!text.isEmpty)
        }
        stackView.configure(title: "폴더명", textfieldString: "")
    }

}
