//
//  Extensions.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/05.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import Foundation
import RealmSwift

extension UIColor {
    static var headerColor: UIColor { return UIColor(red: 123/255, green: 245/255, blue: 255/255, alpha: 1) }
    static var mainColor: UIColor { return UIColor(red: 255/255, green: 255/255, blue: 150/255, alpha: 1) }
}

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
    
    func simpleAlert(message: String, withCancelButton: Bool = false, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        
        if withCancelButton {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        
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
    
    func saveToRealmDB(_ object: Object) {
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

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension Date {
    func inFormOfString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: self)
    }
}
