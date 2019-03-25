//
//  NewBookViewController.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/24.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit

class NewBookViewController: RealmVC {

    @IBOutlet weak var ISBN: UITextField!
    @IBOutlet weak var authorLastName: UITextField!
    @IBOutlet weak var initials: UITextField!
    @IBOutlet weak var bookName: UITextField!
    @IBOutlet weak var publisherName: UITextField!
    @IBOutlet weak var publisherCity: UITextField!
    @IBOutlet weak var yearOfPublication: UITextField!
    @IBOutlet weak var numberOfPages: UITextField!
    @IBOutlet weak var accessionNumber: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var BBK: UITextField!
    @IBOutlet weak var authorSign: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        superScrollView = scrollView
    }
    

    @IBAction func saveAndSendBookDetails(_ sender: Any) {
        let file = "\(bookName.text!).txt"
        
        let text = """
        #920: PAZK\r
        #700: ^A\(authorLastName.text!)^B\(initials.text!)\r
        #200: ^A\(bookName.text!)\r
        #210: ^C\(publisherName.text!)^4\(publisherCity.text!)^D\(yearOfPublication.text!)\r
        #215: ^A\(numberOfPages.text!)^1с.\r
        #910: ^A0^B\(accessionNumber.text!)^DЧЗ^E\(price.text!)\r
        #621: \(BBK.text!)\r
        #908: \(authorSign.text!)\r
        *****
        """
        
        sendTextFile(file, withText: text)
    }
    
}
