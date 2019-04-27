//
//  BookListTableViewController.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/01.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit
import RealmSwift

class BookListTableViewController: TableVCWithSearchBar {
    
    @IBOutlet weak var searchBar: UISearchBar!

    var books: Results<Book>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        superSearchBar = searchBar
        searchBar.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)
        cell.textLabel?.text = books?[indexPath.row].authorOfBook ?? "Нет книг"
        return cell
    }
    
    
    @IBAction func addNewBook(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ToNewBook", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let book = books?[indexPath.row] {
                deleteFromRealm(book)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "bookInfo", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookInfo" {
            let destinationVC = segue.destination as! BookInformationVC
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.chosenBook = realm.object(ofType: Book.self, forPrimaryKey: books?[indexPath.row].accessionNumber)
//                RealmVC.bookAccessionNumber = books?[indexPath.row].accessionNumber

            }
        }
    }
    
    
    func load() {
        books = realm.objects(Book.self).filter("parentCategory.@count == 0").sorted(byKeyPath: "bookName")
        tableView.reloadData()
    }
    
    override func search() {
        
        if searchBar.text! != "" {
            books = realm.objects(Book.self).filter("authorLastName CONTAINS[cd] '\(searchBar.text!)' OR bookName CONTAINS[cd] '\(searchBar.text!)'").sorted(byKeyPath: "bookName")
        } else {
            load()
        }
        tableView.reloadData()
    }
    
}

