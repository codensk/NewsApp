//
//  Category.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import Foundation

struct Category {
    let categoryName: String
    let categoryCode: String
    
    static func getCategories() -> [Category] {
        return [
            Category(categoryName: "Технологии", categoryCode: "technology"),
            Category(categoryName: "Спорт", categoryCode: "sports"),
            Category(categoryName: "Наука", categoryCode: "science"),
            Category(categoryName: "Здоровье", categoryCode: "health"),
            Category(categoryName: "Развлечение", categoryCode: "entertainment"),
            Category(categoryName: "Бизнес", categoryCode: "business"),
        ]
    }
}
