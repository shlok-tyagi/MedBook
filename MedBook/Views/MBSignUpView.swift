//
//  MBSignUpView.swift
//  MedBook
//
//  Created by Shlok Tyagi on 30/12/23.
//

import UIKit
import Combine

protocol MBSignUpViewDelegate: AnyObject{
    func popViewController()
    func pushViewController()
    func presentAlert(with text: String)
}

class MBSignUpView: UIView {
    
    public var delegate: MBSignUpViewDelegate?
    
    private var cancellable : AnyCancellable?

    private let viewModel = MBSignUpViewModel()
    
    private let checkIcon = UIImage.init(systemName: "square.fill")
    private let uncheckIcon = UIImage.init(systemName: "square")
    
    private var passwordFieldAllRequirementsMet = false
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    
    @IBOutlet private var minCharsCheckBox: UIImageView!
    @IBOutlet private var oneNumCheckBox: UIImageView!
    @IBOutlet private var oneUppercaseCheckBox: UIImageView!
    @IBOutlet private var specialCharCheckBox: UIImageView!
    
    @IBOutlet private var pickerView: UIPickerView!

    @IBOutlet private var signUpButton: UIButton!

    public func setupView(){
        
        viewModel.delegate = self
    
        pickerView.delegate = viewModel
        pickerView.dataSource = viewModel
        pickerView.isHidden = true
        
        minCharsCheckBox.image = uncheckIcon
        oneNumCheckBox.image = uncheckIcon
        oneUppercaseCheckBox.image = uncheckIcon
        specialCharCheckBox.image = uncheckIcon
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.clipsToBounds = true
        signUpButton.backgroundColor = .white
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.setTitleColor(.gray, for: .disabled)
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.borderWidth = 2
         
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
        
        setupTextFieldListener()
        
        ///Call to populate picker
        viewModel.fetchCountries()
        
    }
    
    /// Catch textDidChangeNotification
    private func setupTextFieldListener(){
        cancellable = passwordTextField.textPublisher
            .sink { [weak self] password in
                self?.passwordFieldAllRequirementsMet = self?.viewModel.evaluatePassword(password) ?? false
            }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        delegate?.popViewController()
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        
        // Validate both email and password before saving
        if let email = emailTextField.text,
           let password = passwordTextField.text,
           viewModel.evaluateEmail(email)
            && passwordFieldAllRequirementsMet{
            
            viewModel.storeCredentials(email: email,
                                       password: password,
                                       pickerIndex: pickerView.selectedRow(inComponent: 0))
            delegate?.pushViewController()
            
        }else{
            delegate?.presentAlert(with: "Please enter all the fields.")
        }
        
    }
    
    @objc private func dismissKeyboard(){
        self.endEditing(true)
    }
    
}

// MARK: MBSignUpViewModelDelegate Methods

extension MBSignUpView: MBSignUpViewModelDelegate{
    
    func setMinCharsCheckBox(_ value: Bool) {
        minCharsCheckBox.image = value ? checkIcon : uncheckIcon
    }
    
    func setOneNumCheckBox(_ value: Bool) {
        oneNumCheckBox.image = value ? checkIcon : uncheckIcon
    }
    
    func setOneUppercaseCheckBox(_ value: Bool) {
        oneUppercaseCheckBox.image = value ? checkIcon : uncheckIcon
    }
    
    func setSpecialCharCheckBox(_ value: Bool) {
        specialCharCheckBox.image = value ? checkIcon : uncheckIcon
    }
    
    func reloadCountries() {
        pickerView.reloadAllComponents()
        pickerView.isHidden = false
    }
}

