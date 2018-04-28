//
//  DealCell.swift
//  GroupApp
//
//  Created by Joe Antongiovanni on 4/18/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

import UIKit

class DealCell: UITableViewCell {

    @IBOutlet weak var dealLabel: UILabel!
    @IBOutlet weak var BusName: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dealImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func onTapEdit(_ sender: Any) {
        print("EDIT")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
