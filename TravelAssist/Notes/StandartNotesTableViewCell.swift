//
//  StandartNotesTableViewCell.swift
//  TravelAssist
//
//  Created by Tagir Kabirov on 05.07.2021.
//

import UIKit

class StandartNotesTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(object: Standart){
        titleLabel.text = object.title
        descriptionLabel.text = object.description
        emojiLabel.text = object.emoji
    }


}
