//
//  MBSignUpViewController.swift
//  MedBook
//
//  Created by Shlok Tyagi on 30/12/23.
//

import UIKit

class MBSignUpViewController: UIViewController {
    
    static let storyboardID = "MBSignUpViewController"
    
    @IBOutlet weak var signUpView: MBSignUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        signUpView.delegate = self
        signUpView.setupView()
    }
}

// MARK: MBSignUpViewDelegate methods

extension MBSignUpViewController: MBSignUpViewDelegate{
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: MBLoginViewController.storyboardID) as? MBLoginViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentAlert(with text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { action in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
}
