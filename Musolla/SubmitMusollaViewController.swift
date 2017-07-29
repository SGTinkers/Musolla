//
//  SubmitMusollaViewController.swift
//  Musolla
//
//  Created by Muhd Mirza on 24/7/17.
//  Copyright © 2017 msociety. All rights reserved.
//

import UIKit
import MapKit

import Octokit

class SubmitMusollaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, LocationSelectProtocol {

	@IBOutlet var tableView: UITableView!
	
	var musollaDetailsDescription: [String]?
	
	// to submit
	var coord: CLLocationCoordinate2D?
	
	// keyboard stuff
	var cellYForCurrentActiveTextfield: CGFloat?
	var currentActiveTextfield: UITextField?
	
	// helper var
	let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//		self.musollaDetailsDescription = ["Created At", "Name", "Address", "MRT", "level", "toiletLevel", "Female Capacity", "Male Capacity", "Unisex Capacity", "Directions", "Provision", "Remarks", "Submitter name"]
		
		self.musollaDetailsDescription = ["Name", "Address", "MRT", "level", "toiletLevel", "Female Capacity", "Male Capacity", "Unisex Capacity", "Directions", "Provision", "Remarks"]
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		self.tableView.separatorStyle = .none
    }
	
	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: .UIKeyboardDidShow, object: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Keyboard notification
	func keyboardDidShow(notification: NSNotification) {
		let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

		print("Cell Y origin: \(self.cellYForCurrentActiveTextfield!)")
		print("Keyboard: \((keyboardRect?.origin.y)! - 80)")

		// 150 pixels
		// On tap of the last textfield that its Y pos is not more that the keyboard height.
		// Scroll further up so that it's easy for user to tap on next textfield
		// of which its Y pos is actually more than the keyboard
		if self.cellYForCurrentActiveTextfield! > (keyboardRect?.origin.y)! - 150 {
			let heightDifference = self.cellYForCurrentActiveTextfield! - ((keyboardRect?.origin.y)! - 150)
			// extra 100 just to pull scrollview up a little bit to show textfield
			let pullUp = heightDifference + 100
			
			let contentOffset = CGPoint.init(x: 0, y: pullUp)
			self.tableView.setContentOffset(contentOffset, animated: true)
		}
	}
	
	// MARK: Submit action
	@IBAction func submitMusollaDetails() {
		let name = self.getTextfieldTextFromRow(0)
		if name.isEmpty {
			self.showAlert()
		}
		
		let address = self.getTextfieldTextFromRow(1)
		if address.isEmpty {
			self.showAlert()
		}
		
		let trainStation = self.getTextfieldTextFromRow(2)
		if trainStation.isEmpty {
			self.showAlert()
		}
		
		let level = self.getTextfieldTextFromRow(3)
		if level.isEmpty {
			self.showAlert()
		}
		
		let toiletLevel = self.getTextfieldTextFromRow(4)
		if toiletLevel.isEmpty {
			self.showAlert()
		}
		
		let femaleCapacity = self.getTextfieldTextFromRow(5)
		if femaleCapacity.isEmpty {
			self.showAlert()
		}
		
		let maleCapacity = self.getTextfieldTextFromRow(6)
		if maleCapacity.isEmpty {
			self.showAlert()
		}
		
		let unisexCapacity = self.getTextfieldTextFromRow(7)
		if unisexCapacity.isEmpty {
			self.showAlert()
		}
		
		let directions = self.getTextfieldTextFromRow(8)
		if directions.isEmpty {
			self.showAlert()
		}
		
		let provisions = self.getTextfieldTextFromRow(9)
		if provisions.isEmpty {
			self.showAlert()
		}
		
		let remarks = self.getTextfieldTextFromRow(10)
		if remarks.isEmpty {
			self.showAlert()
		}
		
		var submitterName = ""
		
		let token = (UIApplication.shared.delegate as! AppDelegate).globalToken
		let _ = Octokit.init(token!).me { (response) in
			switch response {
				case.success(let user):
				
				submitterName = user.name!
				
				break
	
				case .failure(let error):
				break
			}
		}
		
		let date = self.getStringForDateToday()
		print("Date: \(date)")
	
		let dict: [String: Any] = [
			"uuid": "",
			"name": name,
			"address": address,
			"location": [
				"latitude": (self.coord?.latitude)!,
				"longitude": (self.coord?.longitude)!
			],
			"type": "Musolla",
			"geohash": "",
			"mrt": trainStation,
			"directions": directions,
			"level": level,
			"provisions": provisions,
			"toiletLevel": toiletLevel,
			"unisexCapacity": unisexCapacity,
			"maleCapacity": maleCapacity,
			"femaleCapacity": femaleCapacity,
			"remarks": remarks,
			"submitterName": submitterName,
			"createdAt": date,
			"updatedAt": date
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
	
	// MARK: Helper functions
	func getTextfieldTextFromRow(_ row: Int) -> String {
		let indexPath = IndexPath.init(row: row, section: 0)
		let cell = self.tableView.cellForRow(at: indexPath) as? SubmitMusollaTableViewCell

		return (cell?.textfield.text)!
	}
	
	func setTextfieldTextFromRow(_ row: Int, With text: String) {
		let indexPath = IndexPath.init(row: row, section: 0)
		let cell = self.tableView.cellForRow(at: indexPath) as? SubmitMusollaTableViewCell
		
		cell?.textfield.text = text
	}
	
	func showAlert() {
		let alert = UIAlertController.init(title: "Hold on", message: "Some fields are missing", preferredStyle: .alert)
		let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
		
		alert.addAction(okAction)
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func dismissKeyboard() {
		self.currentActiveTextfield?.resignFirstResponder()
		
		self.tableView.setContentOffset(.zero, animated: true)
	}
	
	// helper functions
	func getStringForDateToday() -> String {
		// set dateformatter format to given date format
		// 2017-07-28 08:13:54 +0000
		self.dateFormatter.timeZone = TimeZone.autoupdatingCurrent
		self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
		
		let dateString = self.dateFormatter.string(from: Date())

		// get the date object
		if let date = self.dateFormatter.date(from: dateString) {
			// set dateformatter format to date format you want
			// 2014-12-23T06:53:45.910Z
			dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
			
			// TIL, use the same quotations you use with T for Z if you want the date to appear
			// this way: 2014-12-23T06:53:45.910Z
			// else you'll end up with 2014-12-23T06:53:45.910+0000
			// if you do yyyy-MM-dd'T'HH:mm:ss.sssZ
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"
			
			return self.dateFormatter.string(from: date)
		} else {
			print("Error")
		}
		
		return "Error"
	}
	
	// MARK: Location select protocol
	func didSelect(location: MKMapItem?) {
		let name = (location?.placemark.name)!
		let title = (location?.placemark.title)!
		
		print("Name: \(name)")
		print("Title: \(title)")

		self.setTextfieldTextFromRow(0, With: name)
		self.setTextfieldTextFromRow(1, With: title)
		
		self.coord = CLLocationCoordinate2D.init(latitude: (location?.placemark.coordinate.latitude)!, longitude: (location?.placemark.coordinate.longitude)!)
	}
	
	// MARK: UIScrollView function
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// since we already conformed to the UITableView protocols
		// we also already conformed to UIScrollView protocols
		// hence in this case, the scrollView refers to the tableView
		// isDragging looks for manual user scrolling
	
		if scrollView.isDragging {
			self.currentActiveTextfield?.resignFirstResponder()
		}
	}
	
	// MARK: UITableViewDataSource functions
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.musollaDetailsDescription?.count)!
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SubmitMusollaTableViewCell
		
		cell?.label.text = self.musollaDetailsDescription?[indexPath.row]
		cell?.tag = indexPath.row
		
		if indexPath.row == 0 { // name
			cell?.textfield.isUserInteractionEnabled = false
		}
		
		if indexPath.row == 1 { // address
			cell?.textfield.isUserInteractionEnabled = false
		}
		
		cell?.selectionStyle = .none
		cell?.textfield.delegate = self
		
		if indexPath.row >= 3 && indexPath.row <= 7 { // level to unisex capacity
			let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 44))
			
			let cancelBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(self.dismissKeyboard))

			toolbar.setItems([cancelBarButtonItem], animated: true)
			
			cell?.textfield.keyboardType = .numberPad
			cell?.textfield.inputAccessoryView = toolbar
		}
		
		return cell!
	}
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	// MARK: UITableView delegate
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 || indexPath.row == 1 {
			let locationSearchTVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LocationSearchTableViewController") as? LocationSearchTableViewController
			locationSearchTVC?.delegate = self

			// remember to remove keyboard notif
			NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
			
			self.navigationController?.pushViewController(locationSearchTVC!, animated: true)
		}
	}

	// MARK: UITextfieldDelegate functions
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		print("textFieldDidBeginEditing")
		
		// if you look at main.storyboard
		// textfield is in a content view, and that content view is in a cell
		// so this is actually the cell's y origin
		self.cellYForCurrentActiveTextfield = (textField.superview?.superview?.frame.origin.y)!
		
		self.currentActiveTextfield = textField
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		self.tableView.setContentOffset(.zero, animated: true)
		
		self.currentActiveTextfield = nil
		
		return true
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
