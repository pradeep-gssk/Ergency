//
//  EGLoginViewController.swift
//  Ergency
//
//  Created by Guduru, Pradeep(AWF) on 1/8/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

class EGLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.desginView()
        self.passwordTextField.desginView()
    }
    
    @IBAction func didTapSignInButton(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: USER_PROFILE_DATA)
        appDelegate.showHomeView()
    }
}
