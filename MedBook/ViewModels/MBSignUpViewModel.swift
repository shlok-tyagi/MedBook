//
//  MBSignUpViewModel.swift
//  MedBook
//
//  Created by Shlok Tyagi on 30/12/23.
//

import UIKit

struct CountryArrayElement{
    var countryCode: String
    var countryName: String
}

protocol MBSignUpViewModelDelegate{
    func setMinCharsCheckBox(_ value: Bool)
    func setOneNumCheckBox(_ value: Bool)
    func setOneUppercaseCheckBox(_ value: Bool)
    func setSpecialCharCheckBox(_ value: Bool)
    func reloadCountries()
}

class MBSignUpViewModel: NSObject{

    public var delegate: MBSignUpViewModelDelegate?
    
    private var countryArray: [CountryArrayElement] = []
    
    public func fetchCountries(){
        
        let request = MBRequest(baseURL: .country,
                                queryParameters: [])
        
        MBService.shared.execute(request,
                                 expecting: MBCountryResult.self) {[weak self] result in
            
            guard let strongSelf = self else{
                return
            }
            
            switch result{
                
            case .success(let countryResult):
                
                let countries = countryResult.data
                
                /// Parse MBCountryResult data
                for key in countries.keys{
                    if let name = countries[key]?.name{
                        let element = CountryArrayElement(countryCode: key,
                                                          countryName: name)
                        strongSelf.countryArray.append(element)
                    }
                }
                
                /// Sort by name
                strongSelf.countryArray = strongSelf.countryArray.sorted(by: { lhs, rhs in
                    lhs.countryName < rhs.countryName
                })
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.reloadCountries()
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
            
        }
        
    }
    
    public func evaluateEmail(_ email: String) -> Bool{
        
        if email == "" {
            return false
        }
        
        let regex = ".*@.*\\..*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluate(with: email){
            return true
        }else{
            return  false
        }
    }

    public func evaluatePassword(_ password: String) -> Bool{
        
        var allRequirementsMet = true
        
        delegate?.setMinCharsCheckBox(false)
        delegate?.setOneNumCheckBox(false)
        delegate?.setOneUppercaseCheckBox(false)
        delegate?.setSpecialCharCheckBox(false)
        
        if password.count > 7{
            delegate?.setMinCharsCheckBox(true)
        }else{
            allRequirementsMet = false
        }
        
        let numRegex = ".*[0-9].*"
        let numPredicate = NSPredicate(format: "SELF MATCHES %@", numRegex)
        if numPredicate.evaluate(with: password){
            delegate?.setOneNumCheckBox(true)
        }else{
            allRequirementsMet = false
        }
        
        let uppercaseRegex = ".*[A-Z]+.*"
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
        if uppercasePredicate.evaluate(with: password){
            delegate?.setOneUppercaseCheckBox(true)
        }else{
            allRequirementsMet = false
        }
        
        let specialCharRegex = ".*[^A-Za-z0-9].*"
        let specialCharPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharRegex)
        if specialCharPredicate.evaluate(with: password){
            delegate?.setSpecialCharCheckBox(true)
        }else{
            allRequirementsMet = false
        }
        
        return allRequirementsMet
        
    }
    
    public func storeCredentials(email: String,
                                 password: String,
                                 pickerIndex: Int){
        MBCredentialsManager.shared.saveCredentials(email: email,
                                                    password: password,
                                                    countryCode: self.countryArray[pickerIndex].countryCode)
    }
    
}

// MARK: UIPickerView delegate & datasource methods

extension MBSignUpViewModel: UIPickerViewDataSource,UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryArray[row].countryName
    }
    
}

