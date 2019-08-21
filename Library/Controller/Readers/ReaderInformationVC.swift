//
//  ReaderInformationVC.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/06.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit
import RealmSwift

class ReaderInformationVC: RealmVC {
    @IBOutlet weak var BooksInUseList: UIView!
    
    @IBOutlet weak var returnAllBooksButton: UIButton!
    var booksInUse: Results<Book>?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var telephoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        if selectedReader!.booksInUse.count == 0 {
            returnAllBooksButton.isHidden = true
            BooksInUseList.isHidden = true
        }
        self.title = selectedReader?.fullName
        telephoneNumberLabel.text = selectedReader?.address?.telephoneNumber
        addressLabel.text = selectedReader?.address?.fullAddress
        emailButton.setTitle(selectedReader?.address?.email, for: .normal)
        load()
    }
    

    @IBAction func sendEmail(_ sender: Any) {
        sendEmailTo(emailButton.titleLabel!.text!)
    }
    
    @IBAction func returnAllBooks(_ sender: Any) {
        try! realm.write {
            selectedReader?.booksInUse.forEach { $0.borrower = nil; $0.returnDate = nil }
        }
        simpleAlert(message: "Все книги этого читателя были возвращены.") { alert in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func editReaderInfo(_ sender: Any) {
        performSegue(withIdentifier: "editReaderInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editReaderInfo" {
            let destinationVC = segue.destination as! NewReaderViewController
            destinationVC.editExistingReader = true
            destinationVC.selectedReader = selectedReader
        }
    }
    
}

extension ReaderInformationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksInUse?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookInUseCell", for: indexPath) as! bookInTemporaryUseCell
        cell.authorNameLabel.text = "Нет книг"
        guard let bookInUse = booksInUse?[indexPath.row] else {return cell}
        cell.authorNameLabel.text = bookInUse.authorFullName
        cell.bookNameLabel.text = bookInUse.bookName
        
        cell.daysToReturnLabel.text = "\(bookInUse.returnDate!.inFormOfString())"
        cell.daysToReturnLabel.textAlignment = .center
        cell.backgroundColor = bookInUse.returnDate! <= Date() ? .red : .clear
        cell.setBorder(width: 0.5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookInUseCell") as? bookInTemporaryUseCell else { return nil }
        cell.backgroundColor = UIColor.headerColor
        
        cell.setBorder(width: 0.5)
        cell.authorNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cell.bookNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cell.daysToReturnLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cell.authorNameLabel.textAlignment = .center
        cell.bookNameLabel.textAlignment = .center
        cell.daysToReturnLabel.textAlignment = .center
        cell.authorNameLabel.text = "Имя автора"
        cell.bookNameLabel.text = "Название книги"
        cell.daysToReturnLabel.text = "Дата возврата"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        guard booksInUse!.count > 0 else { tableView.deselectRow(at: indexPath, animated: true); return }
        let message = "Вернуть \"\(booksInUse![indexPath.row].bookName)\" в библиотеку?"
        
        simpleAlert(message: message, withCancelButton: true) { _ in
            
            try! self.realm.write {
                self.booksInUse?[indexPath.row].returnDate = nil
                self.booksInUse?[indexPath.row].borrower = nil
            }
            self.tableView.reloadData()
            self.updateViewConstraints()
        }

            tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func load() {
        booksInUse = realm.objects(Book.self).filter("borrower = %@", selectedReader!)
    }
    
    override func updateViewConstraints() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        super.updateViewConstraints()
        
    }
}

class bookInTemporaryUseCell: bookCell {
    @IBOutlet weak var daysToReturnLabel: UILabel!
    @IBOutlet weak var daysToReturnView: UIView!
    override func setBorder(width: CGFloat) {
        super .setBorder(width: width)
        self.daysToReturnView.layer.borderColor = UIColor.blue.cgColor
        self.daysToReturnView.layer.borderWidth = width
    }
}

