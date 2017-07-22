//
//  MusollaDetails.swift
//  Musolla
//
//  Created by Muhd Mirza on 15/7/17.
//  Copyright © 2017 msociety. All rights reserved.
//

import Foundation
import MapKit

class Musolla {
	// user can see this
	let createdAtDate: String?
	let name: String?
	let address: String?
	let trainStation: String?
	let level: Int?
	let toiletLevel: Int?
	let femalePax: Int?
	let malePax: Int?
	let unisexPax: Int?
	let directions: String?
	let provision: String?
	let remarks: String?
	let submitterName: String? // github name for now

	// user does not need to see these
	let key: String?
	let uuid: String?
	let location: CLLocationCoordinate2D?
	let type: String?
	
	//	hold off on these properties
	//	let updatedAtDate: String?
	//	let geohash
	
	init(createdAtDate: String?, name: String?, address: String?, trainStation: String?, level: Int?, toiletLevel: Int?, femalePax: Int?, malePax: Int?, unisexPax: Int?, directions: String?, provision: String?, remarks: String?, submitterName: String?, key: String?, uuid: String?, location: CLLocationCoordinate2D?, type: String?) {
		self.createdAtDate = createdAtDate
		self.name = name
		self.address = address
		self.trainStation = trainStation
		self.level = level
		self.toiletLevel = toiletLevel
		self.femalePax = femalePax
		self.malePax = malePax
		self.unisexPax = unisexPax
		self.directions = directions
		self.provision = provision
		self.remarks = remarks
		self.submitterName = submitterName
	
		self.key = key
		self.uuid = uuid
		self.location = location
		self.type = type
	}
}
