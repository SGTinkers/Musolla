//
//  MusollaAnnotation.swift
//  Musolla
//
//  Created by Muhd Mirza on 20/7/17.
//  Copyright © 2017 msociety. All rights reserved.
//

import UIKit
import MapKit

class MusollaAnnotation: NSObject, MKAnnotation {
	var coordinate = CLLocationCoordinate2D()
	var title: String?
	var subtitle: String?
	
	// add an instance here so it's easier to reference when annotation is tapped on
	var musolla: Musolla?

	init(withCoordinate coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, musolla: Musolla?) {
		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
		self.musolla = musolla
	}
}
