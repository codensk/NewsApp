//
//  NewsCaching.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 02.07.2021.
//

import UIKit

protocol NewsCaching {
    func store(for data: Data?, with response: URLResponse)
    func cachedNews(for urlStr: String) -> NewsHeadline?
    func cachedImageNews(for urlStr: String) -> UIImage?
    func clearCache()
}
