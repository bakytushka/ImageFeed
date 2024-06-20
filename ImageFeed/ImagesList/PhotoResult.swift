//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 27.05.2024.
//

import Foundation

let isoDateFormatter = ISO8601DateFormatter()
struct PhotoResult: Decodable {
    var id: String
    var width: Int
    var height: Int
    var createdAt: String?
    var description: String?
    var urls: UrlsResult
    var likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case description = "description"
        case urls = "urls"
        case likedByUser = "liked_by_user"
    }

    var dateCreatedAt: Date?{
        guard let createdAtString = createdAt else {return nil}
        return isoDateFormatter.date(from: createdAtString)
    }
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResult
}
