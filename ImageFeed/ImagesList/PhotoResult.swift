//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 27.05.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case description = "description"
        case urls = "urls"
        case likedByUser = "liked_by_user"
    }
}

