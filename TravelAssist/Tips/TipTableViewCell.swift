//
//  TipTableViewCell.swift
//  TravelAssist
//
//  Created by Алексей Горбунов on 06.07.2021.
//

import UIKit

class TipTableViewCell: UITableViewCell {

    @IBOutlet weak var tipName: UILabel!
    @IBOutlet weak var tipText: UILabel!
    @IBOutlet weak var tipImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(tip: TipCellData) {
        tipName.text = tip.tipName
        tipText.text = tip.tipText
        tipImage.image = tip.tipImage
        tipImage.layer.cornerRadius = 7
    }
}
