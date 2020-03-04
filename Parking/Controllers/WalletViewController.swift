//
//  WalletViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 3/3/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var currentWalletView: UIView!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var addCreditCardView: UIView!
    
    @IBOutlet weak var creditCardNumber: UITextField!
    @IBOutlet weak var creditCardFullName: UITextField!
    @IBOutlet weak var creditCardMonth: UITextField!
    @IBOutlet weak var creditCardYear: UITextField!
    @IBOutlet weak var creditCardCVC: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadow(toView: currentWalletView)
        addShadow(toView: addCreditCardView)
        
        addBorder(toTextField: creditCardNumber, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1))
        addBorder(toTextField: creditCardFullName, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1))
        addBorder(toTextField: creditCardMonth, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1))
        addBorder(toTextField: creditCardYear, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1))
        addBorder(toTextField: creditCardCVC, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1))
        
        creditCardNumber.setLeftPaddingPoints(5)
        creditCardFullName.setLeftPaddingPoints(5)
        
        
        

    }
    
    @IBAction func backgroundBtnClicked(_ sender: Any) {
        backgroundBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    @IBAction func backgroundBtnReleased(_ sender: Any) {
        backgroundBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    @IBAction func addPressed(_ sender: Any) {
         addCreditCardView.isHidden = false
    }
    @IBAction func insideAddPressed(_ sender: Any) {
        addCreditCardView.isHidden = true
    }
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func addShadow(toView: UIView) {
        toView.layer.shadowColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        toView.layer.shadowOpacity = 1
        toView.layer.shadowOffset = .zero
        toView.layer.shadowRadius = 10
    }
    func addBorder(toTextField: UITextField, color: CGColor) {
        toTextField.layer.borderWidth = 0.5
        toTextField.layer.borderColor = color
        toTextField.layer.cornerRadius = 5
    }

}
extension WalletViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        addBorder(toTextField: textField, color: #colorLiteral(red: 0.05098039216, green: 0.7137254902, blue: 0.3960784314, alpha: 1))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        addBorder(toTextField: textField, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1))
    }
   
}

