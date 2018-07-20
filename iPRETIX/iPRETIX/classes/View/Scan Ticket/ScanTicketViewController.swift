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
    let checkinManager: CheckInManager
    let syncManager: SyncManager
    let scanTicketView: ScanTicketView
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let branding = Branding.shared
    
    private var qrCodeDetected = false
    
    struct DelayBetweenTwoScans {
        static let standard: UInt64 = 3
        static let noDelay: UInt64 = 0
    }
    
    let shouldUploadImmediately: Bool
    
    init(ticketManager: TicketManager, checkInManager: CheckInManager, syncManager: SyncManager) {
        
        self.scanTicketView = ScanTicketView(branding: Branding.shared)
        self.ticketManager = ticketManager
        self.checkinManager = checkInManager
        self.syncManager = syncManager
        
        self.shouldUploadImmediately = LocalAppSettings().uploadImmediately
    
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ScanTicketViewController.checkInUploadStarted(_:)), name: SyncManager.Notifications.CheckInUploadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScanTicketViewController.checkInUploadFailed(_:)), name: SyncManager.Notifications.CheckInUploadFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScanTicketViewController.checkInUploadIncomplete(_:)), name: SyncManager.Notifications.CheckInUploadIncomplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScanTicketViewController.checkInUploadSucceeded(_:)), name: SyncManager.Notifications.CheckInUploadSucceeded, object: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.view.addSubview(self.scanTicketView)
        self.view.backgroundColor = self.branding.defaultBackgroundColor
        
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
    
    //MARK: - Notifications
    
    @objc func checkInUploadStarted(_ notification: Notification) {
        guard self.shouldUploadImmediately == true else {
            return
        }
    }
    
    @objc func checkInUploadFailed(_ notification: Notification) {
        guard self.shouldUploadImmediately == true else {
            return
        }
    }
    
    @objc func checkInUploadIncomplete(_ notification: Notification) {
        guard self.shouldUploadImmediately == true else {
            return
        }
    }
    
    @objc func checkInUploadSucceeded(_ notification: Notification) {
        guard self.shouldUploadImmediately == true else {
            return
        }
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
                    NSLog("No ticket with secret \(secret)")
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
        self.continueScanning(withDelayInSeconds: DelayBetweenTwoScans.standard)
    }
    
    private func ticketValidWithRequirements(_ ticket: Ticket) {
        self.videoPreviewLayer?.connection?.isEnabled = false
        self.scanTicketView.updateBottomView(withTicket: ticket, andRedeemingResult: .validWithRequirements)
        let attentionAlert = UIAlertController(title: nil, message: NSLocalizedString("SCAN_TICKETS.ALERT.SPECIAL_TICKET", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("GENERAL.OK", comment: ""), style: .default) { (_) in
            
            if let secret = ticket.secret {
                do {
                    let checkIn = try self.checkinManager.insertNewCheckIn(withDateTime: Date(), secret: secret)
                    if self.shouldUploadImmediately == true {
                        self.syncManager.upload(checkIn: checkIn)
                    }
                } catch {
                    //TODO: Error Handling
                }
            }
            
            self.continueScanning(withDelayInSeconds: DelayBetweenTwoScans.noDelay)
        }
        
        attentionAlert.addAction(okAction)
        self.present(attentionAlert, animated: true, completion: nil)
    }
    
    private func ticketValid(_ ticket: Ticket) {
        self.videoPreviewLayer?.connection?.isEnabled = false
        self.scanTicketView.updateBottomView(withTicket: ticket, andRedeemingResult: .valid)
        
        guard let secret = ticket.secret else {
            self.continueScanning(withDelayInSeconds: DelayBetweenTwoScans.standard)
            return
        }
        
        do {
            let checkIn = try self.checkinManager.insertNewCheckIn(withDateTime: Date(), secret: secret)
            if self.shouldUploadImmediately == true {
                self.syncManager.upload(checkIn: checkIn)
            }
        } catch {
            
        }
        
        self.continueScanning(withDelayInSeconds: DelayBetweenTwoScans.standard)
    }
    
    private func continueScanning(withDelayInSeconds delayInSeconds: UInt64) {
        
        let delay = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + delayInSeconds*NSEC_PER_SEC)
        //FIXME: 200_000_000 nanoseconds == 0.2 seconds. We need this for animation
        let continueScanningDelay = DispatchTime(uptimeNanoseconds: delay.uptimeNanoseconds+200_000_000)
        
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.videoPreviewLayer?.connection?.isEnabled = true
            self.scanTicketView.resetBottomView()
        }
        
        DispatchQueue.main.asyncAfter(deadline: continueScanningDelay) {
            self.qrCodeDetected = false
        }
        
    }
    
}
