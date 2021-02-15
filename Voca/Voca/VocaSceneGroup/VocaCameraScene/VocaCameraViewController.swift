//
//  VocaCameraViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/31.
//

import UIKit
import AVFoundation
import Vision

class VocaCameraViewController: UIViewController, Storyboarded {
    @IBOutlet weak var preview: UIView!
    override var prefersStatusBarHidden: Bool { return true }

    weak var coordinator: VocaCameraCoordinator?
    let cameraController = CameraController()

    override func viewDidLoad() {
        configureCameraController()
        configureVision()
    }
    
    @IBAction func didPressCameraButton(_ sender: Any) {
        print("추출하기!")
    }
    
    @IBAction func didPressTorchButton(_ sender: Any) {
        print("빛이 있으라")
    }

    private func configureCameraController() {
        cameraController.prepare {[weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            try? self.cameraController.displayPreview(on: self.preview)
        }
    }
    
    private func configureVision() {
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.textDetectionHandler)
        textRequest.reportCharacterBoxes = true
        
        cameraController.requests = [textRequest]
    }
    
    private func textDetectionHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results else {
            print("no result")
            return
        }
        
        let result = observations.map({$0 as? VNTextObservation})
        
        DispatchQueue.main.async {
            self.preview.layer.sublayers?.removeSubrange(1...)
            for region in result {
                guard let rg = region else {continue}
                self.drawRegionBox(box: rg)
            }
        }
    }
    
    private func drawRegionBox(box: VNTextObservation) {
        guard let boxes = box.characterBoxes else {return}
        var xMin: CGFloat = 9999.0
        var xMax: CGFloat = 0.0
        var yMin: CGFloat = 9999.0
        var yMax: CGFloat = 0.0
        
        for char in boxes {
            if char.bottomLeft.x < xMin {xMin = char.bottomLeft.x}
            if char.bottomRight.x > xMax {xMax = char.bottomRight.x}
            if char.bottomRight.y < yMin {yMin = char.bottomRight.y}
            if char.topRight.y > yMax {yMax = char.topRight.y}
        }
        
        let xCoord = xMin * preview.frame.size.width
        let yCoord = (1 - yMax) * preview.frame.size.height
        let width = (xMax - xMin) * preview.frame.size.width
        let height = (yMax - yMin) * preview.frame.size.height
        
        let layer = CALayer()
        layer.frame = CGRect(x: xCoord, y: yCoord, width: width, height: height)
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.green.cgColor
        
        preview.layer.addSublayer(layer)
    }
        
}
