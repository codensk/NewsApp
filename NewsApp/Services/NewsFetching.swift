//
//  NewsFetching.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 29.06.2021.
//

import UIKit

protocol NewsFetching {
    func fetchNews(for category: Category, completionHandler: @escaping (NewsHeadline?, String?) -> Void)
    func fetchNewsImage(for urlStr: String, completionHandler: @escaping (UIImage?, String?) -> Void)
    func postNews(news: NewsItem, completionHandler: @escaping (PostResult?, String?) -> Void)
}
