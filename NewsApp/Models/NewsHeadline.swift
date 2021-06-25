//
//  NewsHeadline.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import Foundation

// MARK: - NewsHeadline
struct NewsHeadline: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsItem]?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
    }
}

// MARK: - NewsItem
struct NewsItem: Codable {
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case articleDescription = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case content = "content"
    }
}
