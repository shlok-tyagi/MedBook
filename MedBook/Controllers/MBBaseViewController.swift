//
//  ViewController.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import UIKit

class MBBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: MBLandingPageViewController.storyboardID) as? MBLandingPageViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

