//
//  ContentTableViewCell.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 17/12/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with content: Content) {
        artistNameLabel.text = content.artistName
        trackNameLabel.text = content.trackName
        genreNameLabel.text = content.primaryGenreName
        contentImage.image = content.artworkImage
    }
    
}
