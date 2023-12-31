//
//  MBLoginView.swift
//  MedBook
//
//  Created by Shlok Tyagi on 30/12/23.
//

import UIKit
import Combine

protocol MBLoginViewDelegate: AnyObject{
    func popViewController()
    func pushViewController()
    func presentAlert(with text: String)
}

class MBLoginView: UIView {
    
    public var delegate: MBLoginViewDelegate?
    
    private let viewModel = MBLoginViewModel()
    
    private var emailCancellable : AnyCancellable?
    private var passwordCancellable : AnyCancellable?
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    @IBOutlet private var loginButton: UIButton!
    
    
    public func setupView(){
        
        viewModel.delegate = self
        
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.backgroundColor = .white
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.setTitleColor(.gray, for: .disabled)
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.borderWidth = 2
        loginButton.isEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
        
        setupTextFieldListeners()
    }
    
    
    /// Catch textDidChangeNotification 
    private func setupTextFieldListeners(){
        emailCancellable = emailTextField.textPublisher
            .sink { [weak self] _ in
                self?.updatedLoginButtonStatus()
            }
        
        passwordCancellable = passwordTextField.textPublisher
            .sink { [weak self] _ in
                self?.updatedLoginButtonStatus()
            }
    }
    
    /// Enables or disables login button based on if both email and
    /// password fields are empty or not
    private func updatedLoginButtonStatus(){
        
        if emailTextField.text != ""
            && passwordTextField.text != ""
        {
            loginButton.isEnabled = true
        }else{
            loginButton.isEnabled = false
        }
        
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        guard let password = passwordTextField.text,
              let email = emailTextField.text else {
            return
        }
        
        viewModel.loginWithCredentials(email: email,
                                       password: password)
        
    }
    
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        delegate?.popViewController()
    }
    
    @objc private func dismissKeyboard(){
        self.endEditing(true)
    }
    
}

// MARK: MBLoginViewModelDelegate Methos

extension MBLoginView: MBLoginViewModelDelegate{
    
    func presentAlert(with text: String) {
        delegate?.presentAlert(with: text)
    }
    
    func loginSuccessful() {
        delegate?.pushViewController()
    }
    
}

