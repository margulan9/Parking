//
//  WalletViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 3/3/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import Firebase

class WalletViewController: UIViewController {

    @IBOutlet weak var currentWalletView: UIView!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var addCreditCardView: UIView!
    @IBOutlet weak var creditCardNumberLabel: UILabel!
    
    @IBOutlet weak var creditCardNumber: UITextField!
    @IBOutlet weak var creditCardFullName: UITextField!
    @IBOutlet weak var creditCardMonth: UITextField!
    @IBOutlet weak var creditCardYear: UITextField!
    @IBOutlet weak var creditCardCVC: UITextField!
    @IBOutlet weak var hideView: UIView!
    
    @IBOutlet weak var chooseCardView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData: [String] = []
    
    let db = Firestore.firestore()

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
        
        loadInfo()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        hideView.addGestureRecognizer(tap)
              
    }
    
    @IBAction func backgroundBtnClicked(_ sender: Any) {
        backgroundBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        changeView(isHidden: false)
    }
    @IBAction func backgroundBtnReleased(_ sender: Any) {
        backgroundBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    @IBAction func addPressed(_ sender: Any) {
        addCreditCardView.isHidden = false
        
    }
    @IBAction func insideAddPressed(_ sender: Any) {
        addCreditCard()
        
    }
    @IBAction func insideClosePressed(_ sender: Any) {
        self.addCreditCardView.isHidden = true
    }
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func choosePressed(_ sender: Any) {
        let selectedValue = pickerData[pickerView.selectedRow(inComponent: 0)]
        creditCardNumberLabel.text = selectedValue
    }
    @IBAction func closeChoosePressed(_ sender: Any) {
        changeView(isHidden: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
           changeView(isHidden: true)
    }
    
    func changeView(isHidden: Bool) {
        chooseCardView.isHidden = isHidden
        hideView.isHidden = isHidden
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
    func clearTextField() {
        creditCardYear.text = ""
        creditCardMonth.text = ""
        creditCardFullName.text = ""
        creditCardCVC.text = ""
        creditCardNumber.text = ""
    }
   
}

extension WalletViewController {
    
    func addCreditCard() {
        if let currentUser = Auth.auth().currentUser?.email,
            let userCreditCardNumber = creditCardNumber.text, !userCreditCardNumber.isEmpty,
            let userCreditCardFullName = creditCardFullName.text, !userCreditCardFullName.isEmpty,
            let userCreditCardMonth = creditCardMonth.text, !userCreditCardMonth.isEmpty,
            let userCreditCardYear = creditCardYear.text, !userCreditCardYear.isEmpty {
            
            db.collection("credit-cards").addDocument(data: [
                "user-email" : currentUser,
                "credit-card-number" : userCreditCardNumber,
                "credit-card-fullname" : userCreditCardFullName,
                "credit-card-month" : userCreditCardMonth,
                "credit-card-year" : userCreditCardYear
            ]) {(error) in
                if let e = error {
                    print("there was an issue saving data to firestore, \(e)")
                } else {
                    print("successfully saved data")
                    self.showMessage(title: "Successfully saved credit card", message: "Now you can choose it if you want")
                    self.addCreditCardView.isHidden = true
                    self.clearTextField()
                }
        }
        } else {
            showMessage(title: "Please fill in all fields", message: "")
           
        }

    }
    
    func loadInfo() {
        db.collection("credit-cards").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("there was an issue retrieving the data \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if Auth.auth().currentUser?.email == data["user-email"] as? String {
                            if let creditCardNumber = data["credit-card-number"] as? String {
                                self.pickerData.append(creditCardNumber)
                                DispatchQueue.main.async {
                                    self.pickerView.reloadAllComponents()
                                }
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
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension WalletViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return pickerData[row]
       }
    
    
    
}

 
