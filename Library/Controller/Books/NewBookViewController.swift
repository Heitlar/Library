//
//  NewBookViewController.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/24.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit

var selectedBook : Book?

class NewBookViewController: RealmVC {

    @IBOutlet weak var ISBN: UITextField!
    @IBOutlet weak var authorLastName: UITextField!
    @IBOutlet weak var initials: UITextField!
    @IBOutlet weak var bookName: UITextField!
    @IBOutlet weak var publisherName: UITextField!
    @IBOutlet weak var publisherCity: UITextField!
    @IBOutlet weak var yearOfPublication: UITextField!
    @IBOutlet weak var numberOfPages: UITextField!
    @IBOutlet weak var accessionNumber: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var BBK: UITextField!
    @IBOutlet weak var authorSign: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var editExistingBook = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenScreenTapped()
        superScrollView = scrollView
        fillTextFields()
    }
    

    @IBAction func exportBookDetails(_ sender: Any) {
        let file = "\(bookName.text!).txt"
        
        let text = """
        #920: PAZK\r
        #10: ^A\(ISBN.text!)\r
        #700: ^A\(authorLastName.text!)^B\(initials.text!)\r
        #200: ^A\(bookName.text!)\r
        #210: ^C\(publisherName.text!)^4\(publisherCity.text!)^D\(yearOfPublication.text!)\r
        #215: ^A\(numberOfPages.text!)^1с.\r
        #910: ^A0^B\(accessionNumber.text!)^DЧЗ^E\(price.text!)\r
        #621: \(BBK.text!)\r
        #908: \(authorSign.text!)\r
        *****
        """
        
        sendTextFile(file, withText: text)
    }
    
    @IBAction func saveToRealmButton(_ sender: Any) {
        let newBook = Book()
        newBook.ISBN = ISBN.text!
        newBook.authorLastName = authorLastName.text!
        newBook.initials = initials.text!
        newBook.bookName = bookName.text!
        newBook.publisherName = publisherName.text!
        newBook.publisherCity = publisherCity.text!
        newBook.yearOfPublication = yearOfPublication.text!
        newBook.numberOfPages = numberOfPages.text!
        newBook.accessionNumber = accessionNumber.text!
        newBook.price = price.text!
        newBook.BBK = BBK.text!
        newBook.authorSign = authorSign.text!
        
        if editExistingBook {

            try! realm.write {
                chosenBook?.ISBN = newBook.ISBN
                chosenBook?.authorLastName = newBook.authorLastName
                chosenBook?.initials = newBook.initials
                chosenBook?.bookName = newBook.bookName
                chosenBook?.publisherName = newBook.publisherName
                chosenBook?.publisherCity = newBook.publisherCity
                chosenBook?.yearOfPublication = newBook.yearOfPublication
                chosenBook?.numberOfPages = newBook.numberOfPages
                chosenBook?.price = newBook.price
                chosenBook?.BBK = newBook.BBK
                chosenBook?.authorSign = newBook.authorSign
            }
            
            editExistingBook = false
            chosenBook = nil
            navigationController?.popViewController(animated: true)
            return
        }
        guard newBook.accessionNumber != "" else {
            self.simpleAlert(message: "Введите инвентарный номер.") { action in
                self.accessionNumber.becomeFirstResponder()
            }
            return
        }
        if realm.objects(Book.self).filter("accessionNumber = '\(newBook.accessionNumber)'").count > 0 {
            print("Книга с таким инвентарным номером уже существует.")
            simpleAlert(message: "Книга с таким инвентарным номером уже существует.") { _ in
                self.accessionNumber.becomeFirstResponder()
            }
            return
        }
        
        saveToRealmDB(newBook)
        navigationController?.popViewController(animated: true)
    }
    
    
    func fillTextFields() {
        ISBN.text = QRISBN
        authorLastName.text = QRauthorLastName
        initials.text = QRinitials
        bookName.text = QRbookName
        publisherName.text = QRpublisherName
        publisherCity.text = QRpublisherCity
        yearOfPublication.text = QRyearOfPublication
        numberOfPages.text = QRnumberOfPages
        accessionNumber.text = QRaccessionNumber
        price.text = QRprice
        BBK.text = QRBBK
        authorSign.text = QRauthorSign
    }
    
}
