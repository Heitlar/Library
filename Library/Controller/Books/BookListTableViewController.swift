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
        
        manageRightBarButtonItem(#selector(goToNewBookVC))
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        goToNewBookVC()
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
    
    @objc func goToNewBookVC() {
        performSegue(withIdentifier: "ToNewBook", sender: self)
        
    }
    
    func load() {
        books = realm.objects(Book.self)
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
