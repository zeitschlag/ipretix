//
//  ConfigurationViewController.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 15.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {
    
    private let configurationView: ConfigurationView
    private let appConfigurationManager: PretixConfigurationManager
    private let appSettings = LocalAppSettings()
    private let syncManager: SyncManager
    
    init(appConfigurationManager: PretixConfigurationManager, syncManager: SyncManager) {
        
        self.configurationView = ConfigurationView(frame: .zero)
        self.appConfigurationManager = appConfigurationManager
        self.syncManager = syncManager
        
        super.init(nibName: nil, bundle: nil)
        
        self.configurationView.deleteCurrentConfigurationButton.addTarget(self, action: #selector(ConfigurationViewController.deleteCurrentConfigurationButtonTapped(_:)), for: .touchUpInside)
        
        self.configurationView.uploadImmediatelySwitch.isOn = self.appSettings.uploadImmediately
        
        self.configurationView.uploadImmediatelySwitch.addTarget(self, action: #selector(toggleUploadImmediately(sender:)), for: UIControl.Event.valueChanged)
        
        self.title = NSLocalizedString("CONFIGURATION.TITLE", comment: "")
    }
    
    override func loadView() {
        super.loadView()

        self.view.backgroundColor = Branding.shared.defaultBackgroundColor
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.view.addSubview(self.configurationView)
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        let topConstraint = self.configurationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let leadingConstriant = self.configurationView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        let trailingConstriant = self.configurationView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        let bottomConstraint = self.configurationView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([topConstraint, leadingConstriant, trailingConstriant, bottomConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc private func deleteCurrentConfigurationButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("CONFIGURATION.ALERT.REMOVE_CURRENT.TITLE", comment: ""), message: nil, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("GENERAL.YES", comment: ""), style: .destructive) { (action) in
            
            self.appConfigurationManager.deleteCurrentAppConfiguration()
            
            OperationQueue.main.addOperation {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("GENERAL.CANCEL", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func toggleUploadImmediately(sender: Any) {
        guard let uploadSwitch = sender as? UISwitch else {
            assertionFailure("No switch")
            return
        }
        
        self.appSettings.uploadImmediately = uploadSwitch.isOn
        self.syncManager.uploadImmediatelyToggled()
    }
}
