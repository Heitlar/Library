//
//  Address.swift
//  Library
//
//  Created by Sergey Larkin on 2019/05/28.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import Foundation
import RealmSwift

class Address: Object {
    
    @objc dynamic var houseNumber = ""
    @objc dynamic var street = ""
    @objc dynamic var city = ""
    @objc dynamic var telephoneNumber = ""
    @objc dynamic var email = ""
    
    var fullAddress: String {
        let city = self.city == "" ? "" : "г. \(self.city), "
        let street = self.street == "" ? "" : "ул. \(self.street), "
        let houseNumber = self.houseNumber == "" ? "" : "д. \(self.houseNumber)"
        return city + street + houseNumber
    }

    let readers = LinkingObjects(fromType: Reader.self, property: "address")
    
    override static func primaryKey() -> String? {
        return "telephoneNumber"
    }
}

