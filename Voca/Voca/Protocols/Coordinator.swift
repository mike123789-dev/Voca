//
//  Coordinator.swift
//  Voca
//
//  Created by 강병민 on 2021/02/01.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
