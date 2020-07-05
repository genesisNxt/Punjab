//
//  CityViewController.swift
//  Punjab
//
//  Created by PARMJIT SINGH KHATTRA on 4/7/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import CoreData
class CityViewController: SwipeTableViewController {
    
    let constant = Constant()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var city = [City]()
    @IBOutlet weak var tableview: UITableView!
    var selectedDist : District?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = 75.0
        loadCity()
    }
    // MARK:- Add City
    
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add City", message: "Punjab City", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCity = City(context: self.context)
            newCity.cityName = textField.text!
            newCity.parentDistrict = self.selectedDist
            self.city.append(newCity)
            self.saveCity()
            self.tableview.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "new City"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    // MARK:- Save City
    func saveCity(){
        do {
            try context.save()
        } catch  {
            print("Error Saving\(error)")
        }
        
    }
    // MARK:- loadCity
    func loadCity(with request: NSFetchRequest<City> = City.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentDistrict.distName MATCHES %@", selectedDist!.distName!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do {
            city = try context.fetch(request)
        } catch  {
            print("Error Loading\(error)")
        }
        tableview.reloadData()
    }
    // MARK:- delete methods
    override func updateModel(at indexPath: IndexPath) {
        context.delete(city[indexPath.row])
        city.remove(at: indexPath.row)
        saveCity()
    }
    
// MARK:- UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return city.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = city[indexPath.row].cityName
        return cell
    }
}
// MARK:- UITableView Delegate
extension CityViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: constant.goToVillage, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destnationVC = segue.destination as! VillageViewController
        if let indexPath = tableview.indexPathForSelectedRow {
            destnationVC.selectedCity = city[indexPath.row]
        }
    }
}
// MARK:- UISearchBar Delegate
extension CityViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "cityName CONTAINS[cd] %@",searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "cityName", ascending: true)]
        loadCity(with: request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCity()
            DispatchQueue.main.async {
                self.tableview.resignFirstResponder()
            }
        }
    }
}
