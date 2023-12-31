//
//  MBLoginViewModel.swift
//  MedBook
//
//  Created by Shlok Tyagi on 30/12/23.
//

import UIKit

protocol MBLoginViewModelDelegate: AnyObject{
    func presentAlert(with text: String)
    func loginSuccessful()
}

class MBLoginViewModel{
    
    public var delegate: MBLoginViewModelDelegate?
    
    public func loginWithCredentials(email: String, password: String){
        
        MBCredentialsManager.shared.checkCredentials(email: email,
                                                     password: password) { result in
            
            switch result{
                
            case .success(let loginAllowed):
                
                switch loginAllowed{
                case true:
                    delegate?.loginSuccessful()
                case false:
                    delegate?.presentAlert(with: "Wrong Credentials")
                }
                
            case .failure(let error):
                delegate?.presentAlert(with: error.rawValue)
            }
        }
        
    }
    
}
