//
//  Database.swift
//  Musolla
//
//  Created by Muhd Mirza on 15/7/17.
//  Copyright © 2017 msociety. All rights reserved.
//

import Foundation
import MapKit

class Database {
	let url = URL.init(string: "https://raw.githubusercontent.com/ruqqq/musolla-database/master/data.json")
	
	init() {
		var request = URLRequest.init(url: url!)
		
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	}
	
	func fetchData(completion: @escaping (_ musolla: [Musolla]) -> Void) {
		let dataTask = URLSession.shared.dataTask(with: self.url!) { (data, response, error) in
			let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
			var musollaArr = [Musolla]()

//			do this if you want, the forEach is just fancier
//
//			for (key, value) in json!! {
//				print("Key: \(key)")
//				print("Value: \(value)")
//			}
			
			json!!.forEach({ (dict: (key: String, value: Any)) in
//				print("Key: \(dict.key)")
//				print("Value: \(dict.value)")
				
				let individualMusollaDetail = dict.value as? [String: Any]
				
				let createdAtDate = individualMusollaDetail?["createdAt"] as? String
				let name = individualMusollaDetail?["name"] as? String
				let address = individualMusollaDetail?["address"] as? String
				let trainStation = individualMusollaDetail?["mrt"] as? String
				let level = individualMusollaDetail?["level"] as? Int
				let toiletLevel = individualMusollaDetail?["toiletLevel"] as? Int
				let femalePax = individualMusollaDetail?["femaleCapacity"] as? Int
				let malePax = individualMusollaDetail?["maleCapacity"] as? Int
				let unisexPax = individualMusollaDetail?["unisexCapacity"] as? Int
				let directions = individualMusollaDetail?["directions"] as? String
				let provision = individualMusollaDetail?["provision"] as? String
				let remarks = individualMusollaDetail?["remarks"] as? String
				let submitterName = individualMusollaDetail?["submitterName"] as? String
				
				let key = dict.key
				let uuid = individualMusollaDetail?["uuid"] as? String
				
				let locationDict = individualMusollaDetail?["location"] as? [String: Any]
				let latitude = locationDict?["latitude"] as? Double
				let longitude = locationDict?["longitude"] as? Double
				let location = CLLocationCoordinate2D.init(latitude: latitude!, longitude: longitude!)
				
				let type = individualMusollaDetail?["type"] as? String
				
				
				let musolla = Musolla.init(createdAtDate: createdAtDate, name: name, address: address, trainStation: trainStation, level: level, toiletLevel: toiletLevel, femalePax: femalePax, malePax: malePax, unisexPax: unisexPax, directions: directions, provision: provision, remarks: remarks, submitterName: submitterName, key: key, uuid: uuid, location: location, type: type)
				musollaArr.append(musolla)
			})

			completion(musollaArr)
		}
		
		dataTask.resume()
	}
}
