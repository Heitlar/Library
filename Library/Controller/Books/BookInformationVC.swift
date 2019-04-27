//
//  BookInformationVC.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/06.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit

class BookInformationVC: RealmVC {

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var bookName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorName.text = chosenBook?.authorFullName
        bookName.text = chosenBook?.bookName        
    }
    
    @IBAction func loanBook(_ sender: Any) {
        
        performSegue(withIdentifier: "chooseReader", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseReader" {
            let destinationVC = segue.destination as! ReadersTableViewController
            destinationVC.chosenBook = chosenBook
        } else {
            let destinationVC = segue.destination as! NewBookViewController
            destinationVC.QRISBN = chosenBook!.ISBN
            destinationVC.QRauthorLastName = chosenBook!.authorLastName
            destinationVC.QRinitials = chosenBook!.initials
            destinationVC.QRbookName = chosenBook!.bookName
            destinationVC.QRpublisherName = chosenBook!.publisherName
            destinationVC.QRpublisherCity = chosenBook!.publisherCity
            destinationVC.QRyearOfPublication = chosenBook!.yearOfPublication
            destinationVC.QRnumberOfPages = chosenBook!.numberOfPages
            destinationVC.QRaccessionNumber = chosenBook!.accessionNumber
            destinationVC.QRprice = chosenBook!.price
            destinationVC.QRBBK = chosenBook!.BBK
            destinationVC.QRauthorSign = chosenBook!.authorSign
            destinationVC.editExistingBook = true
            destinationVC.chosenBook = chosenBook
//            destinationVC.bookAccessionNumber = bookAccessionNumber
        }
    }
    

}
