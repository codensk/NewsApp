//
//  ReadViewController.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import UIKit

class ReadViewController: UIViewController {
    var newsItem: NewsItem?
    var newsImage: UIImage?
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var fullVersionButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Methods
    private func setup() {
        let fullVersionButtonText = NSMutableAttributedString(
            string: "Читать полную версию",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        
        newsTitleLabel.text = newsItem?.title
        newsDescriptionLabel.text = newsItem?.articleDescription
        fullVersionButton.setAttributedTitle(fullVersionButtonText, for: .normal)
        
        if let newsImage = newsImage {
            newsImageView.image = newsImage
        } else {
            newsImageView.image = UIImage(named: "placeholder")
        }
  
    }

    // MARK: - IBActions
    @IBAction func fullVersionButtonTapped() {
        if let newsItem = newsItem, let url = URL(string: newsItem.url) {
            UIApplication.shared.open(url)
        }
    }
}
