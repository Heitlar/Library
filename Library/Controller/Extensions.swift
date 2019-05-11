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
        saveToRealmDB(object)
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
       
    func simpleAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenScreenTapped() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func saveToRealmDB(_ object: Object) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            return
        }
    }
}

