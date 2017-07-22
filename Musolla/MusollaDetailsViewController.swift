//
//  MusollaDetailsViewController.swift
//  Musolla
//
//  Created by Muhd Mirza on 22/7/17.
//  Copyright © 2017 msociety. All rights reserved.
//

import UIKit

class MusollaDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet var tableView: UITableView!

	var musolla: Musolla?
	var musollaDetailsDescription: [String]?
	var musollaDetails: [String?]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.musollaDetailsDescription = ["Created At", "Name", "Address", "MRT", "level", "toiletLevel", "Female Capacity", "Male Capacity", "Unisex Capacity", "Directions", "Provision", "Remarks", "Submitter name"]
		
		if let musolla = self.musolla {
			self.musollaDetails = [musolla.createdAtDate, musolla.name, musolla.address, musolla.trainStation, "\(musolla.level)", "\(musolla.toiletLevel)", "\(musolla.femalePax)", "\(musolla.malePax)", "\(musolla.unisexPax)", musolla.directions, musolla.provision, musolla.remarks, musolla.submitterName]
		}
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
		cell.detailTextLabel?.text = self.musollaDetails?[indexPath.row]
		
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
