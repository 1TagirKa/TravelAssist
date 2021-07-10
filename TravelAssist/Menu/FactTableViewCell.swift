//
//  FactTableViewCell.swift
//  TravelAssist
//
//  Created by Arslan Rashidov on 07.07.2021.
//

import UIKit

class FactTableViewCell: UITableViewCell {

    
    @IBOutlet weak var factLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(factCellData: FactCellData) {
        factLabel.text = factCellData.factText
    }

}
