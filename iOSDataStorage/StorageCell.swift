//
//  StorageCell.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 31/01/17.
//  Copyright © 2017 Marcin Mucha. All rights reserved.
//

import UIKit

class StorageCell: UITableViewCell {

    
    @IBOutlet weak var storageNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
