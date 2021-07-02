//
//  NewsTableViewController.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {
    static let identifier = "newsVC"
    static let newsCellIdentifier = "newsItemCell"
    
    var selectedCategory: Category!
    
    private var newsFetcher: NewsFetching!
    
    private var headLine: NewsHeadline?
    private let cacher = NewsCacheService.shared
    
    private var activityIndicator: UIActivityIndicatorView!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Methods
    private func setup() {
        newsFetcher = NewsFetcher.shared.createNetworkLayer(for: .alamofire)
        
        tableView.rowHeight = 92
        tableView.separatorStyle = .none
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновить")
        tableView.refreshControl?.addTarget(self, action: #selector(newsRefresh), for: .valueChanged)
        tableView.refreshControl?.layer.zPosition = -1
    }
    
    @objc private func newsRefresh() {
        cacher.clearCache()
        
        fetchNewsList(for: selectedCategory)
        
        tableView.refreshControl?.endRefreshing()
        
        //tableView.reloadData()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewController.newsCellIdentifier, for: indexPath) as? NewsTableViewCell,
              let headLine = headLine,
              let news = headLine.articles
              else {
            return UITableViewCell()
        }
        
        let newsItem = news[indexPath.row]
        
        cell.newsTitleLabel.text = newsItem.title
        
        cell.newsImageView.image = UIImage(named: "placeholder")
 
        if let imageUrl = newsItem.urlToImage {
            newsFetcher.fetchNewsImage(for: imageUrl) { image, error in
                if let error = error {
                    print("Error: \(error)")
                    
                    return
                }
                
                DispatchQueue.main.async {
                    cell.newsImageView.image = image
                }
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: ReadViewController.identifier) as? ReadViewController,
              let headLine = headLine,
              let news = headLine.articles
              else {
            return
        }
        
        let selectedNewsItem = news[indexPath.row]
        
        vc.newsItem = selectedNewsItem
        vc.newsFetcher = newsFetcher
      
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Networking
extension NewsTableViewController {
    func fetchNewsList(for category: Category) {
        selectedCategory = category
        
        title = category.categoryName
        
        startActivityIndicator()
        
        newsFetcher.fetchNews(for: category) { newsHeadline, error in
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
