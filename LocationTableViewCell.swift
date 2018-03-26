//
//  LocationTableViewCell.swift
//  GroupApp
//
//  Created by Samba on 3/26/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//


import UIKit
import AFNetworking

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var location: NSDictionary! {
        didSet {
            nameLabel.text = location["name"] as? String
            addressLabel.text = location.value(forKeyPath: "location.address") as? String
            
            let categories = location["categories"] as? NSArray
            if (categories != nil && categories!.count > 0) {
                let category = categories![0] as! NSDictionary
                let urlPrefix = category.value(forKeyPath: "icon.prefix") as! String
                let urlSuffix = category.value(forKeyPath: "icon.suffix") as! String
                
                let url = "\(urlPrefix)bg_32\(urlSuffix)"
                categoryImageView.setImageWith(URL(string: url)!)
            }
        }
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

