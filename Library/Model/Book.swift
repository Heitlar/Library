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
    
    override static func primaryKey() -> String? {
        return "accessionNumber"
    }
    
    var parentCategory = LinkingObjects(fromType: Reader.self, property: "booksInUse")
    
}
