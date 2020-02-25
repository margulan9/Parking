//
//  AccountViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 2/11/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

   
    @IBOutlet weak var vehicleTableViewContstraint: NSLayoutConstraint!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var vehiclesTableView: UITableView!
    @IBOutlet weak var vehicleInformation: UILabel!
    
    var vehicles: [Vehicles] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vehicles = [Vehicles(vehicleNumber: "222 IUI 01"), Vehicles(vehicleNumber: "212 IUI 03")]

        vehiclesTableView.register(UINib(nibName: "VehicleTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableVehicleCell")
    }
    
    @IBAction func addVehiclesPressed(_ sender: Any) {
    }
    
    @IBAction func walletPressed(_ sender: Any) {
    }
    @IBAction func historyPressed(_ sender: Any) {
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
    }
}

// MARK: - TableView part
extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vehicles.count
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
      if editingStyle == .delete {
        self.vehicles.remove(at: indexPath.row)
        self.vehiclesTableView.deleteRows(at: [indexPath], with: .automatic)
        if vehicles.isEmpty {
            vehicleInformation.text = "Currently you have no Vehicles, add new one"
        } else {
            vehicleInformation.text = "Vehicles"
        }
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
