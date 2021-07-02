//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with newsItem: NewsItem, networkService: NewsFetching, cacheService: NewsCaching) {
        newsTitleLabel.text = newsItem.title
        
        newsImageView.image = UIImage(named: "placeholder")
        
        if let cachedImage = cacheService.cachedImageNews(for: newsItem.urlToImage ?? "") {
            newsImageView.image = cachedImage
            return
        }
                
        networkService.fetchNewsImage(for: newsItem.urlToImage ?? "") { image, error in
            if let error = error {
                print("Error: \(error)")
                
                return
            }
            
            DispatchQueue.main.async {
                self.newsImageView.image = image
            }
            
        }
    }
}
