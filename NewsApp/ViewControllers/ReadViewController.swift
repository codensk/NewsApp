//
//  ReadViewController.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import UIKit

class ReadViewController: UIViewController {
    static let identifier = "readVC"
    
    var newsFetcher: NewsFetching!
    
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
  
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(newsPost))
    }
    
    @objc func newsPost() {
        guard let newsItem = newsItem else {
            return
        }
        
        newsFetcher.postNews(news: newsItem) { result, error in
            if let error = error {
                print("Error: \(error)")
                
                return
            }
            
            guard let result = result else {
                return
            }
            
            DispatchQueue.main.async {
                self.showAlert(title: "Новость отправлена", message: "Всего отправлено: \(result.total)")
            }
        }
    }

    // MARK: - IBActions
    @IBAction func fullVersionButtonTapped() {
        if let newsItem = newsItem, let url = URL(string: newsItem.url) {
            UIApplication.shared.open(url)
        }
    }
}
