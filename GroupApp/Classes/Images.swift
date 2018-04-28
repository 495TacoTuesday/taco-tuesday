//
//  Images.swift
//  GroupApp
//
//  Created by Samba Diallo on 4/25/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//


import Foundation
import Parse

class Image: PFObject, PFSubclassing {
    
    @NSManaged var deal_id: String
    @NSManaged var image : PFFile
    @NSManaged var author: PFUser
    
    /* Needed to implement PFSubclassing interface */
    class func parseClassName() -> String {
        return "Image"
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
    class func postDealImage(deal_id: String, toPostImage: UIImage, withCompletion completion: PFBooleanResultBlock?) {
        // use subclass approach
        let image = Image()
        
        
        
        // Add relevant fields to the object
        // post.media = getPFFileFromImage(image: image)! // PFFile column type
        
        
        image.deal_id =  deal_id// Pointer column type that points to PFUser
        image.author = PFUser.current()!
        image.image = getPFFileFromImage(image: toPostImage)!
        
        // Save object (following function will save the object in Parse asynchronously)
        image.saveInBackground(block:{(success, error) -> Void in
            if success {
                let ojId = image.deal_id
                print("Image posted to ID == " + ojId)
                
            }})
        
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

