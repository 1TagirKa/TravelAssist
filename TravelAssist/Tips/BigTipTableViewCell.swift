//
//  BigTableViewCell.swift
//  TravelAssist
//
//  Created by Алексей Горбунов on 07.07.2021.
//

import UIKit

class BigTipTableViewCell: UITableViewCell {

    @IBOutlet weak var tipName: UILabel!
    @IBOutlet weak var tipText: UILabel!
    @IBOutlet weak var tipImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderWidth = 5
        contentView.layer.borderColor = UIColor.systemGray6.cgColor
        contentView.layer.cornerRadius = 15
    }
    
    func setData(tip: TipCellData) {
        tipName.text = tip.tipName
        tipText.text = tip.tipText
        tipImage.loadGif(name: "JourneyGif")
        tipImage.layer.cornerRadius = 15
    }
}
