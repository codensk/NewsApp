//
//  NewsJsonAFService.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 29.06.2021.
//

import Alamofire
import UIKit

// Working with JSON and Alamofire
class NewsJsonAFService: NewsFetching {
    static let shared = NewsJsonAFService()
    
    private let cacher = NewsUrlCacheService.shared
    
    var apiKey = "2376ba10df08418b93b024c4aa6803a1"
    
    private var country = "ru"
    
    func fetchNews(for category: Category, completionHandler: @escaping (NewsHeadline?, String?) -> Void) {
        let urlStr = "\(API.headlines.rawValue)?country=\(country)&category=\(category.categoryCode)&apiKey=\(apiKey)"
        
        let request = AF.request(urlStr).validate()
        
        request.responseDecodable(of: NewsHeadline.self) { response in
            switch response.result {
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            case .success(let result):
                completionHandler(result, nil)
            }
        }
    }
    
    func fetchNewsImage(for urlStr: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        guard urlStr.contains("https") else {
            return
        }
        
        if let image = cacher.getCachedImage(for: urlStr) {
            completionHandler(image, nil)
        }

        let request = AF.request(urlStr).validate()
        
        request.response { response in
            switch response.result {
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            case .success(let data):
                guard let data = data, let image = UIImage(data: data) else {
                    completionHandler(nil, "Image data error")
                    
                    return
                }
                
                if let urlResponse = response.response {
                    self.cacher.cacheImage(for: data, with: urlResponse)
                }
                
                completionHandler(image, nil)
            }
        }
    }
    
    func postNews(news: NewsItem, completionHandler: @escaping (PostResult?, String?) -> Void) {
        let request = AF.request(API.saveNews.rawValue, method: .post, parameters: news).validate()
        
        request.responseDecodable(of: PostResult.self) { response in
            switch response.result {
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            case .success(let result):
                completionHandler(result, nil)
            }
        }
    }
    
    func switchLanguage() {
        country = country == "ru" ? "us" : "ru"
        
        UserDefaults.standard.setValue(country, forKey: "newsLang")
    }
    
    func getCurrentLang() -> String {
        return country
    }
}
