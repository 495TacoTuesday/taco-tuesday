//
//  Location.swift
//  GroupApp
//
//  Created by Samba Diallo on 4/9/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

import Foundation
import Parse

class Deal: PFObject, PFSubclassing {
    @NSManaged var author: PFUser
    @NSManaged var desc: String
    @NSManaged var businessName: String
    @NSManaged var dealName: String
    @NSManaged var lat: NSNumber
    @NSManaged var lon: NSNumber
    
    /* Needed to implement PFSubclassing interface */
    class func parseClassName() -> String {
        return "Deal"
    }
    
    /**
     * Other methods
     */
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserDeal(dealName: String, buisnessName : String, description: String?, latt : NSNumber, long : NSNumber,  withCompletion completion: PFBooleanResultBlock?) {
        // use subclass approach
        let deal = Deal()
        
        // Add relevant fields to the object
       // post.media = getPFFileFromImage(image: image)! // PFFile column type
        deal.author = PFUser.current()! // Pointer column type that points to PFUser
        deal.desc = description!
        deal.lat = latt
        deal.lon = long
        deal.businessName = buisnessName
        deal.dealName = dealName
        
        // Save object (following function will save the object in Parse asynchronously)
        deal.saveInBackground(block: completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}

