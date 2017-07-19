//
//  LocationSearchTableViewController.swift
//  Musolla
//
//  Created by Muhd Mirza on 19/7/17.
//  Copyright © 2017 msociety. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {

	/*
		we gonna take whatever we get from the search bar updates
		and put it into the local search completer's query text
		
		through the local search completer's delegate, we get the filtered results
		and put it in an filtered array
		
		and we display the filtered array in the table view
		
		on cell row select, we get the item's title and put it through MKLocalSearchRequest's
		natural language query
		
		whatever we get is whatever we pass back
	*/

	var searchController: UISearchController?
	var localSearchCompleter: MKLocalSearchCompleter?
	
	var filteredLocation: [MKLocalSearchCompletion]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		self.searchController = UISearchController.init(searchResultsController: nil)
		self.searchController?.dimsBackgroundDuringPresentation = false
		self.searchController?.hidesNavigationBarDuringPresentation = false
		self.definesPresentationContext = true
		
		self.localSearchCompleter = MKLocalSearchCompleter()
		self.localSearchCompleter?.delegate = self
		
		self.searchController?.searchBar.delegate = self
		self.tableView.tableHeaderView = self.searchController?.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		if let filteredLocationsCount = self.filteredLocation?.count {
			return filteredLocationsCount
		}
		
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
		cell.textLabel?.text = self.filteredLocation?[indexPath.row].title
		cell.detailTextLabel?.text = self.filteredLocation?[indexPath.row].subtitle

        return cell
    }
	
	// MARK: UISearchBarDelegate
	public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.localSearchCompleter?.queryFragment = searchText
	}
	
	
	// MARK: MKLocalSearchCompleterDelegate
	public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		print("Count: \(completer.results.count)")
		self.filteredLocation = completer.results
		
		self.tableView.reloadData()
	}
}
