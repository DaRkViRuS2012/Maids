//
//  LoginViewController.swift
//  Wardah
//
//  Created by Hani on 4/25/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import UIKit

class LoginViewController: AbstractController {

    // MARK: Properties
    // login view
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

   
    // Center View
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var loginButton: RNLoadingButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    // footer view
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarTitle(title: "START_TITLE".localized)
        self.showNavCloseButton = true
    }
    
    // Customize all view members (fonts - style - text)
    override func customizeView() {
        super.customizeView()
        // set fonts
        loginButton.titleLabel?.font = AppFonts.normalSemiBold
        forgetPasswordButton.titleLabel?.font = AppFonts.small
        signupButton.titleLabel?.font = AppFonts.big
        
     
        // set text
        loginButton.setTitle("START_NORMAL_LOGIN".localized, for: .normal)
        loginButton.setTitle("START_NORMAL_LOGIN".localized, for: .highlighted)
        loginButton.hideTextWhenLoading = true
        forgetPasswordButton.setTitle("START_FORGET_PASSWORD".localized, for: .normal)
        forgetPasswordButton.setTitle("START_FORGET_PASSWORD".localized, for: .highlighted)
        signupButton.setTitle("START_CREATE_ACCOUNT".localized, for: .normal)
        signupButton.setTitle("START_CREATE_ACCOUNT".localized, for: .highlighted)
        emailTextField.placeholder = "START_EMAIL_PLACEHOLDER".localized
        passwordTextField.placeholder = "START_PASSWORD_PLACEHOLDER".localized
        
        // text field styles
        emailTextField.appStyle()
        passwordTextField.appStyle()
        
        // customize button
        loginButton.setRoundedBorder()
        
        // set Colors
        loginButton.backgroundColor = AppColors.primary
    }
    
    // Build up view elements
    override func buildUp() {
        loginView.animateIn(mode: .animateInFromBottom, delay: 0.2)
        centerView.animateIn(mode: .animateInFromBottom, delay: 0.3)
        footerView.animateIn(mode: .animateInFromBottom, delay: 0.4)
    }
    
    // MARK: Actions
    @IBAction func loginAction(_ sender: RNLoadingButton) {
        // validate email
        if let email = emailTextField.text, !email.isEmpty {
            if email.isValidEmail() {
                // validate password
                if let password = passwordTextField.text, !password.isEmpty {
                    if password.length >= AppConfig.passwordLength {
                        // start login process
                        loginButton.isLoading = true
                        self.view.isUserInteractionEnabled = false
                        ApiManager.shared.userLogin(email: email, password: password) { (isSuccess, error, user) in
                            // stop loading
                            self.loginButton.isLoading = false
                            self.view.isUserInteractionEnabled = true
                            // login success
                            if (isSuccess) {
                                self.dismiss(animated: true, completion: nil)
//                                self.popOrDismissViewControllerAnimated(animated: true)                                
                            } else {
                                self.showMessage(message:(error?.type.errorMessage)!, type: .error)
                            }
                        }
                    } else {
                        showMessage(message:"SINGUP_VALIDATION_PASSWORD_LENGHTH".localized, type: .warning)
                    }
                } else {
                    showMessage(message:"SINGUP_VALIDATION_PASSWORD".localized, type: .warning)
                }
            } else {
                showMessage(message:"SINGUP_VALIDATION_EMAIL_FORMAT".localized, type: .warning)
            }
        } else {
            showMessage(message:"SINGUP_VALIDATION_EMAIL".localized, type: .warning)
        }
    }
    


    
    // MARK: textField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            loginAction(loginButton)
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

