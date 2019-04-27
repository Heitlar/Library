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

    @IBOutlet weak var searchBar: UISearchBar!

    var readers: Results<Reader>?

    override func viewDidLoad() {
        super.viewDidLoad()
        superSearchBar = searchBar
        searchBar.delegate = self
        
//        self.hideKeyboardWhenScreenTapped()
//        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
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

        return cell
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
            
            try! realm.write {
                selectedReader.booksInUse.append(bookToTake)
            }
            
            chosenBook = nil
            
            simpleAlert(message: "Книга была выдана читателю.") { alert in
                self.navigationController?.popToRootViewController(animated: true)
            }

        } else {
            performSegue(withIdentifier: "toReaderInfo", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func addReader(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ToNewReader", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReaderInfo" {
            let destinationVC = segue.destination as! ReaderInformationVC
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            if readers![indexPath.row].booksInUse.count > 0 {
                destinationVC.chosenBook = readers?[indexPath.row].booksInUse[0]
                destinationVC.selectedReader = realm.object(ofType: Reader.self, forPrimaryKey: readers?[indexPath.row].libraryCardNumber)
//                RealmVC.libraryCardOfReader = readers?[indexPath.row].libraryCardNumber
            } else {
                destinationVC.chosenBook = nil
            }
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
