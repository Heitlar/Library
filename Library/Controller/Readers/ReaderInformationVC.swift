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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "AAAAAAAAAA"
        
        if selectedReader!.booksInUse.count > 0 {
            booksInPosession.text = selectedReader?.booksInUse.map { $0.authorOfBook }.joined(separator: "\n")
        } else {
            booksInPosession.text = "Нет книг."
        }
        
        
    }
    

    @IBAction func returnAllBooks(_ sender: Any) {
        try! realm.write {
            selectedReader?.booksInUse.removeAll()
        }
        simpleAlert(message: "Все книги этого читателя были возвращены.") { alert in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func editReaderInfo(_ sender: Any) {
        performSegue(withIdentifier: "editReaderInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editReaderInfo" {
            let destinationVC = segue.destination as! NewReaderViewController
            destinationVC.editExistingReader = true
            destinationVC.selectedReader = selectedReader
        }
    }
    
}
