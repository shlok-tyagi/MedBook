//
//  Extensions.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import UIKit
import Combine

extension UITextField{
    
    /// Listener to textDidChangeNotification
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
    
    /// Padding to include icon in TextField
    func addLeadingPaddingToTextField(){
        let leftView = UIView.init(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        self.leftView = leftView;
        self.leftViewMode = .always
    }
}
