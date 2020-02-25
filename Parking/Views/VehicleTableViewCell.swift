//
//  VehicleTableViewCell.swift
//  Parking
//
//  Created by Sugirbay Margulan on 2/24/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var vehicleNumberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
