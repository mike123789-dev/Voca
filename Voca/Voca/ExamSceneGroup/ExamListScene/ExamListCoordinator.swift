//
//  ExamListCoordinator.swift
//  Voca
//
//  Created by 강병민 on 2021/02/01.
//

import UIKit

class ExamListCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
//        navigationController.delegate = self
//        let vc = ExamListViewController.instantiate()
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: false)
    }
    
    func start(with coreDataStack: CoreDataStack) {
        navigationController.delegate = self
        let viewmodel = ExamListViewModel(coreDataStack: coreDataStack)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: "ExamListViewController", creator: { coder in
            return ExamListViewController(coder: coder, viewModel: viewmodel)
        })
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showExam(with folder: VocaSectionModel) {
        let examCoordinator = ExamCoordinator(navigationController: navigationController)
        examCoordinator.parentCoordinator = self
        
        let vc = ExamViewController.instantiate()
        vc.coordinator = examCoordinator
        vc.viewModel.vocas = folder.vocas
        vc.navigationItem.title = folder.title
        
        navigationController.pushViewController(vc, animated: true)
        childCoordinators.append(examCoordinator)
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
