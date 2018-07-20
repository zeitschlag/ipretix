//
//  ConfigurationView.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 03.03.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class ConfigurationView: UIView {
    
    private let uploadImmediatelyView: UIView
    let uploadImmediatelyTitleLabel: UILabel
    let uploadImmediatelySwitch: UISwitch
    let deleteCurrentConfigurationButton: UIButton
    
    override init(frame: CGRect) {
        
        let branding = Branding.shared
        
        self.uploadImmediatelyTitleLabel = UILabel(frame: .zero)
        self.uploadImmediatelyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.uploadImmediatelyTitleLabel.text = NSLocalizedString("CONFIGURATION.UPLOAD_IMMEDIATELY", comment: "")
        self.uploadImmediatelyTitleLabel.numberOfLines = 0
        self.uploadImmediatelyTitleLabel.font = branding.defaultLabelFont
        self.uploadImmediatelyTitleLabel.textColor = branding.darkTextColor
        
        self.uploadImmediatelySwitch = UISwitch(frame: .zero)
        self.uploadImmediatelySwitch.translatesAutoresizingMaskIntoConstraints = false

        self.uploadImmediatelyView = UIView(frame: .zero)
        self.uploadImmediatelyView.translatesAutoresizingMaskIntoConstraints = false
        self.uploadImmediatelyView.addSubview(self.uploadImmediatelyTitleLabel)
        self.uploadImmediatelyView.addSubview(self.uploadImmediatelySwitch)

        self.deleteCurrentConfigurationButton = UIButton(type: .system)
        self.deleteCurrentConfigurationButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteCurrentConfigurationButton.setTitle(NSLocalizedString("CONFIGURATION.RESET_CONFIGURATION", comment: ""), for: .normal)
        self.deleteCurrentConfigurationButton.setTitleColor(branding.destructiveButtonTextColor, for: .normal)
        self.deleteCurrentConfigurationButton.titleLabel?.font = branding.smallButtonFont
        self.deleteCurrentConfigurationButton.titleLabel?.textAlignment = .center
        self.deleteCurrentConfigurationButton.titleLabel?.lineBreakMode = .byWordWrapping
        
        super.init(frame: frame)
        
        self.addSubview(self.uploadImmediatelyView)
        self.addSubview(self.deleteCurrentConfigurationButton)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = branding.defaultBackgroundColor
        
        self.setupConstraints()

    }
    
    private func setupConstraints() {
        
        var constraints = [NSLayoutConstraint]()
        
        let uploadImmediatelyTopConstraint = self.uploadImmediatelyView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0)
        constraints.append(uploadImmediatelyTopConstraint)
        
        let uploadImmediatelyLeadingConstraint = self.uploadImmediatelyView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        constraints.append(uploadImmediatelyLeadingConstraint)
        
        let uploadImmediatelyTrailingConstraint = self.uploadImmediatelyView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        constraints.append(uploadImmediatelyTrailingConstraint)
        
        let uploadImmediatelyTitleTopConstraint = self.uploadImmediatelyTitleLabel.topAnchor.constraint(equalTo: self.uploadImmediatelyView.topAnchor, constant: 2)
        constraints.append(uploadImmediatelyTitleTopConstraint)
        
        let uploadImmediatelyTitleLeadingConstrain = self.uploadImmediatelyTitleLabel.leadingAnchor.constraint(equalTo: self.uploadImmediatelyView.leadingAnchor, constant: 8)
        constraints.append(uploadImmediatelyTitleLeadingConstrain)
        
        let uploadImmediatelyTitleBottomConstraint = self.uploadImmediatelyView.bottomAnchor.constraint(equalTo: self.uploadImmediatelyTitleLabel.bottomAnchor, constant: 2)
        constraints.append(uploadImmediatelyTitleBottomConstraint)
        
        let uploadSwitchLeadingConstraint = self.uploadImmediatelySwitch.leadingAnchor.constraint(equalTo: self.uploadImmediatelyTitleLabel.trailingAnchor, constant: 8)
        constraints.append(uploadSwitchLeadingConstraint)
       
        let uploadSwitchCenterYConstraint = self.uploadImmediatelySwitch.centerYAnchor.constraint(equalTo: self.uploadImmediatelyTitleLabel.centerYAnchor)
        constraints.append(uploadSwitchCenterYConstraint)
        
        let uploadSwitchTrailingConstraint = self.uploadImmediatelyView.trailingAnchor.constraint(equalTo: self.uploadImmediatelySwitch.trailingAnchor, constant: 8)
        constraints.append(uploadSwitchTrailingConstraint)
        
        let resetButtonTopConstraint = self.deleteCurrentConfigurationButton.topAnchor.constraint(equalTo: self.uploadImmediatelyView.bottomAnchor, constant: 16)
        constraints.append(resetButtonTopConstraint)
        
        let resetButtonCenterXConstraint = self.deleteCurrentConfigurationButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        constraints.append(resetButtonCenterXConstraint)

        let resetButtonLeadingConstraint = self.deleteCurrentConfigurationButton.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 8)
        constraints.append(resetButtonLeadingConstraint)

        let resetButtonTrailingConstraint = self.trailingAnchor.constraint(greaterThanOrEqualTo: self.deleteCurrentConfigurationButton.trailingAnchor, constant: 8)
        constraints.append(resetButtonTrailingConstraint)
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
