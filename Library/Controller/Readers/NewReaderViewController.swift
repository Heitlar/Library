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
    @IBOutlet weak var libraryCardNumber: UITextField!
    @IBOutlet weak var houseNumber: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenScreenTapped()
        superScrollView = scrollView
    }
    
    @IBAction func exportReaderDetails(_ sender: Any) {
        
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
    
    @IBAction func saveReaderToRealm(_ sender: Any) {
    
        let newReader = Reader()
        newReader.lastName = lastName.text!
        newReader.firstName = firstName.text!
        newReader.patronymic = patronimic.text!
        newReader.birthDate = birthDate.text!
        newReader.gender = gender.text!
        newReader.profile = profile.text!
        newReader.libraryCardNumber = libraryCardNumber.text!
        newReader.houseNumber = houseNumber.text!
        newReader.street = street.text!
        newReader.city = city.text!
        
        guard newReader.libraryCardNumber != "" else {
            simpleAlert(message: "Введите номер читательского билета. ") { action in
                self.libraryCardNumber.becomeFirstResponder()
            }
            return
        }
        
        if realm.objects(Reader.self).filter("libraryCardNumber == '\(newReader.libraryCardNumber)'").count > 0 {
   
            simpleAlert(message: "Читатель с таким номером читательского билета уже существует.") { action in
                self.libraryCardNumber.becomeFirstResponder()
                return
            }
        }
        saveToRealmDB(newReader)
        simpleAlert(message: "Новый читатель был добавлен в базу.") { action in
            self.navigationController?.popViewController(animated: true)
        }
    }
    

}
