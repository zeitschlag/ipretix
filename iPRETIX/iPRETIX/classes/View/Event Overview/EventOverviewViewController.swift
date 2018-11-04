//
//  EventOverviewViewController.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 15.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class EventOverviewViewController: UIViewController {
    
    var noEventView: NoEventView? // this is not a nice way, there must be something better!
    var eventOverviewView: EventOverviewView?
    
    let appConfigurationManager: PretixConfigurationManager
    let syncManager: NetworkManager
    let ticketManager: TicketManager
    
    init(appConfigurationManager: PretixConfigurationManager, syncManager: NetworkManager, ticketManager: TicketManager) {
        
        self.appConfigurationManager = appConfigurationManager
        self.syncManager = syncManager
        self.ticketManager = ticketManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        guard let noEventView = self.noEventView else {
            assertionFailure("Check noEventView")
            return
        }
        
        guard let eventOverviewView = self.eventOverviewView else {
            assertionFailure("Check eventOverviewView")
            return
        }
        
        let noEventViewTopConstraint = noEventView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let noEventViewBottomConstraint = noEventView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        let noEventViewLeadingConstraint = noEventView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        let noEventViewTrailingConstraint = noEventView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        
        let eventOverviewViewTopConstraint = eventOverviewView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let eventOverviewViewBottomConstraint = eventOverviewView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        let eventOverviewViewLeadingConstraint = eventOverviewView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        let eventOverviewViewTrailingConstraint = eventOverviewView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        
        NSLayoutConstraint.activate(
            [noEventViewTopConstraint,
             noEventViewBottomConstraint,
             noEventViewLeadingConstraint,
             noEventViewTrailingConstraint,
             eventOverviewViewTopConstraint,
             eventOverviewViewBottomConstraint,
             eventOverviewViewLeadingConstraint,
             eventOverviewViewTrailingConstraint]
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViewVisibility()
    }
    
    func updateViewVisibility() {

        let eventConfigured = self.appConfigurationManager.currentAppConfiguration != nil
        
        if eventConfigured == true {
            self.eventOverviewView?.isHidden = false
            self.noEventView?.isHidden = true
        } else {
            self.eventOverviewView?.isHidden = true
            self.noEventView?.isHidden = false
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        
        let noEventView = NoEventView(branding: Branding.shared)
        noEventView.configureAppButton.addTarget(self, action: #selector(EventOverviewViewController.configureAppButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(noEventView)
        
        let eventOverviewView = EventOverviewView(branding: Branding.shared)
        eventOverviewView.scanTicketsButton.addTarget(self, action: #selector(EventOverviewViewController.scanTicketsButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(eventOverviewView)
        eventOverviewView.openConfigurationButton.addTarget(self, action: #selector(EventOverviewViewController.openConfigurationButtonTapped(_:)), for: .touchUpInside)
        
        self.noEventView = noEventView
        self.eventOverviewView = eventOverviewView
        
        self.updateViewVisibility()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
    // MARK: - Actions
    @objc func configureAppButtonTapped(_ sender: Any) {
        let scanConfigurationCodeViewController = ScanConfigurationViewController(appConfigurationManager: self.appConfigurationManager, syncManager: self.syncManager)
        self.navigationController?.present(UINavigationController(rootViewController: scanConfigurationCodeViewController), animated: true, completion: nil)
    }
    
    @objc func scanTicketsButtonTapped(_ sender: Any) {
        let checkInManager = CheckInManager(coreDataStack: CoreDataStack.shared)
        let scanTicketViewController = ScanTicketViewController(ticketManager: self.ticketManager, checkInManager: checkInManager, syncManager: self.syncManager)
        self.navigationController?.pushViewController(scanTicketViewController, animated: true)
    }
    
    @objc func openConfigurationButtonTapped(_ sender: Any) {
        let configurationViewController = ConfigurationViewController(appConfigurationManager: self.appConfigurationManager, syncManager: self.syncManager)
        self.navigationController?.pushViewController(configurationViewController, animated: true)
    }
    
}
