//
//  ProfileViewController.swift
//  Wardah
//
//  Created by Dania on 7/5/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation

class ProfileViewController: AbstractController {
    
    // MARK: Properties
    @IBOutlet weak var autherLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: Properties
    var activeUser: AppUser?
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // enable close button
        if activeUser != nil {
            self.showNavBackButton = true
        } else {
            self.showNavCloseButton = true
        }
        // set title
        setNavBarTitleImage(type: .logoAndText)
    }
    
    // Customize all view members (fonts - style - text)
    override func customizeView() {
        super.customizeView()
        if let user = activeUser, !user.isEqual(item: DataStore.shared.me!) {
            logoutButton.isHidden = true
            autherLabel.text = user.fullName
        } else {//current user
            logoutButton.isHidden = false
            autherLabel.text = DataStore.shared.me!.fullName
        }
    }
    
    // MARK: Actions
    @IBAction func logoutAction(_ sender: UIButton) {
        ActionLogout.execute()
    }
    
}
