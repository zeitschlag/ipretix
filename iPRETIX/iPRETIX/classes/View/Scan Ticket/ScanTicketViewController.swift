//
//  ScanTicketViewController.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 15.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit
import AVFoundation

class ScanTicketViewController: UIViewController {
    
    let ticketManager: TicketManager
    let scanTicketView: ScanTicketView
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private var qrCodeDetected = false
    
    init(withTicketManager: TicketManager) {
        
        self.scanTicketView = ScanTicketView(withBranding: Branding.shared)
        self.ticketManager = withTicketManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.view.addSubview(self.scanTicketView)
        
        // set navigation items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(ScanTicketViewController.manualSearchButtonTapped(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupQRCodeReader()
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
            videoPreviewLayer.frame = self.scanTicketView.cameraView.frame
            scanTicketView.cameraView.layer.addSublayer(videoPreviewLayer)
            
            self.videoPreviewLayer = videoPreviewLayer
            self.captureSession = captureSession
            
            self.captureSession?.startRunning()
            
        } catch let error {
            assertionFailure("Error setting up QR-Reader: \(error.localizedDescription)")
            return
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        let topContentConstraint = self.scanTicketView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let bottomContentConstraint = self.scanTicketView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        let leadingContentConstraint = self.scanTicketView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        let trailingContentConstraint = self.scanTicketView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        
        NSLayoutConstraint.activate([topContentConstraint, bottomContentConstraint, leadingContentConstraint, trailingContentConstraint])
        
    }
    
    //MARK: - Actions
    
    @objc func manualSearchButtonTapped(_ sender: Any) {
        let manualSearchViewController = ManualSearchViewController()
        self.navigationController?.pushViewController(manualSearchViewController, animated: true)
    }
}

extension ScanTicketViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard metadataObjects.count > 0 else {
            return
        }
        
        guard let metaDataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        guard self.qrCodeDetected == false else {
            return
        }
        
        if metaDataObject.type == .qr, let secret = metaDataObject.stringValue {
            
            //TODO: Use a boolean flag to prevent multiple scannings at once
            
            do {
                guard let ticket = try self.ticketManager.ticket(withSecret: secret) else {
                    return
                }
                
                self.qrCodeDetected = true
                
                let redeemResult = self.ticketManager.redeemTicket(ticket)
                
                switch redeemResult {
                case .alreadyRedeemed:
                    self.ticketAlreadyRedeemed(ticket)
                case .validWithRequirements:
                    self.ticketValidWithRequirements(ticket)
                case .valid:
                    self.ticketValid(ticket)
                case .error(localizedDescription: let localizedDescription):
                    print(localizedDescription)
                    self.captureSession?.stopRunning()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func ticketAlreadyRedeemed(_ ticket: Ticket) {
        self.videoPreviewLayer?.connection?.isEnabled = false
        self.scanTicketView.updateBottomView(withTicket: ticket, andRedeemingResult: .alreadyRedeemed)
        //TODO: Add Delay, otherwise doesn't scanning work like expected
        self.continueScanningWithDelay()
    }
    
    private func ticketValidWithRequirements(_ ticket: Ticket) {
        self.videoPreviewLayer?.connection?.isEnabled = false
        self.scanTicketView.updateBottomView(withTicket: ticket, andRedeemingResult: .validWithRequirements)
        let attentionAlert = UIAlertController(title: nil, message: NSLocalizedString("Special Ticket", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in
            self.continueScanningWithDelay()
        }
        
        attentionAlert.addAction(okAction)
        self.present(attentionAlert, animated: true, completion: nil)
    }
    
    private func ticketValid(_ ticket: Ticket) {
        self.videoPreviewLayer?.connection?.isEnabled = false
        self.scanTicketView.updateBottomView(withTicket: ticket, andRedeemingResult: .valid)
        self.continueScanningWithDelay()
    }
    
    private func continueScanningWithDelay() {
        
        //TODO: Make configurable?
        let delayInSeconds: UInt64 = 5
        let delay = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + delayInSeconds*NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.qrCodeDetected = false
            self.videoPreviewLayer?.connection?.isEnabled = true
            self.scanTicketView.resetBottomView()
        }
    }
    
}
