//
//  ConfigurationView.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 03.03.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class ConfigurationView: UIView {
    var deleteCurrentConfigurationButton: UIButton
    
    override init(frame: CGRect) {
        
        let branding = Branding.shared
        
        self.deleteCurrentConfigurationButton = UIButton(type: .system)
        self.deleteCurrentConfigurationButton.setTitle(NSLocalizedString("Reset current Configuration", comment: ""), for: .normal)
        self.deleteCurrentConfigurationButton.setTitleColor(branding.defaultButtonTextColor, for: .normal)
        self.deleteCurrentConfigurationButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = branding.defaultBackgroundColor
        
        self.addSubview(self.deleteCurrentConfigurationButton)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var constraints = [NSLayoutConstraint]()
        
        let buttonTopConstraint = self.deleteCurrentConfigurationButton.topAnchor.constraint(equalTo: self.topAnchor)
        let buttonLeadingConstraint = self.deleteCurrentConfigurationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let buttonTrailingConstraint = self.deleteCurrentConfigurationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let buttonHeightConstraint = NSLayoutConstraint(item: self.deleteCurrentConfigurationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 44.0)
        
        constraints.append(contentsOf: [buttonTopConstraint, buttonLeadingConstraint, buttonTrailingConstraint, buttonHeightConstraint])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
