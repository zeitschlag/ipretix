//
//  EventOverviewView.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 15.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class EventOverviewView: UIView {
    var scanTicketsButton: UIButton
    
    override init(frame: CGRect) {
        self.scanTicketsButton = UIButton(type: .system)
        let scanTicketsButtonTitle = NSLocalizedString("Scan Tickets", comment: "")
        self.scanTicketsButton.setTitle(scanTicketsButtonTitle, for: .normal)
        
        super.init(frame: frame)
        
        self.scanTicketsButton.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.scanTicketsButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        let scanTicketsCenterXConstraint = NSLayoutConstraint(item: self.scanTicketsButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let scanTicketsCenterYConstraint = NSLayoutConstraint(item: self.scanTicketsButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([scanTicketsCenterXConstraint, scanTicketsCenterYConstraint])
    }
}
