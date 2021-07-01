//
//  NewsFetcher.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 01.07.2021.
//

import Foundation

enum NetworkLayer {
    case urlSession, alamofire
}

class NewsFetcher {
    static var shared = NewsFetcher()
    
    func createNetworkLayer(for layer: NetworkLayer) -> NewsFetching {
        switch layer {
        case .alamofire:
            return NewsJsonAFService()
        case .urlSession:
            return NewsJsonService()
        }
    }
    
    private init() { }
}
