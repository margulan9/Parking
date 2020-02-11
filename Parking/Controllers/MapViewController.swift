//
//  MapViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 2/10/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var totalPlacesLabel: UILabel!
    @IBOutlet weak var availablePlacesLabel: UILabel!
    @IBOutlet weak var parkingZoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.backgroundColor = .clear
        stopButton.layer.cornerRadius = 5
        stopButton.layer.borderWidth = 1
        stopButton.layer.borderColor = #colorLiteral(red: 0.05098039216, green: 0.7137254902, blue: 0.3960784314, alpha: 1)

        // Do any additional setup after loading the view.
    }
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        setView(view: infoView, hidden: false)
    }
    @IBAction func closePressed(_ sender: Any) {
        setView(view: infoView, hidden: true)
    }
    @IBAction func parkPressed(_ sender: Any) {
    }
    @IBAction func stopPressed(_ sender: Any) {
    }
    @IBAction func vehicleNumberPressed(_ sender: Any) {
    }
    
}
