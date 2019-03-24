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
//    let realm = try! Realm()
    var readers: Results<Reader>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        superSearchBar = searchBar
        searchBar.delegate = self
        load()
        self.hideKeyboardWhenScreenTapped()
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
    
    @IBAction func addReader(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ToNewReader", sender: self)
//        let alertController = UIAlertController(title: "Добавить читателя:", message: "", preferredStyle: .alert)
//        let alertAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
//
//            guard let lastName = alertController.textFields?[0].text else { print("Введите фамилию"); return }
//            guard let firstName = alertController.textFields?[1].text else { print("Введите имя"); return }
//            guard let patronymic = alertController.textFields?[2].text else { print("Введите отчество"); return }
//
//            let newReader = Reader()
//            newReader.firstName = firstName
//            newReader.lastName = lastName
//            newReader.patronymic = patronymic
//            self.saveToRealm(newReader)
//
//        }
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Фамилия"
//            textField.autocapitalizationType = .sentences
//        }
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Имя"
//            textField.autocapitalizationType = .sentences
//        }
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Отчество"
//            textField.autocapitalizationType = .sentences
//        }
//        alertController.addAction(alertAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
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
