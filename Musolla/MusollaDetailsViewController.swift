//
//  MusollaDetailsViewController.swift
//  Musolla
//
//  Created by Muhd Mirza on 22/7/17.
//  Copyright © 2017 msociety. All rights reserved.
//

import UIKit
import MapKit

class MusollaDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {

	@IBOutlet var mapView: MKMapView!
	@IBOutlet var tableView: UITableView!

	var musolla: Musolla?
	var musollaDetailsDescription: [String]?
	var musollaDetails: [String?]?
	
	var sourceAnnotation: MusollaAnnotation?
	var destinationAnnotation: MusollaAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.musollaDetailsDescription = ["Created At", "Name", "Address", "MRT", "level", "toiletLevel", "Female Capacity", "Male Capacity", "Unisex Capacity", "Directions", "Provision", "Remarks", "Submitter name"]
		
		if let musolla = self.musolla {
			self.musollaDetails = [musolla.createdAtDate, musolla.name, musolla.address, musolla.trainStation, "\(musolla.level)", "\(musolla.toiletLevel)", "\(musolla.femalePax)", "\(musolla.malePax)", "\(musolla.unisexPax)", musolla.directions, musolla.provision, musolla.remarks, musolla.submitterName]
		}
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		// set map
		self.mapView.showsUserLocation = true
		self.mapView.mapType = .standard
		self.mapView.delegate = self
		self.mapView.isZoomEnabled = false
		self.mapView.isScrollEnabled = false
		
		self.mapView.selectedAnnotations.removeAll()
		self.mapView.removeAnnotations(self.mapView.annotations)
		
		self.mapView.addAnnotation(sourceAnnotation!)
		self.mapView.addAnnotation(destinationAnnotation!)
		
		self.mapView.setCenter((self.sourceAnnotation?.coordinate)!, animated: true)
		
		// set route visuals
		let sourcePlacemark = MKPlacemark.init(coordinate: (self.sourceAnnotation?.coordinate)!)
		let destinationPlacemark = MKPlacemark.init(coordinate: (self.destinationAnnotation?.coordinate)!)
		
		let directionsRequest = MKDirectionsRequest()
		directionsRequest.source = MKMapItem.init(placemark: sourcePlacemark)
		directionsRequest.destination = MKMapItem.init(placemark: destinationPlacemark)
		directionsRequest.transportType = .automobile
		
		let directions = MKDirections.init(request: directionsRequest)
		directions.calculate { (directionsResponse, error) in
			if let route = directionsResponse?.routes[0] {
				self.mapView.add(route.polyline)
				
				// frame the map so the lines and pins can be seen
				self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(30, 30, 30, 30), animated: true)
			}
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func getDirections() {
		let selectedPlacemark = MKPlacemark.init(coordinate: (self.destinationAnnotation?.coordinate)!)
		let selectedMapItem = MKMapItem.init(placemark: selectedPlacemark)
		
		selectedMapItem.name = (self.musolla?.name)!
		selectedMapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
	}
	
	// MARK: MKMapViewDelegate functions
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer.init(overlay: overlay)
		
		if overlay is MKPolyline {
			renderer.strokeColor = UIColor.blue
			renderer.lineWidth = 5
		}
		
		return renderer
	}
	
	// MARK: UITableViewDataSource delegate functions
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.musollaDetailsDescription?.count)!
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = self.musollaDetailsDescription?[indexPath.row]
		print("Details description: \(self.musollaDetailsDescription?[indexPath.row])")
		if let detail = self.musollaDetails?[indexPath.row] {
			if detail == "nil" {
				cell.detailTextLabel?.text = "Information is not available"
			} else {
				cell.detailTextLabel?.text = detail
			}
		} else {
			cell.detailTextLabel?.text = "Information is not available"
		}
		
		return cell
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
