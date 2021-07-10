//
//  NewsTableViewCell.swift
//  TravelAssist
//
//  Created by Arslan Rashidov on 09.07.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(singleNews: SingleNewsData){
        newsLabel.text = singleNews.singleNewsText
    }

}
