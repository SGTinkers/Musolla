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
	let key: String?
	
	let address: String?
	let createdAtDate: String?
	let directions: String?
	//let geohash
	let level: Int?
	let location: CLLocationCoordinate2D?
	let trainStation: String?
	let name: String?
	let provision: String?
	let toiletLevel: Int?
	let type: String?
	let updatedAtDate: String?
	let uuid: String?
	
	init(key: String?, address: String?, createdAtDate: String?, directions: String?, level: Int?, location: CLLocationCoordinate2D?, trainStation: String?, name: String?, provision: String?, toiletLevel: Int?, type: String?, updatedAtDate: String?, uuid: String?) {
		self.key = key
		self.address = address
		self.createdAtDate = createdAtDate
		self.directions = directions
		self.level = level
		self.location = location
		self.trainStation = trainStation
		self.name = name
		self.provision = provision
		self.toiletLevel = toiletLevel
		self.type = type
		self.updatedAtDate = updatedAtDate
		self.uuid = uuid
	}
}
