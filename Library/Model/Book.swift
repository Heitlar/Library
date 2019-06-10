//
//  Book.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/01.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import Foundation
import RealmSwift


class Book: Object {
    
    @objc dynamic var ISBN = ""
    @objc dynamic var authorLastName = ""
    @objc dynamic var initials = ""
    @objc dynamic var bookName = ""
    @objc dynamic var publisherName = ""
    @objc dynamic var publisherCity = ""
    @objc dynamic var yearOfPublication = ""
    @objc dynamic var numberOfPages = ""
    @objc dynamic var accessionNumber = ""
    @objc dynamic var price = ""
    @objc dynamic var BBK = ""
    @objc dynamic var authorSign = ""
    @objc dynamic var returnDate: Date? = nil
    @objc dynamic var borrower : Reader?
    
    @objc dynamic var authorFullName: String {
        get {
            return "\(authorLastName) \(initials)"
        }
    }
    
    @objc dynamic var authorOfBook: String {
        get {
           return "\(authorLastName) \(initials) \(bookName)"
        }
    }
    
    convenience  init(ISBN: String, authorLastName: String, initials: String, bookName: String, publisherName: String, publisherCity: String, yearOfPublication: String, numberOfPages: String, accessionNumber: String, price: String, BBK: String, authorSign: String) {
        self.init()
        self.ISBN = ISBN
        self.authorLastName = authorLastName
        self.initials = initials
        self.bookName = bookName
        self.publisherName = publisherName
        self.publisherCity = publisherCity
        self.yearOfPublication = yearOfPublication
        self.numberOfPages = numberOfPages
        self.accessionNumber = accessionNumber
        self.price = price
        self.BBK = BBK
        self.authorSign = authorSign
        
    }
    
    override static func primaryKey() -> String? {
        return "accessionNumber"
    }
}


