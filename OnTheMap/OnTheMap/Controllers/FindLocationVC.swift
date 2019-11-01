//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Fato0omAH on 9/11/19.
//  Copyright © 2019 Fatema. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class FindLocationVC: UIViewController{
    
    //MARK: Properties
    var coords: CLLocationCoordinate2D?
    
    //MARK: Outlets
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var linkText: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    //MARK: Actions
    @IBAction func findLocation(_ sender: Any) {
        setFindingLocation(true)
        
        getCoordinate(completionHandler: { (coordinates, error) in
            self.setFindingLocation(false)
            guard let coordinates = coordinates else {
                self.showErrorMessage(title:"Failed to Get Location", message: "Location not valid")
                return
            }
            self.coords = coordinates
            self.performSegue(withIdentifier: "AddLocationVC", sender: nil)
        })
        
    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Other functions
    
    //get coordinates from string
    func getCoordinate(completionHandler: @escaping(CLLocationCoordinate2D?, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.locationText?.text ?? "") { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(nil, error as NSError?)
        }
    }
    
    //override prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! AddLocationVC
        controller.coords = self.coords
        controller.locationText = self.locationText.text
        controller.linkText = self.linkText.text
    }
    
    //activity indicator setter
    func setFindingLocation(_ findingLocation: Bool) {
        if findingLocation {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        findLocationButton.isEnabled = !findingLocation
    }
}
