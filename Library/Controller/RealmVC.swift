//
//  RealmVC.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/22.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class RealmVC: UIViewController, MFMailComposeViewControllerDelegate{
    
    let realm = try! Realm()
    var superScrollView = UIScrollView()
    var activeField: UITextField?
    
    static var bookAccessionNumber : String?
    
    var selectedReader : Reader?
    var chosenBook : Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        let _ = getAllTextFields(from: self.view).map { $0.setLeftPaddingPoints(20) }
        nextTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func sendTextFile(_ file: String, withText text: String) {
        
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let fileURL = dir.appendingPathComponent(file)
        
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            
        }
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("Файл для импорта.")
            mailComposer.setMessageBody("В приложении файл для импорта в ИРБИС.", isHTML: false)
            
            do {
                let fileData = try Data(contentsOf: fileURL)
                mailComposer.addAttachmentData(fileData, mimeType: "text/txt", fileName: file)
                
            } catch {
                
            }
            present(mailComposer, animated: true, completion: nil)
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillHide() {
        superScrollView.contentInset = UIEdgeInsets.zero
        superScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        self.superScrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        self.superScrollView.contentInset = contentInsets
        self.superScrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField  {
            if (!aRect.contains(activeField.frame.origin)) {
                self.superScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        activeField = nil
    }
    
    func nextTextField() {
        let textFields = getAllTextFields(from: self.view)
        guard let last = textFields.last else { return }
        for i in 0..<textFields.count - 1 {
            textFields[i].returnKeyType = .next
            textFields[i].addTarget(textFields[i + 1], action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
            last.addTarget(last, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
        }
    }
    
    func getAllTextFields(from view: UIView) -> [UITextField] {
        return view.subviews.compactMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(from: view)
            }
            }.flatMap({$0})
    }
    

    
}
