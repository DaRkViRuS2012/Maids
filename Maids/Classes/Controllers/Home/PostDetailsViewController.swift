//
//  PostDetailsViewController.swift
//  Wardah
//
//  Created by Hani on 7/3/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation

class PostDetailsViewController: AbstractController {
    
    // MARK: Properties
    var activePost: Post!
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Customize all view members (fonts - style - text)
    override func customizeView() {
        super.customizeView()
        self.showNavBackButton = true
        self.setNavBarTitleImage(type: .logoAndText)
    }
    
}
