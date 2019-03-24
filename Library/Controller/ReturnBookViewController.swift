//
//  ReturnBookViewController.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/01.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import RealmSwift

class ReturnBookViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    let realm = try! Realm()
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var returnBookButton: UIButton!
    @IBOutlet weak var scanQRButton: UIButton!
    
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            $0.showTorchButton = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton = true
            $0.showOverlayView = true
            $0.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookName.text = ""
        authorName.text = ""
        returnBookButton.isHidden = true
        scanQRButton.layer.cornerRadius = 40
        
    }
    
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true) {
            let book = result.value.components(separatedBy: ":")
            self.authorName.text = book[0]
            self.bookName.text = book[1]
            self.scanQRButton.isHidden = true
            self.returnBookButton.isHidden = false
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
        readerVC.delegate = self
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func returnBookAction(_ sender: Any) {
        
        let newBook = Book()
        newBook.authorName = authorName.text!
        newBook.bookName = bookName.text!
        
        do {
            try self.realm.write {
                self.realm.add(newBook)
            }
        } catch {
            print("Couldn't save to realm")
        }
        navigationController?.popViewController(animated: true)
    }
    

}
