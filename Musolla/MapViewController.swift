//
//  MapViewController.swift
//  Musolla
//
//  Created by Muhd Mirza on 17/7/17.
//  Copyright © 2017 msociety. All rights reserved.
//

import UIKit
import MapKit

import Octokit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, LocationSelectProtocol {

	@IBOutlet var mapView: MKMapView!

	var locationManager: CLLocationManager?
	
	var userLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		print("View did load")

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

	@IBAction func repo() {
		let token = (UIApplication.shared.delegate as! AppDelegate).globalToken
	
		
	
		let dict: [String: Any] = [
			"uuid": "",
			"name": "Sheraton Towers",
			"address": "39 Scotts Rd, Singapore 228230",
			"location": [
				"latitude": 1.3119539999999998,
				"longitude": 103.836501
			],
			"type": "Musolla",
			"geohash": "",
			"mrt": "{NEAREST MRT (OPTIONAL)}",
			"directions": "Take the lift lobby carpark down to B4. Exit the door to the carpark and go down the stairs. Prayer area is at the right corner of the carpark. There is a tap next to the area.",
			"level": "B4",
			"provisions": "Prayer Mat, Telekung",
			"toiletLevel": "2",
			"unisexCapacity": 0,
			"maleCapacity": 2,
			"femaleCapacity": 2,
			"remarks": "{REMARKS IF ANY (OPTIONAL)}",
			"submitterName": "Norhana H.",
			"createdAt": "",
			"updatedAt": ""
		]
		
		let issueBody = "```swift\n\((dict as? NSDictionary)!)\n```"
		print("Issue body: \(issueBody)")
		
		let _ = Octokit.init(token!).postIssue(URLSession.shared, owner: "ruqqq", repository: "musolla-database", title: "Testing issue function", body: issueBody, assignee: nil) { (response) in
			switch response {
				case .success(let issue):
				break
				case .failure:
				break
				// handle any errors
			}
		}
		
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: LocationSelectProtocol delegate function
	func didSelect(location: MKMapItem?) {
		self.mapView.selectedAnnotations.removeAll()
		self.mapView.removeAnnotations(self.mapView.annotations)
		
		let musollaAnnotation = MusollaAnnotation.init(withCoordinate: (location?.placemark.coordinate)!, title: (location?.name)!, subtitle: nil, musolla: nil)
		self.mapView.addAnnotation(musollaAnnotation)
		
		
		let database = Database()
		database.fetchData { (musollaArr) in
			DispatchQueue.main.async {
				print("Fetching data after location select")
			
				for musolla in musollaArr {
					let selectedMusollaLocation = CLLocation.init(latitude: (location?.placemark.location?.coordinate.latitude)!, longitude: (location?.placemark.location?.coordinate.longitude)!)
					let musollaLocation = CLLocation.init(latitude: (musolla.location?.latitude)!, longitude: (musolla.location?.longitude)!)
					let distance = selectedMusollaLocation.distance(from: musollaLocation)
					
					if distance < 5000 { // 5km radius
						let musollaAnnotation = MusollaAnnotation.init(withCoordinate: musolla.location!, title: musolla.name, subtitle: musolla.address, musolla: musolla)
						
						self.mapView.addAnnotation(musollaAnnotation)
					}
				}
			}
		}
	}
	
	// MARK: CLLocationManagerDelegate delegate function
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
		let musollaDetailsVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MusollaDetailsViewController") as? MusollaDetailsViewController
		
		let selectedAnnotation = self.mapView.selectedAnnotations[0] as? MusollaAnnotation
		
		if let musolla = selectedAnnotation?.musolla {
			musollaDetailsVC?.musolla = musolla
			musollaDetailsVC?.sourceAnnotation = MusollaAnnotation.init(withCoordinate: userLocation!, title: "User location", subtitle: nil, musolla: nil)
			musollaDetailsVC?.destinationAnnotation = selectedAnnotation
			
			self.navigationController?.pushViewController(musollaDetailsVC!, animated: true)
		} else {
			let alert = UIAlertController.init(title: "Hold on", message: "This is just the location you intended to search. The other pins are the musollas", preferredStyle: .alert)
			let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
			
			alert.addAction(okAction)
			self.present(alert, animated: true, completion: nil)
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
		//print("Reloading map..")
	
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
						let musollaAnnotation = MusollaAnnotation.init(withCoordinate: musolla.location!, title: musolla.name, subtitle: musolla.address, musolla: musolla)
						
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
