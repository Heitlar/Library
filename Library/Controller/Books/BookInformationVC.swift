//
//  BookInformationVC.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/06.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit

class BookInformationVC: RealmVC {

    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var accessionNumberLabel: UILabel!
    @IBOutlet weak var BBKLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var loanBookButton: UIButton!
    @IBOutlet weak var showReaderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillLabels()
    }
    
    
    @IBAction func loanBook(_ sender: Any) {
        performSegue(withIdentifier: "chooseReader", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseReader" {
            let destinationVC = segue.destination as! ReadersTableViewController
            destinationVC.title = "Выберите читателя"
            destinationVC.chosenBook = chosenBook
        } else if segue.identifier == "showReaderDetails" {
            let destinationVC = segue.destination as! ReaderInformationVC
            destinationVC.selectedReader = chosenBook?.borrower
        } else {
            let destinationVC = segue.destination as! NewBookViewController
            
            destinationVC.editExistingBook = true
            destinationVC.chosenBook = chosenBook
        }
    }
    
    func fillLabels() {
        authorNameLabel.text = chosenBook?.authorFullName
        bookNameLabel.text = chosenBook?.bookName
        BBKLabel.text = chosenBook?.BBK
        accessionNumberLabel.text = chosenBook?.accessionNumber
        returnDateLabel.text = chosenBook?.returnDate?.inFormOfString()
        showReaderButton.setTitle("", for: .normal)
        showReaderButton.isEnabled = false
        
        if chosenBook?.returnDate == nil {
            loanBookButton.isHidden = false
        } else {
            loanBookButton.isHidden = true
            showReaderButton.isEnabled = true
            showReaderButton.setTitle(chosenBook?.borrower?.fullName, for: .normal)

        }
    }

}
