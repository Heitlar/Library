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

    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var patronimicTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var profileTextField: UITextField!
    @IBOutlet weak var libraryCardNumberTextField: UITextField!
    @IBOutlet weak var houseNumberTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var telephoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!

    
    var editExistingReader = false
    var address: Address?
    override func viewDidLoad() {
        super.viewDidLoad()
        superScrollView = scrollView
        updateLabels()
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
    }
    
    @IBAction func exportReaderDetails(_ sender: Any) {
        
        let file = "\(lastNameTextField.text!).txt"
        
        let text = """
        #920: RDR\r
        #10: \(lastNameTextField.text!)\r
        #11: \(firstNameTextField.text!)\r
        #12: \(patronimicTextField.text!)\r
        #21: \(birthDateTextField.text!)\r
        #30: \(libraryCardNumberTextField.text!)\r
        #23: \(genderTextField.text!)\r
        #50: \(profileTextField.text!)\r
        #13: ^C\(cityTextField.text!)^D\(streetTextField.text!)^E\(houseNumberTextField.text!)\r
        *****
        """
        
        sendTextFile(file, withText: text)
    }
    
    @IBAction func saveReaderToRealm(_ sender: Any) {
        
        guard !editExistingReader  else {
            updateExistingReader()
            editExistingReader = false
            navigationController?.popToRootViewController(animated: true)
            return
        }
        
        guard libraryCardNumberTextField.text != "" else {
            simpleAlert(message: "Введите номер читательского билета.") {_ in self.libraryCardNumberTextField.becomeFirstResponder()}
            return
        }
        
        guard realm.object(ofType: Reader.self, forPrimaryKey: libraryCardNumberTextField.text!) == nil else {
            simpleAlert(message: "Читатель с таким номером читательского билета уже существует") {_ in self.libraryCardNumberTextField.becomeFirstResponder()}
            return
        }
        
        guard telephoneNumberTextField.text != "" else {
            simpleAlert(message: "Введите номер телефона для связи.") {_ in self.telephoneNumberTextField.becomeFirstResponder()}
            return
        }
        
        guard realm.object(ofType: Address.self, forPrimaryKey: telephoneNumberTextField.text!) == nil else {
            simpleAlert(message: "Читатель с таким номером телефона уже существует. Пожалуйста проверьте введенный номер телефона.") {_ in
                self.telephoneNumberTextField.becomeFirstResponder()
            }
            return
        }

        try! realm.write {
            let reader = createNewReader()
            reader.address = createNewAddress()
            realm.add(reader)
        }
        
        simpleAlert(message: "Новый читатель был добавлен в базу.") { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateLabels() {
        
        lastNameTextField.text = selectedReader?.lastName
        firstNameTextField.text = selectedReader?.firstName
        patronimicTextField.text = selectedReader?.patronymic
        birthDateTextField.text = selectedReader?.birthDate
        genderTextField.text = selectedReader?.gender
        profileTextField.text = selectedReader?.profile
        houseNumberTextField.text = selectedReader?.address?.houseNumber
        streetTextField.text = selectedReader?.address?.street
        cityTextField.text = selectedReader?.address?.city
        libraryCardNumberTextField.text = selectedReader?.libraryCardNumber
        telephoneNumberTextField.text = selectedReader?.address?.telephoneNumber
        emailTextField.text = selectedReader?.address?.email
    }
    
    func updateExistingReader() {

        try! realm.write {
            let reader = createNewReader()
            reader.address = createNewAddress()
            realm.add(reader, update: true)
        }
    }
    
    func createNewReader() -> Reader {
        let newReader = Reader()
        newReader.lastName = lastNameTextField.text!
        newReader.firstName = firstNameTextField.text!
        newReader.patronymic = patronimicTextField.text!
        newReader.birthDate = birthDateTextField.text!
        newReader.gender = genderTextField.text!
        newReader.profile = profileTextField.text!
        newReader.libraryCardNumber = libraryCardNumberTextField.text!
        let address = realm.object(ofType: Address.self, forPrimaryKey: telephoneNumberTextField.text!)
        newReader.address? = address!
        return newReader
    }
    
    func createNewAddress() -> Address {
        let newAddress = Address()
        newAddress.houseNumber = houseNumberTextField.text!
        newAddress.street = streetTextField.text!
        newAddress.city = cityTextField.text!
        newAddress.telephoneNumber = telephoneNumberTextField.text!
        newAddress.email = emailTextField.text!
        return newAddress
    }
    
}

