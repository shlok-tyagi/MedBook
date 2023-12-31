//
//  MBCredentialsManager.swift
//  MedBook
//
//  Created by Shlok Tyagi on 30/12/23.
//

import UIKit

enum CustomError: String, Error {
    case noStoredCredentials = "No stored credentials. Please Sign Up."
}

class MBCredentialsManager{
    
    static let shared = MBCredentialsManager()
    
    private let emailKey = "MB_EMAIL_CREDENTIAL"
    
    private let passwordKey = "MB_PASSWORD_CREDENTIAL"

    private let countryCodeKey = "MB_USER_COUNTRY_CODE"

    private init() {
        
    }
    
    
    /// Store credentials
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    ///   - countryCode: user country code
    public func saveCredentials(email: String,
                                password: String,
                                countryCode: String){
        
        // TODO: Save credentials in a more secure way
        
        UserDefaults.standard.set(email, forKey: emailKey)
        UserDefaults.standard.set(password, forKey: passwordKey)
        UserDefaults.standard.set(countryCode, forKey: countryCodeKey)
        print("Your saved credentials are")
        print("Email: \(email)")
        print("Password: \(password)")
        
    }
    
    
    /// Matches credentials against stored values
    /// - Parameters:
    ///   - email: user entered email
    ///   - password: user entered password
    ///   - completion: callback
    public func checkCredentials(email: String,
                                 password: String,
                                 completion: (Result<Bool,CustomError>) -> Void){
        
        guard let userEmail = UserDefaults.standard.object(forKey: emailKey) as? String,
              let userPassword = UserDefaults.standard.object(forKey: passwordKey) as? String
        else{
            completion(.failure(.noStoredCredentials))
            return
        }
        
        if (email == userEmail)
            && (password == userPassword)
        {
            completion(.success(true))
        }else{
            completion(.success(false))
        }
        
    }
    
}

