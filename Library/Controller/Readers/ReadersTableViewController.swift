//
//  ReadersTableViewController.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/01.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit
import RealmSwift

class ReadersTableViewController: TableVCWithSearchBar {
    
    var readers: Results<Reader>?
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageRightBarButtonItem(#selector(goToNewReaderVC))
        
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        superSearchBar = searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readers?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readerCell", for: indexPath)
        cell.textLabel?.text = readers?[indexPath.row].fullName ?? "Нет читателей"
        cell.backgroundColor = .clear
        cell.backgroundColor = readers![indexPath.row].returnDelay ? .red : .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readerCell")
        cell?.textLabel?.text = "ФИО Читателя"
        cell?.backgroundColor = UIColor.headerColor
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let reader = readers?[indexPath.row] else { return }
            deleteFromRealm(reader)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let bookToTake = chosenBook {
            let selectedReader = readers![indexPath.row]
            
            guard !selectedReader.returnDelay else {
                let message = "У выбранного читателя имеется задолженность."
                simpleAlert(message: message) {_ in tableView.deselectRow(at: indexPath, animated: true)}
                return
            }
            
            let alertController = UIAlertController(title: "На сколько дней выдается книга?", message: "", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Выдать", style: .default) { (action) in
                guard let numberOfDays = Int(alertController.textFields![0].text!) else { return }
                try! self.realm.write {
                    bookToTake.returnDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: Date())
                    bookToTake.borrower = selectedReader
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) {_ in
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Введите количество дней."
                textField.keyboardType = UIKeyboardType.numberPad
            }
            alertController.addAction(alertAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: "toReaderInfo", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func addReader(_ sender: UIBarButtonItem) {
        goToNewReaderVC()
    }
    
    @objc func goToNewReaderVC() {
        performSegue(withIdentifier: "ToNewReader", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReaderInfo" {
            let destinationVC = segue.destination as! ReaderInformationVC
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            destinationVC.selectedReader = readers?[indexPath.row]
        }
    }
    
    func load() {
        readers = realm.objects(Reader.self).sorted(byKeyPath: "lastName")
        tableView.reloadData()
    }
    
    override func search() {
        
        if searchBar.text! != "" {
            readers = realm.objects(Reader.self).filter("lastName CONTAINS[cd] '\(searchBar.text!)'").sorted(byKeyPath: "lastName")
        } else {
            load()
        }
        
        tableView.reloadData()
    }
    
}
