//
//  ScanTicketViewController.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 15.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class ScanTicketViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // set navigation items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(ScanTicketViewController.manualSearchButtonTapped(_:)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .green
    }

    //MARK: - Actions
    
    @objc func manualSearchButtonTapped(_ sender: Any) {
        let manualSearchViewController = ManualSearchViewController()
        self.navigationController?.pushViewController(manualSearchViewController, animated: true)
    }
}
