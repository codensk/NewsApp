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
    
    private let cacher = NewsUrlCacheService.shared
    
    private var selectedCategory: Category!
    private var newsFetcher: NewsFetching!
    private var cellImageCache: NSCache<NSString, UIImage>!
    
    private var headLine: NewsHeadline?
    
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Methods
    private func setup() {
        let storedNewsLang = UserDefaults.standard.string(forKey: "newsLang")
        
        newsFetcher = NewsFetcher.shared.createNetworkLayer(for: .urlSession)
        
        cellImageCache = NSCache()
        
        tableView.rowHeight = 92
        tableView.separatorStyle = .none
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновить")
        tableView.refreshControl?.addTarget(self, action: #selector(newsRefresh), for: .valueChanged)
        tableView.refreshControl?.layer.zPosition = -1
        
        if storedNewsLang == "us" {
            newsFetcher.switchLanguage()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: newsFetcher.getCurrentLang().uppercased(), style: .plain, target: self, action: #selector(langSwitchButton))
    }
    
    @objc private func langSwitchButton() {
        newsFetcher.switchLanguage()
   
        navigationItem.rightBarButtonItem?.title = newsFetcher.getCurrentLang().uppercased()
        
        fetchNewsList(for: selectedCategory)
    }
    
    @objc private func newsRefresh() {

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
              let news = headLine.articles,
              news.indices.contains(indexPath.row)
        else {
            return UITableViewCell()
        }
        
        let newsItem = news[indexPath.row]
        let imageUrl = newsItem.urlToImage ?? ""
        
        cell.newsTitleLabel.text = newsItem.title
        
        if let image = self.cellImageCache.object(forKey: imageUrl as NSString) {
            DispatchQueue.main.async {
                cell.newsImageView.image = image
            }
        } else {
            cell.newsImageView.image = UIImage(named: "placeholder")
            
            newsFetcher.fetchNewsImage(for: newsItem.urlToImage ?? "") { image, error in
                if let error = error {
                    print("Error: \(error)")
                    
                    return
                }
                
                if let image = image {
                    self.cellImageCache.setObject(image, forKey: imageUrl as NSString)
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
        let imageUrl = selectedNewsItem.urlToImage ?? ""
        
        vc.newsFetcher = newsFetcher
        vc.newsItem = selectedNewsItem
        vc.newsImage = UIImage(named: "placeholder")
        
        if let image = self.cellImageCache.object(forKey: imageUrl as NSString) {
            vc.newsImage = image
        }
    
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
