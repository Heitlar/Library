//
//  Reader.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/01.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import Foundation
import RealmSwift

class Reader: Object {
   
    @objc dynamic var lastName = ""
    @objc dynamic var firstName = ""
    @objc dynamic var patronymic = ""
    @objc dynamic var birthDate = ""
    @objc dynamic var gender = ""
    @objc dynamic var profile = ""
    @objc dynamic var libraryCardNumber = ""
    @objc dynamic var address: Address?
    
    var returnDelay: Bool {
        var hasOverdueBooks = false
        booksInUse.forEach {
          if $0.returnDate! < Date() {
                hasOverdueBooks = true
            }
        }
        return hasOverdueBooks
    }
    
    @objc dynamic var fullName: String {
        get {
            return [lastName, firstName, patronymic].joined(separator: " ")
        }
    }
    
    let booksInUse = LinkingObjects(fromType: Book.self, property: "borrower")
    
    override static func primaryKey() -> String? {
        return "libraryCardNumber"
    }
}

