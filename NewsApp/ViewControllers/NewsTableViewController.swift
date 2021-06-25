//
//  NewsTableViewController.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    private let networkManager = NetworkManager()
    
    private var imageCache = [Int: UIImage?]()
    private var headLine: NewsHeadline?
    
    private var activityIndicator: UIActivityIndicatorView!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 92
    }
}

// MARK: - Table view
extension NewsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headLine?.articles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsItemCell", for: indexPath) as? NewsTableViewCell,
              let headLine = headLine,
              let news = headLine.articles
              else {
            return UITableViewCell()
        }
        
        let newsItem = news[indexPath.row]
        
        cell.newsTitleLabel.text = newsItem.title
        
        cell.newsImageView.image = UIImage(named: "placeholder")
        
        if let imageUrl = newsItem.urlToImage {
            // try to load news image from cache
            if let cachedImage = imageCache[indexPath.row] {
                cell.newsImageView.image = cachedImage
            } else {
                
                // if image not presented in cache, start load by api
                networkManager.fetchNewsImage(for: imageUrl) { image, error in
                    if let error = error {
                        print("Error: \(error)")
                        
                        return
                    }
                    self.imageCache[indexPath.row] = image
                    DispatchQueue.main.async {
                        cell.newsImageView.image = image
                    }
                }
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "readVC") as? ReadViewController,
              let headLine = headLine,
              let news = headLine.articles
              else {
            return
        }
        
        let selectedNewsItem = news[indexPath.row]
        
        vc.newsItem = selectedNewsItem
        
        if let cachedImage = imageCache[indexPath.row] {
            vc.newsImage = cachedImage
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Networking
extension NewsTableViewController {
    func fetchNewsList(for category: Category) {
        title = category.categoryName
        
        startActivityIndicator()
        
        networkManager.fetchNews(for: category) { newsHeadline, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.showAlert(title: "Ошибка", message: error)
                }
                
                return
            }
            
            self.headLine = newsHeadline
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopActivityIndicator()
            }
     
        }
    }
}

// MARK: Extension Activity Indicator
extension NewsTableViewController {
    private func startActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        
        view.addSubview(activityIndicator)
        
        activityIndicator?.center = view.center
        activityIndicator?.hidesWhenStopped = true
        
        activityIndicator?.startAnimating()
    }
    
    private func stopActivityIndicator() {
        activityIndicator?.stopAnimating()
    }
}
