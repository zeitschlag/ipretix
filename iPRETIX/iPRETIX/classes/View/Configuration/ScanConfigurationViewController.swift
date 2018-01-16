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
    
}

extension ScanConfigurationViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ScanConfigurationViewController.doneButtonTapped(_:)))
    }
}
