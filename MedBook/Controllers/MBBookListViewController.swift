//
//  ViewControllerOne.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import UIKit

class MBBookListViewController: UIViewController {

    static let storyboardID = "MBBookListViewController"
    
    @IBOutlet weak var bookListView: MBBookListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        bookListView.setupView()
    }

}
