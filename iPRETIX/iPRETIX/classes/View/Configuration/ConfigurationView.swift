//
//  ConfigurationView.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 03.03.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class ConfigurationView: UIView {
    
    let deleteCurrentConfigurationButton: UIButton
    let contentStackView: UIStackView
    
    override init(frame: CGRect) {
        
        let branding = Branding.shared
        
        self.deleteCurrentConfigurationButton = UIButton(type: .system)
        self.deleteCurrentConfigurationButton.setTitle(NSLocalizedString("Reset current Configuration", comment: ""), for: .normal)
        self.deleteCurrentConfigurationButton.setTitleColor(branding.destructiveButtonTextColor, for: .normal)
        self.deleteCurrentConfigurationButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteCurrentConfigurationButton.titleLabel?.font = branding.smallButtonFont
        
        self.contentStackView = UIStackView(arrangedSubviews: [])
        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentStackView.alignment = .top
        
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = branding.defaultBackgroundColor
        
        self.contentStackView.addArrangedSubview(self.deleteCurrentConfigurationButton)
        self.addSubview(self.contentStackView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var constraints = [NSLayoutConstraint]()
        
        let stackViewTopConstraint = self.contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0)
        let stackViewLeadingConstraint = self.contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let stackViewTrailingConstraint = self.contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let stackViewBottomConstraint = self.contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        constraints.append(contentsOf: [stackViewTopConstraint, stackViewLeadingConstraint, stackViewTrailingConstraint, stackViewBottomConstraint])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
