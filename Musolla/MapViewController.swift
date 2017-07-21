//
//  MapViewController.swift
//  Musolla
//
//  Created by Muhd Mirza on 17/7/17.
//  Copyright © 2017 msociety. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, LocationSelectProtocol {

	@IBOutlet var mapView: MKMapView!

	var locationManager: CLLocationManager?
	
	var userLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.locationManager = CLLocationManager()
		self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager?.delegate = self
		self.locationManager?.requestWhenInUseAuthorization()
		self.locationManager?.distanceFilter = 50
		
		self.locationManager?.startUpdatingLocation()
		
		self.mapView.showsUserLocation = true
		self.mapView.mapType = .standard
		self.mapView.delegate = self
		self.mapView.isZoomEnabled = true
		self.mapView.isScrollEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: LocationSelectProtocol delegate function
	func didSelect(location: MKMapItem?) {
		
	}
	
	// MARK: CLLocationManagerDelegate delegate function
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("Getting user location..")

		guard let tmpUserLocation = locations.first else {
			return
		}

		self.userLocation = CLLocationCoordinate2D.init(latitude: tmpUserLocation.coordinate.latitude, longitude: tmpUserLocation.coordinate.longitude)
		
		self.reloadMap()
	}
	
	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Failed to get location: \(error)")
	}
	
	// MARK: MKMapViewDelegate delegate function
	public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		
		if annotation is MusollaAnnotation {
			let annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "pin")
			annotationView.pinTintColor = UIColor.blue
			annotationView.canShowCallout = true
			
			let button = UIButton.init(type: .infoLight)
			annotationView.rightCalloutAccessoryView = button
			
			return annotationView
		}
		
		return nil
	}
	
	public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		let directionsRequest = MKDirectionsRequest()
		directionsRequest.transportType = .automobile
		
		let placemark = MKPlacemark.init(coordinate: self.mapView.selectedAnnotations[0].coordinate)
		let selectedMusolla = MKMapItem.init(placemark: placemark)
		
		directionsRequest.source = MKMapItem.forCurrentLocation()
		directionsRequest.destination = selectedMusolla
		
		let directions = MKDirections.init(request: directionsRequest)
		directions.calculate { (directionsResponse, error) in
			if let route = directionsResponse?.routes[0] {
				
				self.mapView.add(route.polyline)
				
				// this is essentially how you frame what you want to see
				// you have 10 points padding all around
				self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
				
				selectedMusolla.name = self.mapView.selectedAnnotations[0].title!!
				selectedMusolla.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeDriving: MKLaunchOptionsDirectionsModeKey])
			} else if let _ = error {
				let alert = UIAlertController(title: nil, message: "Directions not available.", preferredStyle: .alert)
				let okButton = UIAlertAction.init(title: "Directions not available.", style: .default, handler: nil)
				alert.addAction(okButton)
				
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let polylineRenderer = MKPolylineRenderer.init(overlay: overlay)
		
		if overlay is MKPolyline {
			if self.mapView.overlays.count == 1 {
				polylineRenderer.strokeColor = UIColor.red
			}
			
			polylineRenderer.lineWidth = 5
		}
		
		return polylineRenderer
	}
	
	func reloadMap() {
		print("Reloading map..")
	
		self.mapView.selectedAnnotations.removeAll()
		self.mapView.removeAnnotations(self.mapView.annotations)
		
		let database = Database()
		database.fetchData { (musollaArr) in
			DispatchQueue.main.async {
				for musolla in musollaArr {
					let musollaLocation = CLLocation.init(latitude: (musolla.location?.latitude)!, longitude: (musolla.location?.longitude)!)
					let userLocation = CLLocation.init(latitude: (self.userLocation?.latitude)!, longitude: (self.userLocation?.longitude)!)
					let distance = userLocation.distance(from: musollaLocation)
					
					if distance < 5000 { // 5km radius
						let musollaAnnotation = MusollaAnnotation.init(withCoordinate: musolla.location!, title: musolla.name, subtitle: musolla.address)
						
						self.mapView.addAnnotation(musollaAnnotation)
					}
				}
			}
		}
	}

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "toLocationSearch" {
			let locationSearchTVC = segue.destination as? LocationSearchTableViewController
			locationSearchTVC?.delegate = self
		}
    }
}
