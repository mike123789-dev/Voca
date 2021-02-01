//
//  VocaCameraViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/31.
//

import UIKit
import AVFoundation

class VocaCameraViewController: UIViewController, Storyboarded {
    @IBOutlet weak var capturePreview: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var coordinator: VocaCameraCoordinator?
    let cameraController = CameraController()

    override func viewDidLoad() {
        configureCameraController()
    }
    
    override var prefersStatusBarHidden: Bool { return true }

    private func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            try? self.cameraController.displayPreview(on: self.capturePreview)
        }
    }
        
}
