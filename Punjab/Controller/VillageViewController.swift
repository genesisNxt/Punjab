//
//  VillageViewController.swift
//  Punjab
//
//  Created by PARMJIT SINGH KHATTRA on 4/7/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class VillageViewController: UIViewController {

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
        tableView.delegate = self
        searchBar.delegate = self
        loadVillage()
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
}
    // MARK:- UITableView DataSource Methods
extension VillageViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return village.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.villageCell, for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = village[indexPath.row].villageName
        cell.delegate = self
        return cell
    }
}
extension VillageViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(village[indexPath.row])
//        village.remove(at: indexPath.row)
//        tableView.reloadData()
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
extension VillageViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        self.context.delete(self.village[indexPath.row])
        self.village.remove(at: indexPath.row)
        self.saveVillage()
        
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "trash-circle")

        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
}


