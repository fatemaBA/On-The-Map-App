//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Fato0omAH on 9/14/19.
//  Copyright © 2019 Fatema. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationVC: UIViewController, MKMapViewDelegate {
    
    //MARK: Properties
    var locationText: String?
    var linkText: String?
    var coords: CLLocationCoordinate2D?
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords!
        annotation.title = "\(Client.firstName!) \(Client.lastName!)"
        annotation.subtitle = linkText
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    //MARK: MKMapViewDelegate functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    //MARK: Actions
    @IBAction func finishTabbed(_ sender: Any) {
        
        if  Client.objectId != nil{
            Client.putLocation(firstName: Client.firstName!, lastName: Client.lastName!, long: coords!.longitude, lat: coords!.latitude, map: locationText!, url: linkText!, completion: {(error) in
                if let error = error {
                    self.showErrorMessage(title:"Failed to Update Location", message: error.localizedDescription)
                    print(error)
                    return
                }
            })
            
        } else {
            Client.postLocation(firstName: Client.firstName!, lastName: Client.lastName!, long: coords!.longitude, lat: coords!.latitude, map: locationText!, url: linkText!, completion: { (error) in
                if let error = error {
                    self.showErrorMessage(title:"Failed to Add Location", message: error.localizedDescription)
                    print(error)
                    return
                }
            })
        }
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
        self.present(resultVC, animated: true, completion: nil)
    }
    
}

