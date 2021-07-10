//
//  DetailViewController.swift
//  TravelAssist
//
//  Created by Алексей Горбунов on 06.07.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var index: Int = 0
    
    var article: Article!
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleText: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleLabel.text = article.articleLabel
        articleLabel.layer.cornerRadius = 15
        articleLabel.layer.borderWidth = 3
        articleLabel.layer.borderColor = UIColor.systemGray6.cgColor
        
        
        articleImage.image = article.articleImage
        articleImage.layer.cornerRadius = 15
        articleImage.contentMode = .scaleAspectFill
        
        articleText.text = article.articleText
//        articleText.layer.cornerRadius = 15
//        articleText.layer.borderWidth = 3
//        articleText.layer.borderColor = UIColor.systemGray6.cgColor
        
        articleText.translatesAutoresizingMaskIntoConstraints = true
        articleText.sizeToFit()
    }
    
}
