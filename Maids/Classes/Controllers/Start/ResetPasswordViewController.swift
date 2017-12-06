//
//  ResetPasswordViewController.swift
//  Wardah
//
//  Created by Hani on 4/25/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import UIKit

class ResetPasswordViewController: AbstractController {

    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var recoverButton: RNLoadingButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var recoverInfoLabel: UILabel!
    
    // Data
    var userEmail: String = ""
 
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavBackButton = true
        self.setNavBarTitle(title: "REST_TITLE".localized)
    }
 
    // Customize all view members (fonts - style - text)
    override func customizeView() {
        super.customizeView()
        // set fonts
        recoverButton.titleLabel?.font = AppFonts.big
        
        // set text
        emailTextField.placeholder = "SINGUP_EMAIL_PLACEHOLDER".localized
        recoverButton.setTitle("RESET_BUTTON_TITLE".localized, for: .normal)
        recoverButton.setTitle("RESET_BUTTON_TITLE".localized, for: .highlighted)
        recoverButton.hideTextWhenLoading = true
        
        // text field styles
        emailTextField.appStyle()
       
    }
    
    override func buildUp() {
        emailTextField.animateIn(mode: .animateInFromBottom, delay: 0.2)
        recoverButton.animateIn(mode: .animateInFromBottom, delay: 0.3)
        footerView.animateIn(mode: .animateInFromBottom, delay: 0.4)
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        // hide keyboard
        emailTextField.resignFirstResponder()
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    // MARK: Actions

    
    // MARK: Controller Logic
  
    

    @IBAction func handelRecoverPassword(_ sender: RNLoadingButton) {
        
        if validate(){
            forgetPassword()
        }
    }
        
    
    
    func validate() -> Bool{
        // check empty email address
        if let email = emailTextField.text, !email.isEmpty {
            // vaild email format
            if email.isValidEmail() {
                self.userEmail = email
                return true
            } else {
                showMessage(message:"SINGUP_VALIDATION_EMAIL_FORMAT".localized, type: .warning)
            }
        } else {
            showMessage(message:"SINGUP_VALIDATION_EMAIL".localized, type: .warning)
        }
        return false
    }
    
    
    func forgetPassword () {
        // start loader
        recoverButton.isLoading = true
        self.view.isUserInteractionEnabled = false
        ApiManager.shared.forgetPassword(email: userEmail) { (success: Bool, err: ServerError?) in
            // stop loader
            self.recoverButton.isLoading = false
            self.view.isUserInteractionEnabled = true
            if (success) {
                self.dismiss(animated: true, completion: {})
            } else {
                self.showMessage(message:(err?.type.errorMessage)!, type: .error)
            }
        }
    }

    
    // MARK: textField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

