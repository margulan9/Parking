//
//  HistoryViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 3/18/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    var histories: [History] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableHistoryCell")
        histories = [History(parkingZone: "1002", parkedDate: "01/11/20", vehicleNumber: "050 MAR 05", cash: "520"), History(parkingZone: "1002", parkedDate: "01/11/20", vehicleNumber: "050 MAR 05", cash: "520")]
        
       
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableHistoryCell", for: indexPath) as! HistoryTableViewCell
        cell.parkingZoneLabel.text = histories[indexPath.row].parkingZone
        cell.dateLabel.text = histories[indexPath.row].parkedDate
        cell.cashLabel.text = histories[indexPath.row].cash
        cell.vehicleNumberLabel.text = histories[indexPath.row].vehicleNumber
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93.0;
    }
    
}
