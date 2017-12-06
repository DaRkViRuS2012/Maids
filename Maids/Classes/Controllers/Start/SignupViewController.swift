//
//  SignupViewController.swift
//  Wardah
//
//  Created by Molham Mahmoud on 4/25/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import UIKit
import PIDatePicker

class SignupViewController: AbstractController {
   
    
    
   

    // MARK: Properties

    
    // signup View
    @IBOutlet weak var SignupView: UIView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dateofbirthTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
   
   // signup Button
    @IBOutlet weak var signupButton: RNLoadingButton!
    
    //Footer View
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var haveAccountButton: RNLoadingButton!
    
    
    // Data
    var tempUserInfoHolder: AppUser = AppUser()
    var password: String = ""
    
    // datePicker
    var datePicker : UIDatePicker!
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavBackButton = true
        self.setNavBarTitle(title: "SIGNUP_TITLE".localized)
    }
 
    // Customize all view members (fonts - style - text)
    override func customizeView() {
        super.customizeView()
     
        // set text
        signupButton.setTitle("SINGUP_BTN_TITLE".localized, for: .normal)
        signupButton.setTitle("SINGUP_BTN_TITLE".localized, for: .highlighted)
        haveAccountButton.setTitle("SINGUP_HAVEACCOUNT_TITLE".localized, for: .normal)
        haveAccountButton.setTitle("SINGUP_HAVEACCOUNT_TITLE".localized, for: .highlighted)
        fullNameTextField.placeholder = "SINGUP_FULLNAME_PLACEHOLDER".localized
        emailTextField.placeholder = "SINGUP_EMAIL_PLACEHOLDER".localized
        mobileTextField.placeholder = "SINGUP_MOBILE_PLACEHOLDER".localized
        passwordTextField.placeholder = "SINGUP_PASSWORD_PLACEHOLDER".localized
        dateofbirthTextField.placeholder = "SINGUP_DATEOFBIRTH_PLACEHOLDER".localized
        addressTextField.placeholder = "SINGUP_ADDRESS_PLACEHOLDER".localized
        cityTextField.placeholder = "SINGUP_CITY_PLACEHOLDER".localized
        stateTextField.placeholder = "SINGUP_STATE_PLACEHOLDER".localized
        
        
        signupButton.hideTextWhenLoading = true
        
        
        // add show hide button
        passwordTextField.addIconButton(image: "eyeIcon")
        let passwordTextFieldRightButton = passwordTextField.rightView as! UIButton
        passwordTextFieldRightButton.addTarget(self, action: #selector(showOrHideText), for: .touchUpInside)
        
        
        
        
        signupButton.makeRounded()
      
        
        // colors
        
        signupButton.backgroundColor = AppColors.primary
        
        
        
        // text field styles
        
        fullNameTextField.appStyle()
        emailTextField.appStyle()
        mobileTextField.appStyle()
        passwordTextField.appStyle()
        dateofbirthTextField.appStyle()
        addressTextField.appStyle()
        cityTextField.appStyle()
        stateTextField.appStyle()
        

    }
    
    func showOrHideText(){
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
    }
  
    
    
    // Build up view elements
    override func buildUp() {
        SignupView.animateIn(mode: .animateInFromBottom, delay: 0.2)
        signupButton.animateIn(mode: .animateInFromBottom, delay: 0.3)
        footerView.animateIn(mode: .animateInFromBottom, delay: 0.4)
        
    }
    
    
    func close(){
        // hide keyboard
        fullNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        mobileTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        dateofbirthTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    override func backButtonAction(_ sender: AnyObject) {
       close()
    }
    
    @IBAction func backToLogin(_ sender: UIButton) {
        close()
    }
   
    
    @IBAction func signup(_ sender: RNLoadingButton) {
        if validate(){
        
            attempSignup()
        }
    }
    
    
    func validate() -> Bool{
        
        
        // validate FullName
        if let fullName = fullNameTextField.text, !fullName.isEmpty {
            tempUserInfoHolder.fullName = fullName
        } else {
            showMessage(message:"SINGUP_VALIDATION_FULLNAME".localized, type: .warning)
            return false
        }
        
        
        // validate email
        if let email = emailTextField.text, !email.isEmpty {
            
        } else {
            showMessage(message:"SINGUP_VALIDATION_EMAIL".localized, type: .warning)
            return false
        }
        
        if emailTextField.text!.isValidEmail() {
            tempUserInfoHolder.email = emailTextField.text!
        } else {
            showMessage(message:"SINGUP_VALIDATION_EMAIL_FORMAT".localized, type: .warning)
            return false
        }
        
        
        // validate Mobile
        if let mobile = mobileTextField.text, !mobile.isEmpty {
            
        } else {
            showMessage(message:"SINGUP_VALIDATION_MOBILE".localized, type: .warning)
            return false
        }
        
        
        
        if mobileTextField.text!.isPhoneNumber {
            tempUserInfoHolder.mobile = mobileTextField.text!
        } else {
            showMessage(message:"SINGUP_VALIDATION_MOBILE_FORMAT".localized, type: .warning)
            return false
        }
        
    
        // validate password
        if let psw = passwordTextField.text, !psw.isEmpty {
        } else {
            showMessage(message:"SINGUP_VALIDATION_PASSWORD".localized, type: .warning)
            return false
        }
        
        if passwordTextField.text!.length >= AppConfig.passwordLength {
            password = passwordTextField.text!;
        } else {
            showMessage(message:"SINGUP_VALIDATION_PASSWORD_LENGHTH".localized, type: .warning)
            return false
        }
        
        // validate birthDate
        if dateofbirthTextField.text!.length > 0{
            if (dateofbirthTextField.text?.isValidDate())! {
                tempUserInfoHolder.birthday = DateHelper.getDateFromString(dateofbirthTextField.text!)
            } else {
            showMessage(message:"SINGUP_VALIDATION_DATE".localized, type: .warning)
            return false
            }
        }
        
        
        //validate address
        if let address = addressTextField.text, !address.isEmpty {
            tempUserInfoHolder.address = address
        } else {
            showMessage(message:"SINGUP_VALIDATION_ADDRESS".localized, type: .warning)
            return false
        }
        
        
        // validate City
        if let city = cityTextField.text, !city.isEmpty {
            tempUserInfoHolder.city = city
        } else {
            showMessage(message:"SINGUP_VALIDATION_CITY".localized, type: .warning)
            return false
        }
        
        // validate State 
        
        if let state = stateTextField.text, !state.isEmpty {
            tempUserInfoHolder.state = state
        } else {
            showMessage(message:"SINGUP_VALIDATION_STATE".localized, type: .warning)
            return false
        }
    
        return true
    }
    
    /// Register user
    func attempSignup () {
        // show loader
        signupButton.isLoading = true
        self.view.isUserInteractionEnabled = false
        ApiManager.shared.userSignup(user: tempUserInfoHolder, password: password) { (success: Bool, err: ServerError?, user: AppUser?) in
            // hide loader
            self.signupButton.isLoading = false
            self.view.isUserInteractionEnabled = true
            if success {
                self.popOrDismissViewControllerAnimated(animated: true)
            } else {
                self.showMessage(message:(err?.type.errorMessage)!, type: .error)
            }
        }
    }
    
    // MARK: textField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == fullNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            mobileTextField.becomeFirstResponder()
        } else if textField == mobileTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            dateofbirthTextField.becomeFirstResponder()
        } else if textField == dateofbirthTextField {
            addressTextField.becomeFirstResponder()
        }else if textField == addressTextField {
            cityTextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    
    // MARK: DatePicker
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        dateofbirthTextField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }

    
    func doneClick() {
     
        dateofbirthTextField.text = DateHelper.getStringFromDate(datePicker.date)
        dateofbirthTextField.resignFirstResponder()
    }
    func cancelClick() {
        dateofbirthTextField.resignFirstResponder()
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.dateofbirthTextField)
    }

}
