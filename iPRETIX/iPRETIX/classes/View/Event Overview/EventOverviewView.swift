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
    var openConfigurationButton: UIButton
    
    init(withBranding branding: Branding) {
        
        self.scanTicketsButton = UIButton(type: .system)
        let scanTicketsButtonTitle = NSLocalizedString("Scan Tickets", comment: "")
        self.scanTicketsButton.setTitle(scanTicketsButtonTitle, for: .normal)
        self.scanTicketsButton.titleLabel?.font = branding.defaultButtonFont
        self.scanTicketsButton.setTitleColor(branding.defaultButtonTextColor, for: .normal)
        
        let gearImage = UIImage(named: "Gear")
        self.openConfigurationButton = UIButton(type: .system)
        self.openConfigurationButton.setImage(gearImage, for: .normal)
        self.openConfigurationButton.tintColor = branding.defaultButtonTextColor
        self.openConfigurationButton.setTitleColor(branding.defaultButtonTextColor, for: .normal)
        
        super.init(frame: CGRect.zero)
        
        self.scanTicketsButton.translatesAutoresizingMaskIntoConstraints = false
        self.openConfigurationButton.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.scanTicketsButton)
        self.addSubview(self.openConfigurationButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        let scanTicketsCenterXConstraint = NSLayoutConstraint(item: self.scanTicketsButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let scanTicketsCenterYConstraint = NSLayoutConstraint(item: self.scanTicketsButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([scanTicketsCenterXConstraint, scanTicketsCenterYConstraint])
        
        let openConfigurationLeadingMargin = self.openConfigurationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0)
        let openConfigurationTopMargin = self.openConfigurationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0)
        let openConfigurationButtonWidth = NSLayoutConstraint(item: self.openConfigurationButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 48.0)
        let openConfigurationButtonHeight = NSLayoutConstraint(item: self.openConfigurationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 48.0)
        
        NSLayoutConstraint.activate([openConfigurationLeadingMargin, openConfigurationTopMargin, openConfigurationButtonWidth, openConfigurationButtonHeight])
    }
}
