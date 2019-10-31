//
//  SearchHistoryTableViewCell.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 31/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var searchQueryLbl: UILabel!
    
    func updateView(query: String) {
        searchQueryLbl.text = query.capitalized
    }

}
