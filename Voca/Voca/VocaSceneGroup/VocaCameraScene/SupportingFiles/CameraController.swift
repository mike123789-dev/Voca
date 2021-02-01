//
//  CameraController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/31.
//

import Foundation
import AVFoundation
import UIKit

class CameraController: NSObject {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    var captureSession: AVCaptureSession?
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var videoOutput: AVCaptureVideoDataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        
        DispatchQueue(label: "prepare").async { [weak self] in
            guard let self = self else { return }
            do {
                self.createCaptureSession()
                try self.configureCaptureDevices()
                try self.configureDeviceInputs()
                try self.configureOutput()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    private func createCaptureSession() {
        self.captureSession = AVCaptureSession()
    }
    
    private func configureCaptureDevices() throws {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                       mediaType: AVMediaType.video,
                                                       position: .unspecified)
        let cameras = session.devices
        guard !cameras.isEmpty else { throw
            CameraControllerError.noCamerasAvailable
        }
        for camera in cameras where camera.position == .back {
            self.rearCamera = camera
            try camera.lockForConfiguration()
            camera.focusMode = .continuousAutoFocus
            camera.unlockForConfiguration()
        }
        
    }
    
    private func configureDeviceInputs() throws {
        guard let captureSession = self.captureSession else { throw
            CameraControllerError.captureSessionIsMissing
        }
        if let rearCamera = self.rearCamera {
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            if captureSession.canAddInput(self.rearCameraInput!) {
                captureSession.addInput(self.rearCameraInput!)
            }
        } else {
            throw CameraControllerError.noCamerasAvailable
        }
    }
    
    private func configureOutput() throws {
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput?.isHighResolutionCaptureEnabled = true
        photoOutput!.setPreparedPhotoSettingsArray(
            [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])],
            completionHandler: nil)
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        guard let photoOutput = self.photoOutput else { return }
        guard let videoOutput = self.videoOutput else { return }
        
        captureSession.addOutput(photoOutput)
        captureSession.addOutput(videoOutput)
        captureSession.startRunning()
    }

    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession,
              captureSession.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
}

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
}
