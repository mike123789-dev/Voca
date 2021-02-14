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
    
    func showAdd(with folders: [String], viewModel: VocaListViewModel) {
        let vocaAddCoordinator = VocaAddCoordinator(navigationController: navigationController)
        vocaAddCoordinator.parentCoordinator = self

        let vc = VocaAddViewController.instantiate()
        vc.coordinator = vocaAddCoordinator
        vc.viewModel.folders = folders
        vc.viewModel.delegate = viewModel
        
        navigationController.pushViewController(vc, animated: true)
        childCoordinators.append(vocaAddCoordinator)
    }
    
    func showAddFolderAlert(viewModel: VocaListViewModel) {
        let alert = UIAlertController(title: "도전!", message: nil, preferredStyle: .alert)
        alert.addOneTextField { folderName in
            viewModel.addFolder(title: folderName)
        }
        navigationController.present(alert, animated: true)
    }
    
    func showModifyVocaAlert(voca: Voca, viewModel: VocaListViewModel, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "추가", message: nil, preferredStyle: .alert)
        alert.addTwoTextField(firstText: voca.question, secondText: voca.answer) { (q, a) in
            viewModel.update(voca, question: q, answer: a, at: indexPath)
        }
        navigationController.present(alert, animated: true)
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
        if let detailVC = fromViewController as? VocaAddViewController {
            childDidFinish(detailVC.coordinator)
        }
    }
}
