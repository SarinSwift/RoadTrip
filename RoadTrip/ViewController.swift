//
//  ViewController.swift
//  RoadTrip
//
//  Created by Sarin Swift on 10/27/18.
//  Copyright © 2018 sarinswift. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// anything that conforms to this protocol has to implement this method
protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}
 
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var resultsSearchController: UISearchController? = nil
    // cahcing any incoming placemarks
    var selectedPin: MKPlacemark? = nil
    
    let manager = CLLocationManager()
     
    var geoFire: GeoFire!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // this requests to use location even outside of the app
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        setupSearchBar()

    }
    
    
    // Called everytime our user's location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        // how much we want our app to be zoomed in on the location
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        // getting the current location
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        // this shows the blue dot on the map
        self.mapView.showsUserLocation = true
    }
    
    func setupSearchBar() {
        
        // creates the search controller
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultsSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultsSearchController?.searchResultsUpdater = locationSearchTable

        
        // Setting up the search bar
        let searchBar = resultsSearchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for places"
        // embeds the search bar within the navigation bar
        navigationItem.titleView = resultsSearchController?.searchBar
        
        resultsSearchController?.hidesNavigationBarDuringPresentation = false
        resultsSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        // handles the mapView on to the location search table
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
        
    }

}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins so we make sure that we're only dealing with one pin on the map
        mapView.removeAnnotations(mapView.annotations)
        
        // a map view that contains a coordinate, title, and subtitle
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        // zooms the map to the coordinate
        mapView.setRegion(region, animated: true)
    }
    
    
}

