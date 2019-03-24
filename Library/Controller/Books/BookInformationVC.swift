//
//  BookInformationVC.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/06.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit

class BookInformationVC: UIViewController {

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var bookName: UILabel!
    var chosenAuthor: String?
    var chosenBook: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorName.text = chosenAuthor
        bookName.text = chosenBook

    }
    


}
