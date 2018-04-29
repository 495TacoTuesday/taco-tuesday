//
//  HomeMapViewController.swift
//  GroupApp
//
//  Created by Joe Antongiovanni on 3/26/18.
//  Copyright © 2018 Joe Antongiovanni. All rights reserved.
//

//TODO: Refresh Control
//TODO: Persist User, logout, bypass login
//TODO: Edit deal


import Parse
import UIKit
import MapKit
import CoreLocation


//class PhotoAnnotation: NSObject, MKAnnotation {
//    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
//    var photo: UIImage!
//
//    var title: String? {
//        return "\(coordinate.latitude)"
//    }
//}
//


class HomeMapViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LocationsViewControllerDelegate,MKMapViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate{
    
    
    //@IBOutlet weak var nyanImage: UIImageView!
    @IBOutlet weak var dealsTable: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    //@IBOutlet weak var addDealButton: UIButton!
    var annoLoca : CLLocationCoordinate2D!
    //var pinEnabled : Bool!
    var vc: UIImagePickerController!
    var imageTaken: UIImage!
    var deals: [Deal] = []
    //https://stackoverflow.com/questions/33927405/find-closest-longitude-and-latitude-in-array-from-user-location-ios-swift
    
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
//    @IBAction func enablePin(_ sender: Any) {
//        if(pinEnabled == true){
//            nyanImage.isHidden = false;
//            pinEnabled = false;
//            addDealButton.isHidden = false;
//            addDealButton.isEnabled = true;
//        }
//        else{
//            nyanImage.isHidden = true;
//            pinEnabled = true;
//            addDealButton.isHidden = true;
//            addDealButton.isEnabled = false;
//        }
//
//    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Ignoring user unteraction except typing
        UIApplication.shared.beginIgnoringInteractionEvents()
        //Activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil{
                print("error")
            }
            else{
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.annoLoca = annotation.coordinate
                //Zoom back in
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated: true)
                
                self.mapView.addAnnotation(annotation)
                
                
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getDeals()
        
    }
    var currentUser = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        addDealButton.isHidden = true;
//        addDealButton.isEnabled = false;
//        pinEnabled = false;
//        nyanImage.isHidden = true;
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.stopUpdatingLocation()
        print(PFUser.current()?.objectId)
        currentUser = (PFUser.current()?.objectId)!

        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: true)
        
        
        
        //set up camera
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
        //setting delegate
        mapView.delegate = self
        
        dealsTable.dataSource = self
        //dealsTable.delegate = self
        getDeals()

    }
    
    func getDeals()
    {
        let query = Deal.query()
        //    query?.limit = 20
        query?.order(byDescending: "_created_at")
        // fetch data asynchronously
        query?.findObjectsInBackground(block: { (deals, error) in
            if  deals != nil {
                // do something with the data fetched
                self.deals = deals as! [Deal]
                //print(deals!)
                //reloads the table view once we have the data
                self.dealsTable.reloadData()
                //self.refreshControl.endRefreshing()
                print("Retrieved Deals")
            } else {
                // handle error
                print("error")
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber, photo: UIImage) {
        let locationCoordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)
        
        self.navigationController?.popToViewController(self, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "\(latitude), \(longitude)"
        annoLoca = annotation.coordinate
        
        Deal.postUserDeal(dealName: "Test Name",buisnessName: "Test Taco Place", description: "Test Description" ,latt: latitude,long: longitude) {
            (success, error) in
            if success{
                print("Deal posted")
            }
            else{
                print(error?.localizedDescription as Any)
            }
        }
        
        
        mapView.addAnnotation(annotation)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dealsTable.dequeueReusableCell(withIdentifier: "dealCell", for: indexPath) as! DealCell
        let deal = deals[indexPath.row]
        let dealLabel = deal.dealName
        let descLabel = deal.desc
        let BusName = deal.businessName
        let auth = deal.author.objectId
        if(auth == self.currentUser){
            print("true")
            DispatchQueue.main.async {
            cell.editButton.isHidden = false
            }
        }
        else{
            DispatchQueue.main.async {
            cell.editButton.isHidden = true
            }}
        print(dealLabel)
        cell.dealLabel.text = dealLabel
        cell.descLabel.text = descLabel
        cell.BusName.text = BusName
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(HomeMapViewController.buttontapped(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func buttontapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "EditDeal", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "tagSegue"){
            let destVC = segue.destination as! LocationsViewController
            destVC.imageTaken = self.imageTaken
            destVC.delegate = self
        }
        
        if(segue.identifier == "dealID") {
            
            let cell = sender as! UITableViewCell
            if let indexPath = dealsTable.indexPath(for: cell) {
                let deal = deals[indexPath.row]
                let dealDetailViewController = segue.destination as! DealDetailViewController
                dealDetailViewController.deal = deal
                
                //when we need to pass images use this
                //let dealCell = sender as! DealCell
                //dealDetailViewController.postImage = postCell.postImage.image!
            }
        }
        
        if(segue.identifier == "EditDeal") {
           
            if let destination = segue.destination as? EditDealViewController{
                
                if let button:UIButton = sender as! UIButton?{
                    destination.valueViaSegue = button.tag
                    let deal = deals[button.tag]
                    destination.deal = deal
                }
            }
        }
        
    }
    
    
    @IBAction func tappedCamera(_ sender: Any) {
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                     didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imageTaken = originalImage
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        print("Got Image")
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        })
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("viewForannotation")
        if annotation is MKUserLocation {
            //return nil
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        self.mapView.setRegion(region, animated: true)
        
        if pinView == nil {
            print("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            pinView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure) as UIButton // button with info sign in it
        }
        
        
        
        
        return pinView
        
        
//        let reuseID = "myAnnotationView"
//
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
//        if (annotationView == nil) {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
//            annotationView!.canShowCallout = true
//            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
//        }
//
//        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
//        imageView.image = imageTaken
//
//        return annotationView
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        let userRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(userRegion, animated: true)
        //self.mapView.showsUserLocation = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

