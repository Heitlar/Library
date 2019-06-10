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

    var book = [String:String]()
    
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
            print(result.value)
            let arrayOfResults = result.value.components(separatedBy: "\r\n")
            self.book = arrayOfResults.reduce(into: [String:String]()) { (dictionary, element) in
                let dictElementsArray = element.components(separatedBy: ":")
                if dictElementsArray.count == 2 {
                    dictionary[dictElementsArray[0].trimmingCharacters(in: .whitespaces)] = dictElementsArray[1].trimmingCharacters(in: .whitespaces)
                }
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
            
            destinationVC.chosenBook = Book()
            destinationVC.chosenBook?.ISBN = book["ISBN"] ?? ""
            destinationVC.chosenBook?.authorLastName = book["Фамилия автора"] ?? ""
            destinationVC.chosenBook?.initials = book["Инициалы автора"] ?? ""
            destinationVC.chosenBook?.bookName = book["Название книги"] ?? ""
            destinationVC.chosenBook?.publisherName = book["Название издательства"] ?? ""
            destinationVC.chosenBook?.publisherCity = book["Город издания"] ?? ""
            destinationVC.chosenBook?.yearOfPublication = book["Год издания"] ?? ""
            destinationVC.chosenBook?.numberOfPages = book["Число страниц"] ?? ""
            destinationVC.chosenBook?.price = book["Цена"] ?? ""
            destinationVC.chosenBook?.BBK = book["ББК"] ?? ""
            destinationVC.chosenBook?.authorSign = book["Авторский знак"] ?? ""

        }
    }

}
