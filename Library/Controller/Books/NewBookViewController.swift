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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
