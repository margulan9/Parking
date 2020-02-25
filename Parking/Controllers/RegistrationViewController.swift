//
//  RegistrationViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 2/4/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    
    @IBOutlet weak var emailOrPhoneTF: UITextField!
    @IBOutlet weak var vehicleNumberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailOrPhoneTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
        vehicleNumberTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
        passwordTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        registerUser()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.05098039216, green: 0.7137254902, blue: 0.3960784314, alpha: 1), width: 0.5)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
    }
}
// MARK: - Registering an user (Firebase auth and Firestore part)
extension RegistrationViewController {
    func registerUser() {
        indicator.startAnimating()
        
        if let email = emailOrPhoneTF.text,
            let password = passwordTF.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                self.indicator.stopAnimating()
                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                
                if let e = error {
                    self.emailOrPhoneTF.text = e.localizedDescription
                    self.emailOrPhoneTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 0.5)
                    self.passwordTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 0.5)
                    self.vehicleNumberTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 0.5)
                } else {
                    self.showMessage(title: "Successfully registered an acoount", message: "Please, verify your email")
                    if let userEmailOrPhone = Auth.auth().currentUser?.email,
                        let userVehicleNumber = self.vehicleNumberTF.text {
                        self.db.collection("users").addDocument(data: [
                            "user-emailOrPhone" : userEmailOrPhone,
                            "user-vehicleNumber" : userVehicleNumber
                        ]) { (error) in
                            if let e = error {
                                print(e.localizedDescription)
                            } else {
                                print("successfully saved data")
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            if title != "Error" {
                self.transitionToSignIn()
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    func transitionToSignIn() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
}
