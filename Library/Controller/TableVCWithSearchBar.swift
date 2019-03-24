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
    
    override func viewDidLoad() {
        super.viewDidLoad()


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
