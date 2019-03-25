//
//  NewReaderViewController.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/22.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit
import MessageUI

class NewReaderViewController: RealmVC {

    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var patronimic: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var profile: UITextField!
    @IBOutlet weak var houseNumber: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenScreenTapped()
        superScrollView = scrollView
    }
    
    @IBAction func saveAndSendReaderDetails(_ sender: Any) {
        
        let file = "\(lastName.text!).txt"
        
        let text = """
        #920: RDR\r
        #10: \(lastName.text!)\r
        #11: \(firstName.text!)\r
        #12: \(patronimic.text!)\r
        #21: \(birthDate.text!)\r
        #23: \(gender.text!)\r
        #50: \(profile.text!)\r
        #13: ^C\(city.text!)^D\(street.text!)^E\(houseNumber.text!)\r
        *****
        """
        
        sendTextFile(file, withText: text)
    }

}
