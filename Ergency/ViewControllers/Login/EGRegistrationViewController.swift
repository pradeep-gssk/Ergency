//
//  EGRegistrationViewController.swift
//  Ergency
//
//  Created by Guduru, Pradeep(AWF) on 2/18/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

class EGRegistrationViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "backBlue")?.withRenderingMode(.alwaysTemplate)
        self.backButton.setImage(image, for: .normal)
        self.backButton.tintColor = UIColor.white
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

class EGRegistrationTableViewController: UITableViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameTextField.desginView()
        self.lastNameTextField.desginView()
        self.dobTextField.desginView(left: 14, right: 11)
        self.genderTextField.desginView(left: 13, right: 6)
        self.emailTextField.desginView()
        self.passwordTextField.desginView()
        
        self.dobTextField.inputView = self.datePicker
        self.genderTextField.inputView = self.pickerView
        
        self.datePicker.maximumDate = Date()
    }
    
    @IBAction func didChangeDatePickerValue(_ sender: Any) {
        
    }
    
    @IBAction func didTapSubmitButton(_ sender: Any) {
    }
}
