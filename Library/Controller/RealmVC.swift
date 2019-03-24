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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
