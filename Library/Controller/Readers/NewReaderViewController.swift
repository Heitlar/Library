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

    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var patronimicLabel: UITextField!
    @IBOutlet weak var birthDateLabel: UITextField!
    @IBOutlet weak var genderLabel: UITextField!
    @IBOutlet weak var profileLabel: UITextField!
    @IBOutlet weak var libraryCardNumberLabel: UITextField!
    @IBOutlet weak var houseNumberLabel: UITextField!
    @IBOutlet weak var streetLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chooseGender: UITableView!
    
    var editExistingReader = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenScreenTapped()
        superScrollView = scrollView
//        chooseGender.isHidden = true
        chooseGender.delegate = self
        chooseGender.dataSource = self
        updateLabels()
    }
    
    @IBAction func exportReaderDetails(_ sender: Any) {
        
        let file = "\(lastNameLabel.text!).txt"
        
        let text = """
        #920: RDR\r
        #10: \(lastNameLabel.text!)\r
        #11: \(firstNameLabel.text!)\r
        #12: \(patronimicLabel.text!)\r
        #21: \(birthDateLabel.text!)\r
        #23: \(genderLabel.text!)\r
        #50: \(profileLabel.text!)\r
        #13: ^C\(cityLabel.text!)^D\(streetLabel.text!)^E\(houseNumberLabel.text!)\r
        *****
        """
        
        sendTextFile(file, withText: text)
    }
    
    @IBAction func saveReaderToRealm(_ sender: Any) {
        
        if editExistingReader {
            updateExistingReader()
            editExistingReader = false
            navigationController?.popToRootViewController(animated: true)
            return
        } else {
            
            guard libraryCardNumberLabel.text != "" else {
                simpleAlert(message: "Введите номер читательского билета.")
                libraryCardNumberLabel.becomeFirstResponder()
                return
            }
            if realm.objects(Reader.self).filter("libraryCardNumber == '\(createNewReader().libraryCardNumber)'").count > 0 {
                simpleAlert(message: "Читатель с таким номером читательского билета уже существует") { _ in
                    self.libraryCardNumberLabel.becomeFirstResponder()
                }
                return
            }
            saveToRealmDB(createNewReader())
            simpleAlert(message: "Новый читатель был добавлен в базу.") { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateLabels() {
        
        lastNameLabel.text = selectedReader?.lastName
        firstNameLabel.text = selectedReader?.firstName
        patronimicLabel.text = selectedReader?.patronymic
        birthDateLabel.text = selectedReader?.birthDate
        genderLabel.text = selectedReader?.gender
        profileLabel.text = selectedReader?.profile
        houseNumberLabel.text = selectedReader?.houseNumber
        streetLabel.text = selectedReader?.street
        cityLabel.text = selectedReader?.city
        libraryCardNumberLabel.text = selectedReader?.libraryCardNumber
    }
    
    func updateExistingReader() {
        try! realm.write {
            selectedReader?.lastName = lastNameLabel.text ?? ""
            selectedReader?.firstName = firstNameLabel.text ?? ""
            selectedReader?.patronymic = patronimicLabel.text ?? ""
            selectedReader?.birthDate = birthDateLabel.text ?? ""
            selectedReader?.gender = genderLabel.text ?? ""
            selectedReader?.profile = profileLabel.text ?? ""
            selectedReader?.houseNumber = houseNumberLabel.text ?? ""
            selectedReader?.street = streetLabel.text ?? ""
            selectedReader?.city = cityLabel.text ?? ""
        }
    }
    
    func createNewReader() -> Reader {
        let newReader = Reader()
        newReader.lastName = lastNameLabel.text!
        newReader.firstName = firstNameLabel.text!
        newReader.patronymic = patronimicLabel.text!
        newReader.birthDate = birthDateLabel.text!
        newReader.gender = genderLabel.text!
        newReader.profile = profileLabel.text!
        newReader.libraryCardNumber = libraryCardNumberLabel.text!
        newReader.houseNumber = houseNumberLabel.text!
        newReader.street = streetLabel.text!
        newReader.city = cityLabel.text!
        return newReader
    }

//    func saveOrUpdateReaderDetails() {
//
//        updateLabels()
//
//        if editExistingReader {
//            updateExistingReader()
//            editExistingReader = false
//            navigationController?.popToRootViewController(animated: true)
//            return
//        } else {
//
//            guard libraryCardNumberLabel.text != "" else {
//                simpleAlert(message: "Введите номер читательского билета.")
//                libraryCardNumberLabel.becomeFirstResponder()
//                return
//            }
//            saveToRealmDB(createNewReader())
//            simpleAlert(message: "Новый читатель был добавлен в базу.") { _ in
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//    }
    
}


extension NewReaderViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath)
        cell.textLabel?.text = ["м", "ж"][indexPath.row]
        return cell
    }
    
    
}
