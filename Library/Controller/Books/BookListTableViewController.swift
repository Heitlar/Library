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
//    let realm = try! Realm()
    var books: Results<Book>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        superSearchBar = searchBar
        searchBar.delegate = self
        load()
//        self.hideKeyboardWhenScreenTapped()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)
        
        cell.textLabel?.text = books?[indexPath.row].authorOfABook ?? "Нет книг"
        
        return cell
    }
    
    
    @IBAction func addNewBook(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ToNewBook", sender: self)
        
//        let alertController = UIAlertController(title: "Введите название книги и имя автора", message: "", preferredStyle: .alert)
//        let alertAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
//
//            guard let authorName = alertController.textFields?[0].text else { print("No author name"); return }
//            guard let bookName = alertController.textFields?[1].text else { print("No book name"); return }
//
//            let newBook = Book()
//            newBook.authorName = authorName
//            newBook.bookName = bookName
//            self.saveToRealm(newBook)
//        }
//
//        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Имя автора"
//            textField.autocapitalizationType = .words
//        }
//
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Название книги"
//            textField.autocapitalizationType = .sentences
//        }
//
//        alertController.addAction(alertAction)
//        alertController.addAction(cancel)
//        present(alertController, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let book = books?[indexPath.row] {
                deleteFromRealm(book)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row \(indexPath.row)")
        performSegue(withIdentifier: "bookInfo", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookInfo" {
            let destinationVC = segue.destination as! BookInformationVC
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.chosenAuthor = books?[indexPath.row].authorName
                destinationVC.chosenBook = books?[indexPath.row].bookName

            }
        }
    }
    
    
    func load() {
        books = realm.objects(Book.self).sorted(byKeyPath: "bookName")
        tableView.reloadData()
    }
    
    override func search() {
        
        if searchBar.text! != "" {
            books = realm.objects(Book.self).filter("authorName CONTAINS[cd] '\(searchBar.text!)' OR bookName CONTAINS[cd] '\(searchBar.text!)'").sorted(byKeyPath: "bookName")
        } else {
            load()
        }
        tableView.reloadData()
    }
    
}

