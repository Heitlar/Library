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
import Alamofire
import SwiftyJSON

class StartViewController: RealmVC,  QRCodeReaderViewControllerDelegate {

    var bookDetailsDictionary = [String:String]()
    let googleURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
    let librarythingURL = "http://www.librarything.com/services/rest/1.1/?method=librarything.ck.getwork&apikey=1f3787fb1c1bc2adb4a046cccaef5d61&isbn="
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    lazy var readCodeVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr, .ean13, .ean8, .pdf417], captureDevicePosition: .back)
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
            if result.value.count == 13 {
                
                AF.request(self.googleURL + result.value, method: .get).responseData { (response) in

                    let json = try! JSON(data: response.data!)
                    let book = json["items"][0]["volumeInfo"]["title"].stringValue
                    let author = json["items"][0]["volumeInfo"]["authors"][0].stringValue
                    let yearOfPublication = json["items"][0]["volumeInfo"]["publishedDate"].stringValue
                    let pageCount = json["items"][0]["volumeInfo"]["pageCount"].stringValue
                    
                    
//                    print("Book: \(book)\nAuthor: \(author)\nYear: \(yearOfPublication)")
                    self.bookDetailsDictionary["ISBN"] = String(result.value)
                    self.bookDetailsDictionary["Фамилия автора"] = author
                    self.bookDetailsDictionary["Название книги"] = book
                    self.bookDetailsDictionary["Год издания"] = yearOfPublication
                    self.bookDetailsDictionary["Число страниц"] = pageCount
                    self.performSegue(withIdentifier: "NewBook", sender: self)
//                    let xml = XML.parse(response.data!)
//                    guard let bookName = xml["response", "ltml", "item", "title"].text else { return }
//                    guard let author = xml["response", "ltml", "item", "author"].text else { return }
//                    print(bookName)
//                    print(author)
                }
                
            } else {
                let arrayOfResults = result.value.components(separatedBy: "\r\n")
                self.bookDetailsDictionary = arrayOfResults.reduce(into: [String:String]()) { (dictionary, element) in
                    let dictElementsArray = element.components(separatedBy: ":")
                    if dictElementsArray.count == 2 {
                        dictionary[dictElementsArray[0].trimmingCharacters(in: .whitespaces)] = dictElementsArray[1].trimmingCharacters(in: .whitespaces)
                    }
                }
                self.performSegue(withIdentifier: "NewBook", sender: self)
            }
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
        readCodeVC.delegate = self
        readCodeVC.modalPresentationStyle = .formSheet
        present(readCodeVC, animated: true, completion: nil)
    }
    
    @IBAction func scanBarcode(_ sender: Any) {
        readCodeVC.delegate = self
        readCodeVC.modalPresentationStyle = .formSheet
        present(readCodeVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewBook" {
            let destinationVC = segue.destination as! NewBookViewController
            
            destinationVC.chosenBook = Book()
            destinationVC.chosenBook?.ISBN = bookDetailsDictionary["ISBN"] ?? ""
            destinationVC.chosenBook?.authorLastName = bookDetailsDictionary["Фамилия автора"] ?? ""
            destinationVC.chosenBook?.initials = bookDetailsDictionary["Инициалы автора"] ?? ""
            destinationVC.chosenBook?.bookName = bookDetailsDictionary["Название книги"] ?? ""
            destinationVC.chosenBook?.publisherName = bookDetailsDictionary["Название издательства"] ?? ""
            destinationVC.chosenBook?.publisherCity = bookDetailsDictionary["Город издания"] ?? ""
            destinationVC.chosenBook?.yearOfPublication = bookDetailsDictionary["Год издания"] ?? ""
            destinationVC.chosenBook?.numberOfPages = bookDetailsDictionary["Число страниц"] ?? ""
            destinationVC.chosenBook?.price = bookDetailsDictionary["Цена"] ?? ""
            destinationVC.chosenBook?.BBK = bookDetailsDictionary["ББК"] ?? ""
            destinationVC.chosenBook?.authorSign = bookDetailsDictionary["Авторский знак"] ?? ""
        }
    }

}
