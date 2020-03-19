//
//  AccountViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 2/11/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

   
    @IBOutlet weak var vehicleTableViewContstraint: NSLayoutConstraint!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var vehiclesTableView: UITableView!
    @IBOutlet weak var vehicleInformation: UILabel!
    @IBOutlet weak var addVehicleTextField: UITextField!
    @IBOutlet weak var vehicleSubview: UIView!
    @IBOutlet weak var hideView: UIView!
    
    let db = Firestore.firestore()
    var vehicles: [Vehicles] = []
    var newVehicles = Vehicles(vehicleNumber: "")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInfo()
        loadVehicle()
        checkForVehicle()
        
        vehiclesTableView.register(UINib(nibName: "VehicleTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableVehicleCell")
        addVehicleTextField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        hideView.addGestureRecognizer(tap)
    }
    
    @IBAction func addVehiclesPressed(_ sender: Any) {
        changeView(isHidden: false)
    }
    
    @IBAction func addVehicleInsidePressed(_ sender: Any) {
        if addVehicleTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Enter valid vehicle number", message: "", preferredStyle: UIAlertController.Style.alert)
           
            let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        } else {
            changeView(isHidden: true)
            addVehicle()
        }
    }
    
    @IBAction func closeVehicleSubview(_ sender: Any) {
        changeView(isHidden: true)
    }
    
    @IBAction func walletPressed(_ sender: Any) {
    }
    
    @IBAction func historyPressed(_ sender: Any) {
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        logOut()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
           changeView(isHidden: true)
    }
    
    func changeView(isHidden: Bool) {
        vehicleSubview.isHidden = isHidden
        hideView.isHidden = isHidden
    }
}

// MARK: - Loading information from database log out from user session (Firebase/Firestore part)
extension AccountViewController {
    func logOut() {
        do {
            try Auth.auth().signOut()
            showMessage(title: "Are you sure you want to logout?", message: "")
        } catch let logOutError as NSError {
            print("Log out error: ", logOutError)
        }
    }
    func loadInfo(){
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("there was an issue retrieving the data\(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if Auth.auth().currentUser?.email == data["user-email"] as? String{
                            if let userEmail = data["user-email"] as? String {
                                self.emailLabel.text = userEmail
                            }
                        }
                    }
                }
            }
        }
    }
    func addVehicle() {
        
        if let currentUser = Auth.auth().currentUser?.email,
            let userVehicleNumber = addVehicleTextField.text {
            db.collection("vehicles").addDocument(data: [
                "user-email" : currentUser,
                "vehicle-number": userVehicleNumber
            ]) { (error) in
                if let e = error {
                    print("there was an issue saving data to firestore, \(e)")
                } else {
                    print("successfully saved data")
                    self.checkForVehicle()
                }
            }
        }
    }
    func loadVehicle() {
        db.collection("vehicles").addSnapshotListener { (querySnapshot, error) in
            self.vehicles = []
            
            if let e = error {
                print("there was an issue retrieving the data\(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if Auth.auth().currentUser?.email == data["user-email"] as? String{
                            if let vehicleNumber = data["vehicle-number"] as? String {
                                let newVehicle = Vehicles(vehicleNumber: vehicleNumber)
                                self.vehicles.append(newVehicle)
                                self.checkForVehicle()
                                print(self.vehicles)
                                DispatchQueue.main.async {
                                    self.vehiclesTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteVehicle(message: String) {
        let collectionReference = db.collection("vehicles")
        let query:Query = collectionReference.whereField("vehicle-number", isEqualTo: message)
        query.getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print("ERRRRORRRRRR \(error.localizedDescription)")
            } else {
                for document in snapshot!.documents {
                    self.db.collection("vehicles").document("\(document.documentID)").delete()
                }
            }})
        
    }

    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            if title != "Error" {
                self.transitionToMain()
            }
        }
        let no = UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    func transitionToMain() {
           
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
           let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! ViewController
           nextViewController.modalPresentationStyle = .fullScreen
           self.present(nextViewController, animated:true, completion:nil)
    }
    func checkForVehicle() {
        if vehicles.isEmpty {
            vehicleInformation.text = "Currently you have no Vehicles, add new one"
        } else {
            vehicleInformation.text = "Vehicles"
        }
    }
}

// MARK: - TableView part
extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableVehicleCell", for: indexPath) as! VehicleTableViewCell
        cell.vehicleNumberLabel.text = vehicles[indexPath.row].vehicleNumber
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("delete this one ")
        print(vehicles)
        if editingStyle == .delete {
            deleteVehicle(message: vehicles[indexPath.row].vehicleNumber)
            self.vehicles.remove(at: indexPath.row)
            self.vehiclesTableView.deleteRows(at: [indexPath], with: .automatic)
            checkForVehicle()
        }
    }    
}

// MARK: - Changing content size of tableView
extension AccountViewController {
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vehiclesTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.vehiclesTableView.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){

            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.vehicleTableViewContstraint.constant = newsize.height
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension AccountViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.05098039216, green: 0.7137254902, blue: 0.3960784314, alpha: 1), width: 0.5)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6666666667, green: 0.7137254902, blue: 0.7647058824, alpha: 1), width: 0.5)
    }
}
