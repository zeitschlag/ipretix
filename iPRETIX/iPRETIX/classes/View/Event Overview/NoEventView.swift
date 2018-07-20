//
//  NoEventView.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 15.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class NoEventView: UIView {

    let configureAppButton: UIButton
    
    init(branding: Branding) {
        
        let configureAppButtonTitle = NSLocalizedString("EVENT_OVERVIEW.BUTTON.CONFIGURE_APP", comment: "")
        
        configureAppButton = UIButton(type: .system)
        configureAppButton.setTitle(configureAppButtonTitle, for: .normal)
        configureAppButton.titleLabel?.font = branding.defaultButtonFont
        configureAppButton.setTitleColor(branding.defaultButtonTextColor, for: .normal)

        super.init(frame: CGRect.zero)
        
        self.backgroundColor = branding.defaultBackgroundColor
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configureAppButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.configureAppButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horizontalCenterConstraint = NSLayoutConstraint(item: self.configureAppButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let verticalCenterConstraint = NSLayoutConstraint(item: self.configureAppButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([horizontalCenterConstraint, verticalCenterConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
