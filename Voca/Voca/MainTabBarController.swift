//
//  MainTabBarController.swift
//  Voca
//
//  Created by 강병민 on 2021/02/01.
//

import UIKit

class MainTabBarController: UITabBarController, Storyboarded {
    let voca = VocaListCoordinator()
    let exam = ExamListCoordinator()
    let coreDataStack = CoreDataStack(modelName: "Voca")
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        viewControllers = [voca.navigationController, exam.navigationController, ]
        setupBaritems()
        voca.start(with: coreDataStack)
        exam.start(with: coreDataStack)
    }
    
    private func setupBaritems() {
        voca.navigationController.tabBarItem =
            UITabBarItem(title: "단어",
                         image: UIImage(systemName: "folder"),
                         selectedImage: UIImage(systemName: "folder.fill"))
        exam.navigationController.tabBarItem =
            UITabBarItem(title: "시험",
                         image: UIImage(systemName: "rectangle.on.rectangle.angled"),
                         selectedImage: UIImage(systemName: "rectangle.fill.on.rectangle.angled.fill"))
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(String(describing: viewController.title))")
    }
    
}
