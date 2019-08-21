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
    
    func manageRightBarButtonItem(_ selector: Selector) {
        if traitCollection.horizontalSizeClass == .compact || traitCollection.verticalSizeClass == .compact {
            self.navigationItem.rightBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: selector)
        }
    }


}
