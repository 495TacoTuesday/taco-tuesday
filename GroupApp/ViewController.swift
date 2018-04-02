//
//  ViewController.swift
//  GroupApp
//
//  Created by Joe Antongiovanni on 3/7/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
   
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    let alertController = UIAlertController(title: "Invalid Login", message: "Incorrect username or password.", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tryAgainAction = UIAlertAction(title: "ok", style: .default) { (action) in
           
        }
        
        alertController.addAction(tryAgainAction)
        // add the OK action to the alert controller
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                self.present(self.alertController, animated: true) {
                    
                }
            } else {
                print("User logged in successfully")
                // manually segue to logged in view
                self.performSegue(withIdentifier: "loggedIn", sender: nil)
            }
        }
    }

    @IBAction func onSignup(_ sender: Any) {
       
        //self.performSegue(withIdentifier: "loggedIn", sender: nil)
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                self.performSegue(withIdentifier: "loggedIn", sender: nil)
            }
        }
    }
    
    
}

