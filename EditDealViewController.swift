//
//  EditDealViewController.swift
//  GroupApp
//
//  Created by Joe Antongiovanni on 4/28/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

import UIKit
import Parse

class EditDealViewController: UIViewController {

    var deal : PFObject!
    var valueViaSegue: Int
        = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print(valueViaSegue)
        print(deal["dealName"])
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
