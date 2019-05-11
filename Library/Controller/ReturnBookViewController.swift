//
//  ReturnBookViewController.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/01.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit


class ReturnBookViewController: RealmVC {
    

    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var returnBookButton: UIButton!
    var book = ""
    var author = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookName.text = book
        authorName.text = author
    }

    
    @IBAction func returnBookAction(_ sender: Any) {
        
        let newBook = Book()
        newBook.authorLastName = authorName.text!
        newBook.bookName = bookName.text!
        saveToRealmDB(newBook)
        navigationController?.popViewController(animated: true)
    }
    

}
