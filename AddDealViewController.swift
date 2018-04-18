//
//  AddDealViewController.swift
//  GroupApp
//
//  Created by Honorio Vega on 4/18/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

import UIKit

class AddDealViewController: UIViewController {
    
    
    @IBOutlet weak var dealNameTextField: UITextField!
    
    @IBOutlet weak var businessNameTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func didTapAddDeal(_ sender: Any) {
        
        let dealName = dealNameTextField.text ?? ""
        
        let businessName = businessNameTextField.text ?? ""

        let description = descriptionTextField.text ?? ""


        let alertController = UIAlertController(title: "Sucess", message: "Deal added successfully", preferredStyle: .alert)

        
        let tryAgainAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        
        alertController.addAction(tryAgainAction)
        

        
        // add the OK action to the alert controller
        // Do any additional setup after loa
        
        Deal.postUserDeal(dealName : dealName,buisnessName: businessName,description : description,latt : 100.0,long : 100.0) { (success : Bool, error : Error?) in
            
            if success {
                print("it worked")
                
                self.present(alertController, animated: true) {
                    
                }
//                self.present(self.alertController, animated: true) {
//
//                }
            }
        }
            
        }
    
    
}
