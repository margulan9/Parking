//
//  SignInViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 2/4/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailOrPhoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailOrPhoneTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
        passwordTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
    }
    
    @IBAction func signInPressed(_ sender: Any) {
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.05098039216, green: 0.7137254902, blue: 0.3960784314, alpha: 1), width: 0.5)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
    }
}
