//
//  ScanConfigurationViewController.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 15.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit
import AVFoundation

class ScanConfigurationViewController: UIViewController {
    
    var doneButton: UIBarButtonItem?
    var scanConfigurationView: ScanConfigurationView?
    let appConfigurationManager: AppConfigurationManager
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    init(withAppConfigurationManager: AppConfigurationManager) {
        self.appConfigurationManager = withAppConfigurationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let scanConfigurationView = ScanConfigurationView(frame: .zero)
        self.scanConfigurationView = scanConfigurationView
        
        self.view.addSubview(scanConfigurationView)

        // there must be a better way to define the navigationItems than doing this in the viewDidLoad/loadView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ScanConfigurationViewController.doneButtonTapped(_:)))
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupQRCodeReder()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let scanConfigurationView = self.scanConfigurationView else {
            assertionFailure("Check scanConfigurationView")
            return
        }
        
        let topContentConstraint = scanConfigurationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let bottomContentConstraint = scanConfigurationView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        let leadingContentConstraint = scanConfigurationView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        let trailingContentConstraint = scanConfigurationView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        
        NSLayoutConstraint.activate([topContentConstraint, bottomContentConstraint, leadingContentConstraint, trailingContentConstraint])
    }
    
    // MARK: - Actions
    
    @objc func doneButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupQRCodeReder() {

        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            assertionFailure("Check CaptureDevice")
            return
        }
        
        guard let scanConfigurationView = self.scanConfigurationView else {
            assertionFailure("Check scanConfigurationView")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            let output = AVCaptureMetadataOutput()
            
            let captureSession = AVCaptureSession()
            captureSession.addInput(input)
            captureSession.addOutput(output)
            
            let dispatchQueue = DispatchQueue(label: "Capture Queue")
            output.setMetadataObjectsDelegate(self, queue: dispatchQueue)
            output.metadataObjectTypes = [.qr]
            
            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.frame = scanConfigurationView.cameraView.frame
            scanConfigurationView.cameraView.layer.addSublayer(videoPreviewLayer)

            self.videoPreviewLayer = videoPreviewLayer
            self.captureSession = captureSession
            
            self.captureSession?.startRunning()
            
        } catch let error {
            assertionFailure("Error setting up QR-Reader: \(error.localizedDescription)")
            return
        }
    }
    
}

extension ScanConfigurationViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard metadataObjects.count > 0 else {
            return
        }
        
        guard let metaDataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        if metaDataObject.type == .qr, let stringValue = metaDataObject.stringValue, let dataValue = stringValue.data(using: .utf8) {
            do {
                let decodedAppConfiguration = try JSONDecoder().decode(AppConfiguration.self, from: dataValue)
                self.appConfigurationManager.deleteCurrentAppConfiguration()
                self.appConfigurationManager.newAppConfigurationAvailable(decodedAppConfiguration)
                OperationQueue.main.addOperation {
                    self.scanConfigurationView?.appConfiguredSuccessfully()
                    self.captureSession?.stopRunning()
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ScanConfigurationViewController.doneButtonTapped(_:)))
                }
            } catch let error {
                print(error)
                assertionFailure("Scanning failed")
                return
            }
        }
    }
}
