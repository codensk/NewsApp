//
//  NewsCaching.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 02.07.2021.
//

import UIKit

protocol NewsCaching {
    func cacheImage(for data: Data?, with response: URLResponse)
    func getCachedImage(for urlStr: String) -> UIImage?
    func clearCache()
}
