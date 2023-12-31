//
//  MBLoginViewController.swift
//  MedBook
//
//  Created by Shlok Tyagi on 30/12/23.
//

import UIKit

class MBLoginViewController: UIViewController {

    static let storyboardID = "MBLoginViewController"
    
    @IBOutlet weak var loginView: MBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        loginView.delegate = self
        loginView.setupView()
    }

}

// MARK: MBLoginViewDelegate methods

extension MBLoginViewController: MBLoginViewDelegate{
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: MBBookListViewController.storyboardID) as? MBBookListViewController {
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
