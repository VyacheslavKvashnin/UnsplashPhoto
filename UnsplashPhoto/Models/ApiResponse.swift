//
//  Results.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 04.06.2022.
//

import Foundation

struct ApiResponse: Decodable {
    let results: [Results]
}

struct Results: Decodable {
    let id: String
    let urls: URLs
    let user: User?
    let created_at: String
    let downloads: Int
}

struct URLs: Decodable {
    let regular: String
    let small: String
}

struct User: Decodable {
    let name: String?
    let location: String?
}
