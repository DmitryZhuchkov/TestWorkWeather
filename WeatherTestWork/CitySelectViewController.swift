//
//  ToDoListViewController.swift
//  ToDoListWithCoreData
//
//  Created by Mohammed S A Kwaik on 10/9/17.
//  Copyright © 2017 Mohammed S A Kwaik. All rights reserved.
//

import UIKit
import CoreData
import MapKit
class CitySelectViewController: UIViewController,UITextFieldDelegate {
    
 
    @IBOutlet weak var cityAutoComplete: UISearchBar!
    @IBOutlet weak var notesTableView: UITableView!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        cityAutoComplete.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  }


extension CitySelectViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
}

extension CitySelectViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        notesTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension CitySelectViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension CitySelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            var coordinate:CLLocationCoordinate2D
            guard let vc = self.storyboard?.instantiateViewController(identifier: "City") as? CityViewController else { return }
            coordinate = (response?.mapItems[0].placemark.coordinate)!
            print(coordinate)
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.coor = coordinate
            vc.Name = searchRequest.naturalLanguageQuery
            self.navigationController?.pushViewController(vc, animated: true)
            
    }
}
}
