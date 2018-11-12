//
//  LocationSearchTable.swift
//  RoadTrip
//
//  Created by Sarin Swift on 11/1/18.
//  Copyright © 2018 sarinswift. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    
    // stashing the search results for easy access
    var matchingItems: [MKMapItem] = []
    // relies on a map region to prioritize local results
    var mapView: MKMapView? = nil
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
}

extension LocationSearchTable: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {
            return
        }
        
        let request = MKLocalSearch.Request()
        // a search request is comprised of a search string and a map region
        // the search string comes from the search bar text
        request.naturalLanguageQuery = searchBarText
        // the map region comes from the mapView
        request.region = mapView.region
        
        // performs the actaul search on the request object
        // executes the search query and returns a localSearchResponse object
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
}

extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAdress(selectedItem: selectedItem)
        return cell
    }
    
    func parseAdress(selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        
        let adressLine = String (
            format: "%@%@%@%@%@%@%@",
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            selectedItem.thoroughfare ?? "",
            comma,
            selectedItem.locality ?? "",
            secondSpace,
            selectedItem.administrativeArea ?? ""
        )
            
        return adressLine
        
    }
    
    // when a row is selected,
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // find an appropriate placemark based on the row number
        let selectedItem = matchingItems[indexPath.row].placemark
        // pass the placemark to the map controller
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        // close the search results modal so the user can see the map
        dismiss(animated: true, completion: nil)
    }
    
}
