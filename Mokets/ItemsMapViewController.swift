//
//  ItemsMapViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 20/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import CoreLocation

class ItemsMapViewController : UIViewController,CLLocationManagerDelegate {
    
    var selectedShopId: Int!
    var selectedCityLat: String!
    var selectedCityLng: String!
    var selectedSubCategoryId: Int!
    var mapPins = [MapPin]()
    var userLat: Double = 0.0
    var userLng: Double = 0.0
    var isLocationServiceError: Bool = false
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    
    var slider = UISlider()
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var sliderValue: UILabel!
    
    
    @IBAction func changeSliderValue(_ sender: UISlider) {
        sliderValue.text = language.mileRange + String(format: "%.01f", sender.value) + language.miles
        //String(format: "%.01f", 3.32323242)
    }
    
    @IBAction func closePopup(_ sender: AnyObject) {
        popupView.isHidden = true
    }
    
    @IBAction func searchByRange(_ sender: AnyObject) {
        popupView.isHidden = true
        if(!isLocationServiceError) {
            
            if(userLat != 0.0 && userLng != 0.0) {
                // SearchByGeo
                print("Range :  \(rangeSlider.value)")
                
                _ = EZLoadingActivity.show("Loading...", disableUI: true)
                
                Alamofire.request(APIRouters.SearchByGeo(rangeSlider.value, userLat, userLng, selectedShopId, selectedSubCategoryId)).responseCollection {
                    (response: DataResponse<[Item]>) in
                    
                    if response.result.isSuccess {
                        if let items: [Item] = response.result.value {
                            self.mapView.removeAnnotations(self.mapView.annotations)
                            
                            if(items.count > 1) {
                                self.title = String(items.count) + " Results Found"
                            } else if (items.count == 1) {
                                self.title = String(items.count) + " Result Found"
                            }
                            
                            if(items.count > 0) {
                                self.mapPins.removeAll()
                                for item in items {
                                    let onePin = MapPin(item: item)
                                    self.mapPins.append(onePin)
                                    
                                }
                                self.mapView.addAnnotations(self.mapPins)
                                self.mapView.delegate = self
                                
                                _ = EZLoadingActivity.hide()
                                
                            } else {
                                self.title = language.mapExplorePageTitle
                                _ = EZLoadingActivity.hide()
                                _ = SweetAlert().showAlert(language.searchTitle, subTitle: language.itemNotFount, style: AlertStyle.warning)
                            }
                        }else {
                            _ = EZLoadingActivity.hide()
                        }
                        
                    } else {
                        print(response)
                        _ = EZLoadingActivity.hide()
                    }
                }
            }
            
        } else {
            _ = SweetAlert().showAlert(language.searchTitle, subTitle: language.allowLocationService, style: AlertStyle.warning)
        }
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        addNavigationMenuItem()
        let initialLocation = CLLocation(latitude: Double(selectedCityLat)!, longitude: Double(selectedCityLng)!)
        centerMapOnLocation(initialLocation)
        //loadMapPins()
        preparePopupView()
        
    }
  
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //mapView = nil
        //popupView = nil
        //currentLocation = nil
        //rangeSlider = nil
        
        //super.viewWillDisappear(animated)
        //self.applyMapViewMemoryFix()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //mapView = nil
        //popupView = nil
        //currentLocation = nil
        //rangeSlider = nil
    }
    
    func applyMapViewMemoryFix(){
        
        if self.mapView != nil {
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            switch (self.mapView.mapType) {
            case MKMapType.hybrid:
                self.mapView.mapType = MKMapType.standard
                break;
            case MKMapType.standard:
                self.mapView.mapType = MKMapType.hybrid
                break;
            default:
                break;
            }
            
            self.mapView.showsUserLocation = false
            self.mapView.delegate = nil
            self.mapView.removeFromSuperview()
            self.mapView = nil
        }
        
    }
    
    func preparePopupView() {
        popupView.layer.cornerRadius = CGFloat(5)
        popupView.layer.borderWidth = 1
        popupView.layer.borderColor = UIColor.red.cgColor
        popupView.clipsToBounds = true
        
        popupView.isHidden = true
    }
    
    
    func addNavigationMenuItem() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(ItemsMapViewController.openRangePopup))
        navigationItem.rightBarButtonItems = [searchButton]
    }
    
    @objc func openRangePopup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        popupView.isHidden = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            //            print(">>>>>>")
            //            print(placemarks!)
            //            print("<<<<<<<")
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                self.displayLocationInfo(pm)
                self.userLat = manager.location!.coordinate.latitude
                self.userLng = manager.location!.coordinate.longitude
                
            } else {
                _ = SweetAlert().showAlert(language.searchTitle, subTitle: language.geocoderProblem, style: AlertStyle.warning)
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            
            if(locality != nil) {
                currentLocation.text = language.currentLocation + "( " + locality! + " )"
            } else {
                currentLocation.text = language.currentLocation + "( N.A )"
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
        isLocationServiceError = true
    }
    
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 100.0, regionRadius * 100.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadMapPins() {
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        Alamofire.request(APIRouters.AllItemsBySubCategory(selectedShopId, selectedSubCategoryId)).responseCollection {
            (response: DataResponse<[Item]>) in
            
            if response.result.isSuccess {
                if let items: [Item] = response.result.value {
                    if(items.count > 0) {
                        for item in items {
                            let onePin = MapPin(item: item)
                            self.mapPins.append(onePin)
                        }
                        
                        self.mapView.addAnnotations(self.mapPins)
                        self.mapView.delegate = self
                        _ = EZLoadingActivity.hide()
                    }else {
                        _ = EZLoadingActivity.hide()
                    }
                }
                
            } else {
                print(response)
                _ = EZLoadingActivity.hide()
            }
        }
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.mapExplorePageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
        
    }
    
    
}

extension ItemsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        weak var annotation = annotation as? MapPin
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //self.navigationController?.popViewControllerAnimated(true)
        weak var location = view.annotation as? MapPin
        weak var itemDetailController = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetail") as? ItemDetailViewController
        self.navigationController?.pushViewController(itemDetailController!, animated: true)
        itemDetailController!.selectedItemId = Int(location!.id!)!
        itemDetailController!.selectedShopId = selectedShopId
        updateBackButton()
        
        
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
       
    }
    
    
    
}



