//
//  StartViewController.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/25.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class StartViewController: RealmVC,  QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var scanQRButton: UIButton!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var bookListButton: UIButton!
    @IBOutlet weak var booksImageView: UIImageView!
    @IBOutlet weak var readerListButton: UIButton!
    @IBOutlet weak var readersImageView: UIImageView!
    
    var authorName = ""
    var bookName = ""
    var book = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
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
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true) {
            self.book = result.value.components(separatedBy: "\r\n")
            guard self.book.count == 12 else {
                self.simpleAlert(message: "Invalid QR code!")
                return
            }
            
            self.performSegue(withIdentifier: "NewBook", sender: self)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewBook" {
            let destinationVC = segue.destination as! NewBookViewController
            destinationVC.QRISBN = self.book[0]
            destinationVC.QRauthorLastName = self.book[1]
            destinationVC.QRinitials = self.book[2]
            destinationVC.QRbookName = self.book[3]
            destinationVC.QRpublisherName = self.book[4]
            destinationVC.QRpublisherCity = self.book[5]
            destinationVC.QRyearOfPublication = self.book[6]
            destinationVC.QRnumberOfPages = self.book[7]
            destinationVC.QRaccessionNumber = self.book[8]
            destinationVC.QRprice = self.book[9]
            destinationVC.QRBBK = self.book[10]
            destinationVC.QRauthorSign = self.book[11]
        }
    }

}
