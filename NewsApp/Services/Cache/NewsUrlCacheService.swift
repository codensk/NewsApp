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
    func cacheImage(for data: Data?, with response: URLResponse) {
        guard let urlResponse = response.url, let data = data else { return }
        
        let urlRequest = URLRequest(url: urlResponse)
        let cachedUrlResponse = CachedURLResponse(response: response, data: data)
        
        URLCache.shared.storeCachedResponse(cachedUrlResponse, for: urlRequest)
    }
    
    // get cached image
    func getCachedImage(for urlStr: String) -> UIImage? {        
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
