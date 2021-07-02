//
//  NewsUrlCacheService.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 02.07.2021.
//

import UIKit

class NewsUrlCacheService: NewsCaching {
    static let shared = NewsUrlCacheService()
    
    // store in cache
    func store(for data: Data?, with response: URLResponse) {
        guard let urlResponse = response.url, let data = data else { return }
        
        let urlRequest = URLRequest(url: urlResponse)
        let cachedUrlResponse = CachedURLResponse(response: response, data: data)
        
        URLCache.shared.storeCachedResponse(cachedUrlResponse, for: urlRequest)
    }
    
    // retrieving news from cache
    func cachedNews(for urlStr: String) -> NewsHeadline? {
        guard let url = URL(string: urlStr) else {
            return nil
        }
        
        let urlRequest = URLRequest(url: url)
        
        if let cached = URLCache.shared.cachedResponse(for: urlRequest) {
            do {
                let newsHeadline = try JSONDecoder().decode(NewsHeadline.self, from: cached.data)
                
                return newsHeadline
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
    
    // retrieving image from cache
    func cachedImageNews(for urlStr: String) -> UIImage? {        
        guard let url = URL(string: urlStr) else {
            return nil
        }
        
        let urlRequest = URLRequest(url: url)
        
        if let cached = URLCache.shared.cachedResponse(for: urlRequest) {
            return UIImage(data: cached.data)
        }
        
        return nil
    }
    
    // clear all news cache
    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
    }

    private init() { }
}
