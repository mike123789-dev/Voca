//
//  VocaAddCoordinator.swift
//  Voca
//
//  Created by 강병민 on 2021/02/01.
//

import UIKit

class VocaAddCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: VocaListCoordinator?
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() { }

//    func start(with folders: [String], viewModel: VocaListViewModel) {
//        navigationController.delegate = self
//        let vc = VocaAddViewController.instantiate()
//        vc.coordinator = self
//        vc.viewModel.folders = folders
//        vc.viewModel.delegate = viewModel
//        navigationController.pushViewController(vc, animated: true)
//    }
    
    func showCamera() {
        let vc = VocaCameraViewController.instantiate()
        navigationController.present(vc, animated: true) {
            print("bye")
        }
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
