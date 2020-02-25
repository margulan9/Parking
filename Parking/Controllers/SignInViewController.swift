//
//  SignInViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 2/4/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailOrPhoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailOrPhoneTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
        passwordTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
    }
        
    @IBAction func signInPressed(_ sender: Any) {
        transitionToTabBar()
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

// MARK: - Signing in an user (Firebase auth and Firestore part)
extension SignInViewController {
    func singIn() {
        indicator.startAnimating()
        if let email = emailOrPhoneTF.text,
            let password = passwordTF.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                self.indicator.stopAnimating()
                
                if let e = error {
                    self.emailOrPhoneTF.text = e.localizedDescription
                    self.emailOrPhoneTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 0.5)
                    self.passwordTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 0.5)
                } else {
                    if Auth.auth().currentUser!.isEmailVerified {
                        self.transitionToTabBar()
                    } else {
                        self.emailOrPhoneTF.text = "Your email is not verified"
                        self.emailOrPhoneTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 0.5)
                        self.passwordTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 0.5)
                    }
                }
            }
        }
    }
    func transitionToTabBar() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
}
