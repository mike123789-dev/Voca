//
//  VocaListCoordinator.swift
//  Voca
//
//  Created by 강병민 on 2021/02/01.
//

import UIKit

class VocaListCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.delegate = self
        let vc = VocaListViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showAdd() {
        let vocaAddCoordinator = VocaAddCoordinator(navigationController: navigationController)
        childCoordinators.append(vocaAddCoordinator)
        vocaAddCoordinator.parentCoordinator = self
        vocaAddCoordinator.start()
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        //pop하고 있는중!
        if let detailVC = fromViewController as? ExamViewController {
            childDidFinish(detailVC.coordinator)
        }
    }
}
