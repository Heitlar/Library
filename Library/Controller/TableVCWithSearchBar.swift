//
//  TableVCWithSearchBar.swift
//  Library
//
//  Created by Sergey Larkin on 2019/03/05.
//  Copyright © 2019 Sergey Larkin. All rights reserved.
//

import UIKit
import RealmSwift

class TableVCWithSearchBar: UITableViewController, UISearchBarDelegate {

    let realm = try! Realm()
    weak var superSearchBar: UISearchBar!
    var chosenBook : Book?
//    let mainColor = UIColor(red: 255/255, green: 255/255, blue: 150/255, alpha: 1)
//    let headerColor = UIColor(red: 123/255, green: 245/255, blue: 255/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .blue
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
        searchBar.resignFirstResponder()
    }
    
    func search() {
        
    }
    


}
