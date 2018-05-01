//
//  AddDealViewController.swift
//  GroupApp
//
//  Created by Honorio Vega on 4/18/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

//take coordinates from 4square and put them in the lat long fields

import UIKit

class AddDealViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate,LocationsViewControllerDelegate {
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        latField.text = String(latitude.doubleValue)
        lonField.text = String(longitude.doubleValue)
        print("got in")
        checkEmptyMain()
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    var vc: UIImagePickerController!
    var pics: [UIImage] = []
    var dealID : String?
    @IBOutlet weak var addressView: UITextView!
    @IBOutlet weak var dealNameTextField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var lonField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var picView1: UIImageView!
    @IBOutlet weak var picView2: UIImageView!
    @IBOutlet weak var picView3: UIImageView!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBAction func checkEmpty(_ sender: Any) {
       checkEmptyMain()
    }
    func checkEmptyMain() -> Void {
        if(latField.text != "" && latField.text != nil && lonField.text != "" && lonField.text != nil){
            addButton.isEnabled = true
            addButton.backgroundColor = UIColor.blue
        }
        else{
            addButton.isEnabled = false
            addButton.backgroundColor = UIColor.lightGray
        }
    }
    
    @IBAction func enterAddress(_ sender: Any) {
        self.performSegue(withIdentifier: "findAddress", sender: nil)
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        selPic()
    }
    
    func fillPicViews() {
        if(pics.count == 1){
            picView1.image = pics[0]
        }
        else if(pics.count == 2){
            picView1.image = pics[0]
            picView2.image = pics[1]
        }
        else if(pics.count == 3){
            picView1.image = pics[0]
            picView2.image = pics[1]
            picView3.image = pics[2]
        }
        
    }
    func selPic(){
        vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        // Do any additional setup after loading the view.
        self.present(vc, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = resize(image: originalImage, newSize: CGSize(width: 300, height: 300))
        pics.append(editedImage)
        fillPicViews()
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        
    }
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    @IBAction func didTapAddDeal(_ sender: Any) {
        
        let dealName = dealNameTextField.text ?? ""
        
        let businessName = businessNameTextField.text ?? ""
        
        let description = descriptionTextField.text ?? ""
        
        let lattitude = NumberFormatter().number(from: latField.text!)?.doubleValue
        
        let longitude = NumberFormatter().number(from: lonField.text!)?.doubleValue
        
        let alertController = UIAlertController(title: "Sucess", message: "Deal added successfully", preferredStyle: .alert)
        
        
        let tryAgainAction = UIAlertAction(title: "Ok", style: .default) { (action) in
             self.performSegue(withIdentifier: "returnHome", sender: self)
        }
        alertController.addAction(tryAgainAction)
        
        
        // add the OK action to the alert controller
        // Do any additional setup after loa
        Deal.postUserDeal(dealName : dealName,buisnessName: businessName,description : description,latt : lattitude! ,long :  longitude!, withCompletion: { (success : Bool, error : Error?) in
            if success {
                print("it worked")
                
                
                let query = Deal.query()
                query?.limit = 1
                query?.order(byDescending: "_created_at")
                //query?.whereKey("lat", equalTo: lattitude)
               // query?.whereKey("lon", equalTo: longitude)
                query?.whereKey("desc", equalTo: description)
                query?.whereKey("businessName", equalTo: businessName)
                query?.whereKey("dealName", equalTo: dealName)
                // fetch data asynchronously
                query?.findObjectsInBackground(block: { (deals, error) in
                    if  deals != nil {
                        // do something with the data fetched
                        var dealz = deals as! [Deal]
                        print("before print" )
                        print(dealz)
                        print("before access")
                        //THIS DOESNT CHECK IF THERE IS NOTHING RETURNEDE, IF THIS CRASHES HERE THEN NOTHING IS BEING RETURNED FROM THE QUERY
                        self.dealID = dealz[0].objectId
                        print("after")
                        print("got recently posted deal id: " + self.dealID!)
                        
                        print("about to post images")
                        for i in self.pics
                        {
                            Image.postDealImage(deal_id: self.dealID!, toPostImage: i, withCompletion: { (success : Bool, error : Error?) in
                                
                                if success {
                                    print("Added image")
                                }
                                else{
                                    print("error")
                                    print(error?.localizedDescription as Any)
                                }
                                
                            })
                        }
                        self.present(alertController, animated: true) {
                            //WE WANT TO BE TAKEN TO THE HOME SCREEN AND THE LOCATION WHERE THE DEAL WAS ADDED AFTER WE ADD ONE
                        }
                    } else {
                        // handle error
                        print("error")
                        print(error?.localizedDescription as Any)
                    }
                    
                })
//                if(self.dealID != nil && self.dealID != "")
//                {
//                    for i in self.pics
//                    {
//                        Image.postDealImage(deal_id: self.dealID!, toPostImage: i, withCompletion: { (success : Bool, error : Error?) in
//                            
//                            if success {
//                                print("Added image")
//                            }
//                            else{
//                                print("error")
//                                print(error?.localizedDescription as Any)
//                            }
//                            
//                        })
//                    }
//                }
//                else{
//                    print("didint do the image")
//                }
//                
                
                
                
                
                //                self.present(self.alertController, animated: true) {
                //
                //                }
            }
        })
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "findAddress"){
            let destVC = segue.destination as! LocationsViewController
            //destVC.imageTaken = self.imageTaken
            destVC.delegate = self
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isEnabled = false
        addButton.backgroundColor = UIColor.lightGray
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
