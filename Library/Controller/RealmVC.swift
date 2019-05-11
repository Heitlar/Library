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
    
    static var bookAccessionNumber : String?
    
    var selectedReader : Reader?
    var chosenBook : Book?
    
    var QRISBN = ""
    var QRauthorLastName = ""
    var QRinitials = ""
    var QRbookName = ""
    var QRpublisherName = ""
    var QRpublisherCity = ""
    var QRyearOfPublication = ""
    var QRnumberOfPages = ""
    var QRaccessionNumber = ""
    var QRprice = ""
    var QRBBK = ""
    var QRauthorSign = ""
    var QRscrollView = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                superScrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
                superScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        }
    }
    
    @objc func keyboardWillHide() {
        superScrollView.contentInset = UIEdgeInsets.zero
        superScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    
}
