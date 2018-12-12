//
//  MapViewCustom.swift
//  current-place-on-map
//
//  Created by HarryNguyen on 8/23/18.
//  Copyright © 2018 SmartOSC Corp. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON

struct LocationInfo {
    var country: String? = nil
    var state: String? = nil
    var city: String? = nil
    var street: String? = nil
    var zip_postal_code: String? = nil
    var longitude: Double? = nil
    var latitude: Double? = nil
}

class MapViewCustom: UIView, GMSMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var gmsMapViewCustom: GMSMapView!
    @IBOutlet weak var txtSearchLocation: UITextField!
    
    
    var gmsPolyLine: GMSPolyline? = nil
    var currentMaker: GMSMarker?
    var locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D? = nil
    var zoomLevel:Float = 15.0
    var storeLocation: CLLocationCoordinate2D = CLLocationCoordinate2D.init() {
        didSet {
            if(nil != currentMaker){
                DispatchQueue.main.async {
                    self.gmsPolyLine?.map = nil
                    self.currentMaker?.position = self.storeLocation
                    self.gmsMapViewCustom.selectedMarker = self.currentMaker
                }
            }
        }
    }
    
    lazy var filter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.noFilter
        return filter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func createMapKit(latitude: Double,longitude: Double, frame: CGRect)-> MapViewCustom? {
        if let mapView = Bundle.main.loadNibNamed("MapViewCustom", owner: self, options: nil)![0] as? MapViewCustom {
            mapView.frame = frame
            mapView.initMapKit(latitude: latitude, longitude: longitude)
            return mapView
        }
        return nil
    }
    
    
    func initMapKit(latitude:Double,longitude: Double ) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude,zoom: zoomLevel)
        gmsMapViewCustom.camera = camera
        gmsMapViewCustom.delegate = self
        segmentControl.setWidth(60.0, forSegmentAt: 0)
        segmentControl.setWidth(60.0, forSegmentAt: 1)
        self.segmentControl.tintColor =  (segmentControl.selectedSegmentIndex == 0 ? MyColor.quiteBlack : UIColor.white)
        // Marker
        let house = UIImage(named: "store")
        let markerView = UIImageView(image: house)
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.iconView = markerView
        marker.tracksViewChanges = true
        marker.map = gmsMapViewCustom
        self.currentMaker = marker
        
        // Set current location
        self.storeLocation = position
        
        // Get local location
        self.gmsMapViewCustom?.isMyLocationEnabled = true
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    @IBAction func eventClickRoute(_ sender: UIButton) {
        if let currentLocation = self.currentLocation, let gmsMapViewCustom = self.gmsMapViewCustom {
            let origin = "\(currentLocation.latitude),\(currentLocation.longitude)"
            let destination = "\(self.storeLocation.latitude),\(self.storeLocation.longitude)"
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
            var urlRequest = URLRequest(url: URL(string: url)!)
            urlRequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] (data, resopnse, error) in
                if let data = data,  let json = try? JSON.init(data: data) {
                    let routes = json["routes"].arrayValue
                    if routes.count > 0 { // Drawer when have rotures
                        for route in routes {
                            let routeOverviewPolyline = route["overview_polyline"].dictionary
                            let points = routeOverviewPolyline?["points"]?.stringValue
                            let path = GMSPath.init(fromEncodedPath: points!)
                            self?.drawRouteMap(path: path, gmsMapView: gmsMapViewCustom)
                        }
                    }else {
                        let path = GMSMutablePath.init()
                        path.add(currentLocation)
                        path.add(self!.storeLocation)
                        self?.drawRouteMap(path: path, gmsMapView: gmsMapViewCustom)
                    }
                }
            }
            task.resume()
        }
    }
    
    func drawRouteMap(path: GMSPath?, gmsMapView: GMSMapView) {
        DispatchQueue.main.async {
            if self.gmsPolyLine == nil {
                self.gmsPolyLine = GMSPolyline.init(path: path)
            }else {
                self.gmsPolyLine?.path = path
            }
            //Remove old path
            self.gmsPolyLine?.map = nil
            //Add new path
            self.gmsPolyLine!.strokeColor = UIColor.blue
            self.gmsPolyLine!.strokeWidth = 2
            self.gmsPolyLine!.map = gmsMapView
        }
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last?.coordinate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    @IBAction func eventClickChangeSearchMap(_ sender: UITextField) {
        if let textSearch = sender.text , textSearch.count > 0 {
            self.getAutoSuggestionPlaces(textSearch: textSearch)
        }
    }
    
    func getAutoSuggestionPlaces(textSearch: String) {
        GMSPlacesClient.shared().autocompleteQuery(textSearch, bounds: nil, filter: self.filter) { (results, error) in
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        UIView.animate(withDuration: 5.0, animations: { () -> Void in
            // Decord marker here
        }, completion: {(finished) in
            self.currentMaker?.tracksViewChanges = false
            self.zoomLevel = self.gmsMapViewCustom.camera.zoom
        })
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        self.storeLocation = coordinate
//        reloadForNewCoordinate(coordinate)
    }
    
    @IBAction func eventClickZoomIn(_ sender: Any) {
        if self.gmsMapViewCustom.minZoom < zoomLevel{
            zoomLevel = zoomLevel - 1
            self.gmsMapViewCustom.animate(toZoom: zoomLevel)
        }
    }
    
    @IBAction func eventClickZoomOut(_ sender: Any) {
        if self.gmsMapViewCustom.maxZoom > zoomLevel {
            zoomLevel = zoomLevel + 1
            self.gmsMapViewCustom.animate(toZoom: zoomLevel)
        }
    }
    
    @IBAction func eventInputLocation(_ sender: UITextField) {
    }
    
    @IBAction func eventChangeTypeMap(_ sender: UISegmentedControl) {
        self.gmsMapViewCustom.mapType =  (sender.selectedSegmentIndex == 0 ? GMSMapViewType.normal: GMSMapViewType.hybrid)
        self.segmentControl.tintColor =  (sender.selectedSegmentIndex == 0 ? MyColor.quiteBlack : UIColor.white)
    }
    
}

// get information
extension MapViewCustom {
    
    func reloadForNewCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self]  (placemarks, error) -> Void in
            guard let placemarks = placemarks , placemarks.count > 0 else {
                
                return
            }
            let placeMark  = placemarks[0]
            var locationResult = LocationInfo()
            locationResult.latitude = coordinate.latitude
            locationResult.longitude = coordinate.longitude
            
            var txtSearch:String = ""
            var tempStr:String = ""
            // State
            if let state = placeMark.administrativeArea, !state.isEmpty {
                tempStr += ("State: " + state + "\n")
                txtSearch += (state + " - ")
                locationResult.state = state
            }
            // City
            if let city = placeMark.subAdministrativeArea, !city.isEmpty {
                tempStr += ("City: " + city + "\n")
                locationResult.city = city
            }
            
            // Street address
            if let street = placeMark.thoroughfare, !street.isEmpty {
                tempStr += ("Street: " + street + "\n")
                locationResult.street = street
            }
            // Zip code
            if let postalCode = placeMark.postalCode {
                if  !postalCode.isEmpty {
                    tempStr += ("Zip: " + postalCode)
                    locationResult.zip_postal_code = postalCode
                }
            }else {
                if let isoCountryCode = placeMark.isoCountryCode, !isoCountryCode.isEmpty {
                    tempStr += ("Zip: " + isoCountryCode)
                    locationResult.zip_postal_code = isoCountryCode
                }
            }
            
            var belongToCountry:Bool = false
            // Country
            if let country = placeMark.country, !country.isEmpty {
                belongToCountry = true
                txtSearch += (country)
                self?.currentMaker?.title = country
                locationResult.country = country
            }
            if !belongToCountry {
                self?.currentMaker?.title = (placeMark.ocean == nil ? "" : placeMark.ocean!)
                self?.currentMaker?.snippet = ""
            }else {
                self?.currentMaker?.snippet = tempStr
//                self?.delegate?.resultSearchPlace(msgError: nil, locationInfo: locationResult)
            }
            self?.txtSearchLocation.text = txtSearch
        })
    }
    
    func searchPlaceFromGoogle(place: String) {
        guard !place.isEmpty else {
            return
        }
        var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(place)&key=AIzaSyBCmiAi-SgtYNvYzuwwCNjR2rFDtdoOKlo"
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] (data, resopnse, error) in
            if error == nil {
                if let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject], let results = jsonDict["results"] as? [AnyObject] {
                    self?.parserLocation(results: results)
                }
            } else {
//                self?.delegate?.resultSearchPlace(msgError: "Outlet Address not found on Google Map. Please update Street and City address", locationInfo: nil)
            }
        }
        task.resume()
    }
    
    func parserLocation(results:[AnyObject]) {
        if results.count > 0 {
            guard let result = results[0] as? [String:Any] else {
                return
            }
            if let geometry =  result["geometry"] as? [String: AnyObject] ,   let location = geometry["location"] as? [String:AnyObject], let lat = location["lat"] as? Double , let lng = location["lng"] as? Double{
                let resultCoordinal = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
                self.storeLocation = resultCoordinal
                //self.reloadForNewCoordinate(resultCoordinal)
                //Update camera when search
                DispatchQueue.main.async {
                    let camera = GMSCameraPosition.camera(withLatitude: lat,longitude: lng,zoom: self.zoomLevel)
                    self.gmsMapViewCustom.camera = camera
                }
            }
        }else {
//            self.delegate?.resultSearchPlace(msgError: "Outlet Address not found on Google Map. Please update Street and City address", locationInfo: nil)
        }
    }
}


