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
    
    @objc dynamic var bookName = ""
    @objc dynamic var authorName = ""
    @objc dynamic var authorOfABook: String {
        get {
           return authorName + "  " + bookName
        }
    }
    var parentCategory = LinkingObjects(fromType: Reader.self, property: "booksInUse")
    
}
