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

	init(withCoordinate coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
	}
}
