//
//  Category.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 08.12.2025.
//

import Foundation

struct CategoryListResponse: Codable {
    let meals: [Category]?
}


struct Category: Codable {
    let strCategory: String
}


