//
//  NewsJsonService.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import UIKit

// Working with JSON and URLSession
class NewsJsonService: NewsFetching {
    static let shared = NewsJsonService()

    private let apiKey = "2376ba10df08418b93b024c4aa6803a1"
    private let country = "ru"
    
    func fetchNews(for category: Category, completionHandler: @escaping (NewsHeadline?, String?) -> Void) {
        let urlStr = "\(API.headlines.rawValue)?country=\(country)&category=\(category.categoryCode)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completionHandler(nil, error.localizedDescription)
                
                return
            }
            
            guard let data = data else {
                completionHandler(nil, "Data loading error")
                
                return
            }
            
            do {
                let newsHeadline = try JSONDecoder().decode(NewsHeadline.self, from: data)
                
                completionHandler(newsHeadline, nil)
            } catch let error {
                completionHandler(nil, error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func fetchNewsImage(for urlStr: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        guard urlStr.contains("https"), let url = URL(string: urlStr) else {
            return
        }
   
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completionHandler(nil, error.localizedDescription)
                
                return
            }
            
            guard let data = data else {
                completionHandler(nil, "Data loading error")
                
                return
            }
            
            guard let image = UIImage(data: data) else {
                completionHandler(nil, "Image data error")
                
                return
            }
                        
            completionHandler(image, nil)
        }
        
        task.resume()
    }
    
    func postNews(news: NewsItem, completionHandler: @escaping (PostResult?, String?) -> Void) {
        guard let url = URL(string: API.saveNews.rawValue) else {
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(news) else {
            completionHandler(nil, "News data encode error")
            
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completionHandler(nil, error.localizedDescription)
                
                return
            }
            
            guard let data = data else {
                completionHandler(nil, "Data loading error")
                
                return
            }
            
            do {
                let postResult = try JSONDecoder().decode(PostResult.self, from: data)
                
                completionHandler(postResult, nil)
            } catch let error {
                completionHandler(nil, error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
