//
//  EditDealViewController.swift
//  GroupApp
//
//  Created by Joe Antongiovanni on 4/28/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

//TODO: Add pictures to edit
//TODO: Add location to edit

import UIKit
import Parse

class EditDealViewController: UIViewController {

    @IBOutlet weak var dealName: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var deal : PFObject!
    var valueViaSegue: Int
        = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = deal["dealName"]
        let description = deal["desc"]
        let business = deal["businessName"]
        
        print(deal)
        dealName.text = name as? String
        desc.text = description as? String
        businessName.text = business as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveDeal(_ sender: Any) {
        let alertController = UIAlertController(title: "Save", message:
            "Are you sure you want to save these edits?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { action in
            self.deal["dealName"] = self.dealName.text
            self.deal["desc"] = self.desc.text
            self.deal["businessName"] = self.businessName.text
            self.deal.saveInBackground()
            print("Successful Save")
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel,handler: { action in
            print("Save cancelled")
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteDeal(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Deal", message:
            "Are you sure you want to delete this deal?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { action in
            self.deal.deleteInBackground()
            print("Successfully Deleted Deal")
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel,handler: { action in
            print("Delete Deal cancelled")
        }))
        self.present(alertController, animated: true, completion: nil)
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
