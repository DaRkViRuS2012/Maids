//
//  AddPostViewController.swift
//  Wardah
//
//  Created by Hani on 7/3/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation

class AddPostViewController: AbstractController {
    
    // MARK: Properties
    
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Customize all view members (fonts - style - text)
    override func customizeView() {
        super.customizeView()
    }

    // MARK: Actions
    /// Close screen
    @IBAction func closeAction(_ sender: RNLoadingButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
