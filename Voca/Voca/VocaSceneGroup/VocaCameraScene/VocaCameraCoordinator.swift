//
//  VocaCameraCoordinator.swift
//  Voca
//
//  Created by 강병민 on 2021/02/01.
//

import UIKit

class VocaCameraCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: VocaAddCoordinator?
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.delegate = self
        let vc = VocaCameraViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
    }
}
