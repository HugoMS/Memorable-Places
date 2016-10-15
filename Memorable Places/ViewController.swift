//
//  ViewController.swift
//  Memorable Places
//
//  Created by Hugo Morelli on 10/9/16.
//  Copyright © 2016 Hugo Morelli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
        
        if activePlaces == -1 {
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        
        }else {
            
            if places.count > activePlaces {
                
                if let name = places[activePlaces]["name"] {
                    
                    if let lat = places[activePlaces]["lat"] {
                    
                        if let lon = places[activePlaces]["lon"] {
                            
                            if let latidude = Double(lat){
                                
                                if let longitude = Double(lon){
                                    
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    
                                    let coordinate = CLLocationCoordinate2D(latitude: latidude, longitude: longitude)
                                    
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    
                                    self.map.setRegion(region, animated: true)
                                    
                                    let anotation = MKPointAnnotation()
                                    
                                    anotation.coordinate = coordinate
                                    
                                    anotation.title = name
                                    
                                    self.map.addAnnotation(anotation)
                                    
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.began{
            
        
        let touchPoint = gestureRecognizer.location(in: self.map)
        
        let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
        
        let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
         
        var  title = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            if error != nil {
        
                print(error)
        
            }else {
                
                if let placemark = placemarks?[0] {
            
                    if placemark.subThoroughfare != nil {
                        title += placemark.subThoroughfare! + " "
                    }
                    
                    if placemark.thoroughfare != nil {
                        title += placemark.thoroughfare!     + " "
                    }
                }
            }
            if title  == "" {
                title = "Added \(NSDate())"
            }
            let anotation = MKPointAnnotation()
            
            anotation.coordinate = newCoordinate
            
            anotation.title = title
            
            self.map.addAnnotation(anotation)

            places.append(["name": title,"lat":String(newCoordinate.latitude),"lon":String(newCoordinate.longitude)])
            
            UserDefaults.standard.set(places, forKey: "places")
                
        })
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

