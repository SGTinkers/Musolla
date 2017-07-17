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
				print("Key: \(dict.key)")
				print("Value: \(dict.value)")
				
				let key = dict.key
				
				let individualMusollaDetail = dict.value as? [String: Any]
				
				let address = individualMusollaDetail?["address"] as? String
				let createdAtDate = individualMusollaDetail?["createdAt"] as? String
				let directions = individualMusollaDetail?["directions"] as? String
				let level = individualMusollaDetail?["level"] as? Int
				
				let locationDict = individualMusollaDetail?["location"] as? [String: Any]
				let latitude = locationDict?["latitude"] as? Double
				let longitude = locationDict?["longitude"] as? Double
				let location = CLLocation.init(latitude: latitude!, longitude: longitude!)
				
				let trainStation = individualMusollaDetail?["mrt"] as? String
				let name = individualMusollaDetail?["name"] as? String
				let provision = individualMusollaDetail?["provision"] as? String
				let toiletLevel = individualMusollaDetail?["toiletLevel"] as? Int
				let type = individualMusollaDetail?["type"] as? String
				let updatedAtDate = individualMusollaDetail?["updatedAt"] as? String
				let uuid = individualMusollaDetail?["uuid"] as? String
				
				let musolla = Musolla.init(key: key, address: address, createdAtDate: createdAtDate, directions: directions, level: level, location: location, trainStation: trainStation, name: name, provision: provision, toiletLevel: toiletLevel, type: type, updatedAtDate: updatedAtDate, uuid: uuid)
				musollaArr.append(musolla)
			})

			completion(musollaArr)
		}
		
		dataTask.resume()
	}
}
