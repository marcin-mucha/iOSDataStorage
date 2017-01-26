//
//  OperationsTableViewCell.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 26/01/17.
//  Copyright © 2017 Marcin Mucha. All rights reserved.
//

import UIKit

class OperationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var operationType: UILabel!
    @IBOutlet weak var storageType: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var recordNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(operation: PersistanceOperation) {
        operationType.text = operation.operationType.rawValue
        storageType.text = operation.storageType.rawValue
        duration.text = "\(operation.duration) ms"
        recordNumber.text = "Rekordów: \(operation.recordNumber)"
    }
    
}
