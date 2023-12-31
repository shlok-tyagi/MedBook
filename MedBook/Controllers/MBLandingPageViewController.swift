//
//  MBLandingPageViewController.swift
//  MedBook
//
//  Created by Shlok Tyagi on 30/12/23.
//

import UIKit

class MBLandingPageViewController: UIViewController {

    static let storyboardID = "MBLandingPageViewController"

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLayoutSubviews() {
        
        signupButton.backgroundColor = .white
        signupButton.setTitleColor(.black, for: .normal)
        signupButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        signupButton.layer.cornerRadius = 10
        signupButton.clipsToBounds = true
        signupButton.layer.borderWidth = 2
        signupButton.layer.borderColor = UIColor.black.cgColor
        
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func signupButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: MBSignUpViewController.storyboardID) as? MBSignUpViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: MBLoginViewController.storyboardID) as? MBLoginViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
