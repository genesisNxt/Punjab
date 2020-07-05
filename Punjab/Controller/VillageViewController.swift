//
//  VillageViewController.swift
//  Punjab
//
//  Created by PARMJIT SINGH KHATTRA on 4/7/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import CoreData

class VillageViewController: SwipeTableViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var village = [Village]()
    let constant = Constant()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCity:  City?   // selected city from CityViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75.0
        tableView.dataSource = self
        searchBar.delegate = self
        loadVillage()
    }
    
    // MARK:- delete method
    override func updateModel(at indexPath: IndexPath) {
                    self.context.delete(self.village[indexPath.row])
                    self.village.remove(at: indexPath.row)
                    self.saveVillage()
    }
   // MARK:- Save Village
    @IBAction func addVillage(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Village", message: "Punjab Village", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newVillage = Village(context: self.context)
            newVillage.villageName = textField.text!
            newVillage.parentCity = self.selectedCity
            self.village.append(newVillage)
            self.saveVillage()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "village"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    // MARK:- Save Village
    func saveVillage(){
        do {
            try context.save()
        } catch  {
            print("Error Saving\(error)")
        }
        //tableView.reloadData()
    }
    // MARK:- Load Village
    func loadVillage(with request: NSFetchRequest<Village> = Village.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCity.cityName MATCHES %@", selectedCity!.cityName!)
        if let additonalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additonalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do {
           village = try context.fetch(request)
        } catch  {
            print("Error Loading\(error)")
        }
        tableView.reloadData()
    }
    // MARK:- UITableView DataSource Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return village.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = village[indexPath.row].villageName
        
        return cell
    }
}
extension VillageViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Village> = Village.fetchRequest()
        let predicate = NSPredicate(format: "villageName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "villageName", ascending: true)]
        loadVillage(with: request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         
               if searchBar.text?.count == 0 {
                  loadVillage()
                   DispatchQueue.main.async {
                       self.tableView.resignFirstResponder()
                   }
               }
    }
}

