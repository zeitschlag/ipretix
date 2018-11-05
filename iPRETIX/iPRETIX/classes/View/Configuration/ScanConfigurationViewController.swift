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
    var scanConfigurationView: ScanConfigurationView
    //TODO: Add a loading view with a loading-indicator
    
    let appConfigurationManager: PretixConfigurationManager
    let syncManager: NetworkManager
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    init(appConfigurationManager: PretixConfigurationManager, syncManager: NetworkManager) {
        
        self.appConfigurationManager = appConfigurationManager
        self.syncManager = syncManager
        
        self.scanConfigurationView = ScanConfigurationView(branding: Branding.shared)
        
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ScanConfigurationViewController.syncManagerTicketDownloadStarted(_:)), name: NetworkManager.Notifications.TicketDownloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScanConfigurationViewController.syncManagerTicketDownloadSucceeded(_:)), name: NetworkManager.Notifications.TicketDownloadSucceeded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScanConfigurationViewController.syncManagerTicketDownloadFailed(_:)), name: NetworkManager.Notifications.TicketDownloadFailed, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupQRCodeReader() {
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            assertionFailure("Check CaptureDevice")
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
            videoPreviewLayer.frame = self.scanConfigurationView.cameraView.frame
            scanConfigurationView.cameraView.layer.addSublayer(videoPreviewLayer)
            
            self.videoPreviewLayer = videoPreviewLayer
            self.captureSession = captureSession
            
            self.captureSession?.startRunning()
            
        } catch let error {
            assertionFailure("Error setting up QR-Reader: \(error.localizedDescription)")
            return
        }
    }
    
    //MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        
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
        
        setupQRCodeReader()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let topContentConstraint = self.scanConfigurationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let bottomContentConstraint = self.scanConfigurationView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        let leadingContentConstraint = self.scanConfigurationView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        let trailingContentConstraint = self.scanConfigurationView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        
        NSLayoutConstraint.activate([topContentConstraint, bottomContentConstraint, leadingContentConstraint, trailingContentConstraint])
    }
    
    // MARK: - Actions
    
    @objc func doneButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Notifications
    
    @objc func syncManagerTicketDownloadStarted(_ notification: Notification) {
        //TODO: Show loading indicator
    }
    
    @objc func syncManagerTicketDownloadSucceeded(_ notification: Notification) {
        //TODO: Hide Loading Indicator
        OperationQueue.main.addOperation {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func syncManagerTicketDownloadFailed(_ notification: Notification) {
        //TODO: Hide Loading Indicator
        
        guard let userInfo = notification.userInfo as? [String: String], let localizedErrorDescription = userInfo[NetworkManager.Notifications.UserInfo.ErrorDescriptionKey] else {
            preconditionFailure("Check User Info/No error message")
        }
        
        let alertTitle = NSLocalizedString("SYNC_MANAGER.ALERT.ERROR.TITLE", comment: "")
        let alertMessage = localizedErrorDescription
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        let okActionTitle = NSLocalizedString("GENERAL.OK", comment: "")
        let okAction = UIAlertAction(title: okActionTitle, style: .default) { (_) in
            OperationQueue.main.addOperation {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        
        alert.addAction(okAction)
        
        OperationQueue.main.addOperation {
            self.present(alert, animated: true, completion: nil)
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
                let decodedInitialQRCode = try JSONDecoder().decode(DeviceAuthenticationQRCodeContent.self, from: dataValue)
                
                // store URL somewhere, maybe in the appConfiguration?
                // store token? I only need it temporarily
                // request apiToken
                
//                self.appConfigurationManager.deleteCurrentAppConfiguration()
//                self.appConfigurationManager.newAppConfigurationAvailable(decodedAppConfiguration)
                
                self.captureSession?.stopRunning()
                
                OperationQueue.main.addOperation {
                    self.scanConfigurationView.appConfiguredSuccessfully()
                }
            } catch let error {
                print(error)
                assertionFailure("Scanning failed")
                return
            }
        }
    }
}
