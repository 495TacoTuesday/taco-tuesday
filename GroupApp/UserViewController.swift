//
//  UserViewController.swift
//  GroupApp
//
//  Created by Joe Antongiovanni on 4/16/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

import UIKit
import Parse

class UserViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var addDealButton: UIButton!
    @IBOutlet weak var removeDealButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingLabel.text = "Hello " + (PFUser.current()?.username)!
        print(PFUser.current()?.objectId)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Logout", message:
            "Are you sure you want to logout of your account?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { action in
            PFUser.logOutInBackground()
            print("Successful Logout")
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel,handler: { action in
            print("Logout cancelled")
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapDelete(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Delete Account", message:
            "Are you sure you want to delete your account?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { action in
            //
            //
            //implement
            //PFUser.deleteeverything
            //2 step authentication? re-enter password
            //
            print("Successfully Deleted User Account")
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel,handler: { action in
            print("Delete Account cancelled")
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
