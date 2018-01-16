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
    
    override init(frame: CGRect) {
        
        self.cameraView = UIView(frame: .zero)
        
        self.bottomView = UIView(frame: .zero)
        self.bottomView.backgroundColor = .purple
        
        self.resultLabel = UILabel(frame: .zero)
        self.resultLabel.text = NSLocalizedString("please scan a configuration code", comment: "")

        bottomView.addSubview(resultLabel)
        
        super.init(frame: frame)
        
        self.cameraView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.resultLabel.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(cameraView)
        self.addSubview(bottomView)
        self.backgroundColor = .blue
        
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
        let bottomHeightConstraint = NSLayoutConstraint(item: self.bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 60.0)
        constraints.append(bottomHeightConstraint)
        
        constraints.append(bottomTopConstraint)
        constraints.append(bottomLeadingConstraint)
        constraints.append(bottomTrailingConstraint)
        constraints.append(bottomBottomConstraint)
        
        let resultLabelCenterXConstraint = NSLayoutConstraint(item: self.resultLabel, attribute: .centerX, relatedBy: .equal, toItem: self.bottomView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let resultLabelCenterYConstraint = NSLayoutConstraint(item: self.resultLabel, attribute: .centerY, relatedBy: .equal, toItem: self.bottomView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        constraints.append(resultLabelCenterXConstraint)
        constraints.append(resultLabelCenterYConstraint)
        
        NSLayoutConstraint.activate(constraints)
        
    }
}
