//
//  ReaderInformationVC.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/06.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit

class ReaderInformationVC: RealmVC {

    @IBOutlet weak var booksInPosession: UILabel!
    var selectedReader : Reader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        booksInPosession.text = selectedReader?.booksInUse.map { $0.authorOfBook }.joined(separator: "\n")
    }
    

    @IBAction func returnAllBooks(_ sender: Any) {
        try! realm.write {
            selectedReader?.booksInUse.removeAll()
        }
        simpleAlert(message: "Все книги этого читателя были возвращены.") { alert in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
