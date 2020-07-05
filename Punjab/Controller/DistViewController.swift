//
//  ViewController.swift
//  Punjab
//
//  Created by PARMJIT SINGH KHATTRA on 4/7/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import CoreData

class DistViewController: SwipeTableViewController {

    @IBOutlet weak var tableView: UITableView!
    let constant = Constant()
    var distt = [District]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75.0
    loadDistt()
    }
// MARK:- Add Distt
    @IBAction func addDistt(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "dist Name", message: "Punjab distt", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            let newDistt = District(context: self.context)
            newDistt.distName = textField.text!
            self.distt.append(newDistt)
            self.saveDistt()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "new punjab distt"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
// MARK:- save Distt
    func saveDistt(){
        do {
            try context.save()
        } catch  {
            print("Error Saving\(error)")
        }
        
    }
    
    // MARK:- load Distt
    func loadDistt(with request: NSFetchRequest<District> = District.fetchRequest()){
        do {
          distt = try context.fetch(request)
        } catch  {
            print("Error Loading\(error)")
        }
        tableView.reloadData()
    }
    // MARK:- delete methods
    override func updateModel(at indexPath: IndexPath) {
        context.delete(distt[indexPath.row])
        distt.remove(at: indexPath.row)
        saveDistt()
    }
    // MARK:- UITableView datasourse methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return distt.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = distt[indexPath.row].distName
        return cell
    }
}
    // MARK:- UITableView delegate methods
extension DistViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: constant.goToCity, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CityViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedDist = distt[indexPath.row]
        }
    }
}
extension DistViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<District> = District.fetchRequest()
        let predicate = NSPredicate(format: "distName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "distName", ascending: true)]
        request.predicate = predicate
        loadDistt(with: request)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loadDistt()
            DispatchQueue.main.async {
                self.tableView.resignFirstResponder()
            }
        }
    }
}
