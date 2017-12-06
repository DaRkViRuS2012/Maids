//
//  ChatViewController.swift
//  Wardah
//
//  Created by Dania on 7/5/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation

class ChatViewController: AbstractController {
    
    // MARK: Properties
    
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // enable close button
        self.showNavCloseButton = true
        // set title
        setNavBarTitleImage(type: .logoAndText)
    }
    
    // Customize all view members (fonts - style - text)
    override func customizeView() {
        super.customizeView()
    }
    
}
