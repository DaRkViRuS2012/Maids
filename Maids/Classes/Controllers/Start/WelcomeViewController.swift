//
//  WelcomeViewController.swift
//  Wardah
//
//  Created by Nour  on 11/12/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class WelcomeViewController: AbstractController {


    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var heyLabel: UILabel!
    @IBOutlet weak var welcomView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func customizeView() {
        // set fonts 
        heyLabel.font = AppFonts.xBigBold
        welcomeLabel.font = AppFonts.normalSemiBold
        infoLabel.font = AppFonts.normalSemiBold
        startButton.titleLabel?.font = AppFonts.big
        
        
        // set title
        
        heyLabel.text = "WELCOME_HEY_LABEL".localized
        welcomeLabel.text = "WELCOME_LABEL".localized
        infoLabel.text = "WELCOME_INFO_LABEL".localized
        
        startButton.setTitle("WELCOME_START_BUTTON_TITLE".localized, for: .normal)
        
        startButton.layer.cornerRadius = startButton.frame.height / 2
    }
    
    override func buildUp() {
        topView.animateIn(mode: .animateInFromBottom, delay: 0.2)
        welcomView.animateIn(mode: .animateInFromBottom, delay: 0.3)
        startButton.animateIn(mode: .animateInFromBottom, delay: 0.4)
    }


}
