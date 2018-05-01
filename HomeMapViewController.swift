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



class HomeMapViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MKMapViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate{
    
    
    //********************************************************************************************
    //Variables
    var currentUser = ""

    let manager = CLLocationManager()
    //@IBOutlet weak var addDealButton: UIButton!
    var annoLoca : CLLocationCoordinate2D!
    //var pinEnabled : Bool!
    var vc: UIImagePickerController!
    var imageTaken: UIImage!
    var deals: [Deal] = []
    var images: [Image] = []
    //https://stackoverflow.com/questions/33927405/find-closest-longitude-and-latitude-in-array-from-user-location-ios-swift
    
    //********************************************************************************************
    //Outlets
    @IBOutlet weak var dealsTable: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    //@IBOutlet weak var nyanImage: UIImageView!

    
    
    
   
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        getDeals()
        getImages()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        addDealButton.isHidden = true;
//        addDealButton.isEnabled = false;
//        pinEnabled = false;
//        nyanImage.isHidden = true;
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        
        manager.startUpdatingLocation()
        print(PFUser.current()?.objectId ?? "")
        currentUser = (PFUser.current()?.objectId ?? "")!
        mapView.showsUserLocation = true

        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),MKCoordinateSpanMake(0.1, 0.1))
        self.mapView.setRegion(currentRegion, animated: true)
        
//        PFGeoPoint.geoPointForCurrentLocation(inBackground: {(geopoint,error) in
//            if(geopoint != nil)
//            {
//                print("going to current location")
//                //SENDS ME TO RANDOM POINT IN OCEAN IDK WHY
//                //let currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake((geopoint?.latitude)!,(geopoint?.longitude)!),MKCoordinateSpanMake(0.1, 0.1))
//                let currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),MKCoordinateSpanMake(0.1, 0.1))
//                self.mapView.setRegion(currentRegion, animated: true)
//            }
//            else{
//                print("didnt find current location")
//                let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),MKCoordinateSpanMake(0.1, 0.1))
//                self.mapView.setRegion(sfRegion, animated: true)
//            }
//        })
//
        
        

        
        //UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        dealsTable.insertSubview(refreshControl, at: 0)

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
        //getDeals()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //fillMap()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        let userRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(userRegion, animated: true)
        mapView.showsUserLocation = true

        
        let postQuery = PFQuery(className: "Deal")
        postQuery.whereKey("loc", nearGeoPoint: PFGeoPoint(latitude: (userLocation.coordinate.latitude),longitude: (userLocation.coordinate.longitude)), withinMiles: 3)
        postQuery.findObjectsInBackground(block: { (objects, error) -> Void in
            if(objects != nil){
                print("got local stuff:")
                print(objects!)
                print("end of local")
            }
            else if((error) != nil)
            {
                print("errror finding local")
                print(error!)
            }
            
        })
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.async {
            self.getDeals()
        }
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
    }
    func fillMap() -> Void {
        //print("about to enter loop")
        for d in self.deals{
            //print("in loooop")
            //ADDING ALL THE ANNOTATIONS NOW

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: d.loc.latitude,longitude: d.loc.longitude)
            annotation.title = d.dealName
            mapView.addAnnotation(annotation)
        }
        //print("out of loop")
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
                print("in adding annotation, before pinview stuff")
                if pinView == nil {
                    print("Pinview was nil")
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    pinView!.canShowCallout = true
                    pinView!.animatesDrop = true
                    pinView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
                    pinView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure) as UIButton // button with info sign in it
                }
                print("after pinview stuff")
        
        
        
                return pinView
        
        
    }
    //********************************************************************************************
    //Queries
    func getImages(){
        let query = Image.query()
        //query?.order(byDescending: "_created_at")
        query?.findObjectsInBackground(block: { (images, error) in
            if  images != nil {
                // do something with the data fetched
                self.images = images as! [Image]
                //print(deals!)
                //reloads the table view once we have the data
                //self.dealsTable.reloadData()
                //self.refreshControl.endRefreshing()
                print("Retrieved Images")
            } else {
                // handle error
                print("error")
                print(error?.localizedDescription as Any)
            }
        })
    }

    func getDeals(){
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
                self.fillMap()

            } else {
                // handle error
                print("error")
                print(error?.localizedDescription as Any)
            }
        })
    }
    

    //********************************************************************************************
    //Table View stuff
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
        let id = deal.objectId
        print(id)
//uncomment to display images
// currently images too big, displaying in wrong cell if scroll too fast
        for img in images{
            //print(img.deal_id)
            if(img.deal_id == id){
                print("got match")
                if let imageFile : PFFile = img.image {
                    imageFile.getDataInBackground(block: {(data, error) in
                        if error == nil {
                            DispatchQueue.main.async {
                                let image = UIImage(data: data!)
                                cell.dealImage.image = image

                            }
                        } else{
                            print(error!.localizedDescription)
                        }
                    })
                }
            }

        }
        
        
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
    
    //********************************************************************************************
    //Other
    func buttontapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "EditDeal", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    

    
    //********************************************************************************************
    //Search Map
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
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
                //TO DO: ADD AN ALERT TO SAY THAT COULD NOT FIND LOCATION
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
    
    
    //********************************************************************************************
    //Old code commented for later use
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

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

