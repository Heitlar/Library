//
//  Extensions.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/05.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import Foundation
import RealmSwift

extension UITableViewController {
    
    func saveToRealm(_ object: Object) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            return
        }
        tableView.reloadData()
    }
    func deleteFromRealm(_ object: Object) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            return
        }
        tableView.reloadData()
    }

}

extension UIViewController {
    func hideKeyboardWhenScreenTapped() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap() {
        view.endEditing(true)
    }
}


