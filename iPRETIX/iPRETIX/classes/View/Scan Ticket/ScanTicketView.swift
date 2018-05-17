//
//  ScanTicketView.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 03.02.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class ScanTicketView: UIView {
    
    var cameraView: UIView
    
    var bottomView: UIView
    let resultLabel: UILabel
    let ticketTypeLabel: UILabel
    let orderCodeLabel: UILabel
    let nameLabel: UILabel
    
    let branding: Branding
    
    init(branding: Branding) {
        
        self.branding = branding
        
        self.cameraView = UIView(frame: .zero)
        
        //TOXO: Put Color-things in an own update-method.
        self.bottomView = UIView(frame: .zero)
        self.bottomView.backgroundColor = self.branding.darkBackgroundColor
        
        self.resultLabel = UILabel(frame: .zero)
        self.resultLabel.text = NSLocalizedString("(Please scan a ticket)", comment: "")
        
        self.resultLabel.numberOfLines = 0
        self.resultLabel.textAlignment = .center
        self.resultLabel.font = self.branding.largeLabelFont
        self.resultLabel.textColor = self.branding.lightTextColor
        
        self.ticketTypeLabel = UILabel(frame: .zero)
        self.ticketTypeLabel.font = self.branding.defaultLabelFont
        self.ticketTypeLabel.textColor = self.branding.lightTextColor
        self.ticketTypeLabel.text = "-"
        self.ticketTypeLabel.numberOfLines = 1
        
        self.orderCodeLabel = UILabel(frame: .zero)
        self.orderCodeLabel.font = self.branding.defaultLabelFont
        self.orderCodeLabel.textAlignment = .left
        self.orderCodeLabel.text = "-"
        self.orderCodeLabel.numberOfLines = 1
        self.orderCodeLabel.textColor = self.branding.lightTextColor
        
        self.nameLabel = UILabel(frame: .zero)
        self.nameLabel.font = self.branding.defaultLabelFont
        self.nameLabel.textAlignment = .right
        self.nameLabel.numberOfLines = 1
        self.nameLabel.text = "-"
        self.nameLabel.textColor = self.branding.lightTextColor
        
        bottomView.addSubview(resultLabel)
        bottomView.addSubview(ticketTypeLabel)
        bottomView.addSubview(orderCodeLabel)
        bottomView.addSubview(nameLabel)
        
        super.init(frame: CGRect.zero)
        
        self.cameraView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.resultLabel.translatesAutoresizingMaskIntoConstraints = false
        self.ticketTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.orderCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        let bottomHeightConstraint = NSLayoutConstraint(item: self.bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 144.0)
        constraints.append(bottomHeightConstraint)
        
        constraints.append(bottomTopConstraint)
        constraints.append(bottomLeadingConstraint)
        constraints.append(bottomTrailingConstraint)
        constraints.append(bottomBottomConstraint)
        
        let resultLabelCenterXConstraint = NSLayoutConstraint(item: self.resultLabel, attribute: .centerX, relatedBy: .equal, toItem: self.bottomView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let resultLabelTopConstraint = NSLayoutConstraint(item: self.resultLabel, attribute: .top, relatedBy: .equal, toItem: self.bottomView, attribute: .top, multiplier: 1.0, constant: 16.0)
        
        constraints.append(resultLabelCenterXConstraint)
        constraints.append(resultLabelTopConstraint)
        
        let ticketTypeLeadingConstraint = self.ticketTypeLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor, constant: 14.0)
        let ticketTypeTopConstraint = self.ticketTypeLabel.topAnchor.constraint(equalTo: self.resultLabel.bottomAnchor, constant: 13.0)
        let ticketTypeBottomConstraint = self.nameLabel.topAnchor.constraint(equalTo: self.ticketTypeLabel.bottomAnchor, constant: 13.0)
        let ticketTrailingConstraint = self.bottomView.trailingAnchor.constraint(equalTo: self.ticketTypeLabel.trailingAnchor, constant: 13.0)
        
        constraints.append(ticketTypeLeadingConstraint)
        constraints.append(ticketTypeTopConstraint)
        constraints.append(ticketTypeBottomConstraint)
        constraints.append(ticketTrailingConstraint)
        
        let orderCodeLeadingConstraint = self.orderCodeLabel.leadingAnchor.constraint(equalTo: self.ticketTypeLabel.leadingAnchor)
        let orderCodeBottomConstraint = self.bottomView.bottomAnchor.constraint(equalTo: self.orderCodeLabel.bottomAnchor, constant: 25.0)
        
        constraints.append(orderCodeLeadingConstraint)
        constraints.append(orderCodeBottomConstraint)
        
        let nameTrailingConstraint = self.bottomView.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor, constant: 14.0)
        let nameBaselineConstraint = self.nameLabel.firstBaselineAnchor.constraint(equalTo: self.orderCodeLabel.firstBaselineAnchor)
        let nameLeadingConstraint = self.nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.orderCodeLabel.trailingAnchor, constant: 10.0)
        
        constraints.append(nameTrailingConstraint)
        constraints.append(nameBaselineConstraint)
        constraints.append(nameLeadingConstraint)
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func updateBottomView(withTicket ticket: Ticket, andRedeemingResult redeemingResult: TicketManager.TicketRedeemingResult) {
        switch redeemingResult {
        case .valid, .validWithRequirements:
            
            OperationQueue.main.addOperation {
                
                self.nameLabel.text = ticket.attendeeName ?? "-"
                self.orderCodeLabel.text = ticket.orderCode ?? "-"
                self.ticketTypeLabel.text = ticket.itemName ?? "-"
                self.resultLabel.text = NSLocalizedString("Valid!", comment: "")
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.bottomView.backgroundColor = self.branding.confirmationBackgroundColor
                    self.nameLabel.textColor = self.branding.confirmationTextColor
                    self.orderCodeLabel.textColor = self.branding.confirmationTextColor
                    self.ticketTypeLabel.textColor = self.branding.confirmationTextColor
                    self.resultLabel.textColor = self.branding.confirmationTextColor
                })
            }
            
        case .alreadyRedeemed:
            OperationQueue.main.addOperation {
                
                self.nameLabel.text = ticket.attendeeName ?? "-"
                self.orderCodeLabel.text = ticket.orderCode ?? "-"
                self.ticketTypeLabel.text = ticket.itemName ?? "-"
                self.resultLabel.text = NSLocalizedString("Already redeemed", comment: "")
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.bottomView.backgroundColor = self.branding.errorBackgroundColor
                    self.nameLabel.textColor = self.branding.errorTextColor
                    self.orderCodeLabel.textColor = self.branding.errorTextColor
                    self.ticketTypeLabel.textColor = self.branding.errorTextColor
                    self.resultLabel.textColor = self.branding.errorTextColor
                })
            }
        case .error(localizedDescription: _):
            break
        }
    }
    
    func resetBottomView() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.nameLabel.text = "-"
            self.orderCodeLabel.text = "-"
            self.ticketTypeLabel.text = "-"
            self.resultLabel.text = NSLocalizedString("(Please scan a ticket)", comment: "")
            
            self.bottomView.backgroundColor = self.branding.darkBackgroundColor
            self.nameLabel.textColor = self.branding.lightTextColor
            self.orderCodeLabel.textColor = self.branding.lightTextColor
            self.ticketTypeLabel.textColor = self.branding.lightTextColor
            self.resultLabel.textColor = self.branding.lightTextColor
        })
    }
}
