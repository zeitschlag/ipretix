//
//  ScanConfigurationView.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 15.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class ScanConfigurationView: UIView {
    // uiview for camera
    // uiview for bottom
    var cameraView: UIView
    var bottomView: UIView
    var resultLabel: UILabel
    
    let branding: Branding
    
    init(branding: Branding) {

        self.branding = branding
        
        self.cameraView = UIView(frame: .zero)
        
        self.bottomView = UIView(frame: .zero)
        self.bottomView.backgroundColor = self.branding.darkBackgroundColor
        
        self.resultLabel = UILabel(frame: .zero)
        self.resultLabel.text = NSLocalizedString("SCAN_CONFIGURATION.PLEASE_SCAN_CONFIGURATION", comment: "")
        
        self.resultLabel.numberOfLines = 0
        self.resultLabel.textAlignment = .center
        self.resultLabel.font = self.branding.largeLabelFont
        self.resultLabel.textColor = self.branding.lightTextColor

        bottomView.addSubview(resultLabel)
        
        super.init(frame: CGRect.zero)
        
        self.cameraView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.resultLabel.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(cameraView)
        self.addSubview(bottomView)
        
        self.backgroundColor = branding.defaultBackgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var constraints = [NSLayoutConstraint]()
        
        let cameraTopConstraint = self.cameraView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        let cameraLeadingConstraint = self.cameraView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor)
        let cameraTrailingConstraint = self.cameraView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        
        constraints.append(cameraTopConstraint)
        constraints.append(cameraLeadingConstraint)
        constraints.append(cameraTrailingConstraint)
        
        let bottomTopConstraint = self.bottomView.topAnchor.constraint(equalTo: self.cameraView.bottomAnchor)
        let bottomLeadingConstraint = self.bottomView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor)
        let bottomTrailingConstraint = self.bottomView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        let bottomBottomConstraint = self.bottomView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        
        //FIXME: Remove this
        let bottomHeightConstraint = NSLayoutConstraint(item: self.bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 144.0)
        constraints.append(bottomHeightConstraint)
        
        constraints.append(bottomTopConstraint)
        constraints.append(bottomLeadingConstraint)
        constraints.append(bottomTrailingConstraint)
        constraints.append(bottomBottomConstraint)
        
        let resultLabelCenterXConstraint = NSLayoutConstraint(item: self.resultLabel, attribute: .centerX, relatedBy: .equal, toItem: self.bottomView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let resultLabelCenterYConstraint = NSLayoutConstraint(item: self.resultLabel, attribute: .centerY, relatedBy: .equal, toItem: self.bottomView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let resultLabelLeadingConstraint = NSLayoutConstraint(item: self.resultLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self.bottomView, attribute: .leading, multiplier: 1.0, constant: 60.0)
        
        constraints.append(resultLabelCenterXConstraint)
        constraints.append(resultLabelCenterYConstraint)
        constraints.append(resultLabelLeadingConstraint)
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func appConfiguredSuccessfully() {
        UIView.animate(withDuration: 0.5) {
            self.bottomView.backgroundColor = self.branding.confirmationBackgroundColor
            self.resultLabel.text = NSLocalizedString("SCAN_CONFIGURATION.CONFIGURATION_SUCCESSFUL", comment: "")
            self.resultLabel.textColor = self.branding.confirmationTextColor
        }
    }
}
