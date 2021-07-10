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
    @IBOutlet weak var articleText: UITextView!
    @IBOutlet weak var articleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleLabel.text = article.articleLabel
        
        articleImage.image = article.articleImage
        articleImage.layer.cornerRadius = 15
        articleImage.contentMode = .scaleAspectFill
        
        articleText.text = article.articleText
        articleText.layer.cornerRadius = 15
        articleText.backgroundColor = .systemGray6
        articleText.isEditable = false
        
        articleText.translatesAutoresizingMaskIntoConstraints = true
        articleText.sizeToFit()
        
        if articleText.frame.size.height > 310 {
            articleText.frame.size.height = 310
            articleText.isScrollEnabled = true
        }
    }
    
}
