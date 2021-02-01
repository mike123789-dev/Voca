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

    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        viewControllers = [voca.navigationController, exam.navigationController]
        voca.navigationController.tabBarItem.title = "first"
        exam.navigationController.tabBarItem.title = "second"
        voca.start()
        exam.start()
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(String(describing: viewController.title))")
    }
    
}
