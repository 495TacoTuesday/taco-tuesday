//
//  DealDetailViewController.swift
//  GroupApp
//
//  Created by Joe Antongiovanni on 4/2/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

import UIKit

class DealDetailViewController: UIViewController {

    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageFour: UIImageView!
    @IBOutlet weak var imageFive: UIImageView!
    @IBOutlet weak var dealLabel: UILabel!
    @IBOutlet weak var dealAddress: UILabel!
    @IBOutlet weak var dealDistance: UILabel!
    
    //--ToDo Call and Directions
    // grab number from foursquare, pass location to maps
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
