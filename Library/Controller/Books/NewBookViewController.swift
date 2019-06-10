//
//  NewBookViewController.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/24.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit

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
        accessionNumber.isEnabled = editExistingBook ? false : true
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
    }

    @IBAction func exportBookDetails(_ sender: Any) {
        let file = "\(bookName.text!).txt"
        
        let text = """
        #920: \r
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
    
    func createNewBook() -> Book {
        return Book(ISBN: ISBN.text!, authorLastName: authorLastName.text!, initials: initials.text!, bookName: bookName.text!, publisherName: publisherName.text!, publisherCity: publisherCity.text!, yearOfPublication: yearOfPublication.text!, numberOfPages: numberOfPages.text!, accessionNumber: accessionNumber.text!, price: price.text!, BBK: BBK.text!, authorSign: authorSign.text!)
    }
    
    @IBAction func saveToRealmButton(_ sender: Any) {
        let newBook = createNewBook()
        
        if editExistingBook {
            
            try! realm.write {
                realm.add(newBook, update: true)
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
        ISBN.text = chosenBook?.ISBN
        authorLastName.text = chosenBook?.authorLastName
        initials.text = chosenBook?.initials
        bookName.text = chosenBook?.bookName
        publisherName.text = chosenBook?.publisherName
        publisherCity.text = chosenBook?.publisherCity
        yearOfPublication.text = chosenBook?.yearOfPublication
        numberOfPages.text = chosenBook?.numberOfPages
        accessionNumber.text = chosenBook?.accessionNumber
        price.text = chosenBook?.price
        BBK.text = chosenBook?.BBK
        authorSign.text = chosenBook?.authorSign
    }
    
}
