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
    
    private let appConfigurationManager: AppConfigurationManager
    
    init(withAppConfigurationManager: AppConfigurationManager) {
        
        self.configurationView = ConfigurationView()
        self.appConfigurationManager = withAppConfigurationManager
        
        super.init(nibName: nil, bundle: nil)
        
        self.configurationView.deleteCurrentConfigurationButton.addTarget(self, action: #selector(ConfigurationViewController.deleteCurrentConfigurationButtonTapped(_:)), for: .touchUpInside)

    }
    
    override func loadView() {
        super.loadView()

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
        let alert = UIAlertController(title: NSLocalizedString("Delete current Configuration?", comment: ""), message: nil, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { (action) in
            
            self.appConfigurationManager.deleteCurrentAppConfiguration()
            
            OperationQueue.main.addOperation {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
