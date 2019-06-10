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
    
    let searchBar = UISearchBar()
    
    var books: Results<Book>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        superSearchBar = searchBar
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 1
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! bookCell

        cell.setBorder(width: 0.5)
        cell.authorNameLabel.text = books?[indexPath.row].authorFullName
        cell.bookNameLabel.text = books?[indexPath.row].bookName
        cell.backgroundColor = books?[indexPath.row].borrower == nil ? .clear : .lightGray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell") as? bookCell else { return nil }
        cell.backgroundColor = UIColor.headerColor

        cell.setBorder(width: 0.5)
        cell.authorNameLabel.textAlignment = NSTextAlignment.center
        cell.bookNameLabel.textAlignment = NSTextAlignment.center
        cell.authorNameLabel.text = "Имя автора"
        cell.bookNameLabel.text = "Название книги"
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            if let book = self.books?[indexPath.row] {
                self.deleteFromRealm(book)
            }
        }
        delete.backgroundColor = .red
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.chosenBook = self.books?[indexPath.row]
            self.performSegue(withIdentifier: "editBookDetails", sender: self)
        }
        edit.backgroundColor = .orange
        
        return [delete, edit]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "bookInfo", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addNewBook(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ToNewBook", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "bookInfo" {
            let destinationVC = segue.destination as! BookInformationVC
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            destinationVC.chosenBook = books?[indexPath.row]
        } else if segue.identifier == "editBookDetails" {
            let destinationVC = segue.destination as! NewBookViewController
                destinationVC.editExistingBook = true
                destinationVC.chosenBook = chosenBook
        }
    }
    
    
    func load() {
        books = realm.objects(Book.self)
//            .filter("borrower == nil")
        
        //            .sorted(byKeyPath: "bookName")
        tableView.reloadData()
    }
    
    override func search() {
        
        if searchBar.text! != "" {
            books = realm.objects(Book.self).filter("authorLastName CONTAINS[cd] '\(searchBar.text!)' OR bookName CONTAINS[cd] '\(searchBar.text!)' OR accessionNumber CONTAINS[cd] '\(searchBar.text!)'").sorted(byKeyPath: "bookName")

        } else {
            load()
        }
        tableView.reloadData()
    }
   /*
    @IBAction func addALotOfBooks(_ sender: Any) {
        
        var number = 0
        let alertController = UIAlertController(title: "Сколько книг добавить в базу?", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let textField = alertController.textFields?[0] else {return}
            guard let startingNumber = Int(textField.text!) else {return}
            number = startingNumber
            for i in 0...startingNumber {
                let newBook = Book()
                newBook.ISBN = "\(i)"
                newBook.authorLastName = "Тургенев"
                newBook.initials = "И. С."
                newBook.bookName = "Муму\(i)"
                newBook.publisherName = "Эксмо"
                newBook.publisherCity = "Москва"
                newBook.yearOfPublication = "1995"
                newBook.numberOfPages = "250"
                newBook.accessionNumber = "\(i)"
                newBook.price = "400"
                newBook.BBK = "84"
                newBook.authorSign = "Т11"
                self.saveToRealmDB(newBook)
            }
            self.simpleAlert(message: "\(number) книг было добавлено в базу данных") { _ in
                self.tableView.reloadData()
                let indexPath = IndexPath(item: self.books!.count - 1, section: 0)
                print(indexPath)
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Print starting number"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alertController.addAction(cancelAction)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAllBooks(_ sender: Any) {
        let allBooks = realm.objects(Book.self)
        try! realm.write {
            realm.delete(allBooks)
        }
        tableView.reloadData()
    }
    */
}

class bookCell: UITableViewCell {
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!

    @IBOutlet weak var authorView: UIView!
    @IBOutlet weak var bookView: UIView!
    
    func setBorder(width: CGFloat) {
        self.authorView.layer.borderWidth = width
        self.authorView.layer.borderColor = UIColor.blue.cgColor
        self.bookView.layer.borderWidth = width
        self.bookView.layer.borderColor = UIColor.blue.cgColor
    }
}
