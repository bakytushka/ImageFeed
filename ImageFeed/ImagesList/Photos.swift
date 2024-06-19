//
//  PhotoModels.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 27.05.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDiscription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(photo: PhotoResult) {
        id = photo.id
        size = CGSize(width: photo.width, height: photo.height)
        createdAt = photo.dateCreatedAt
        welcomeDiscription = photo.description
        largeImageURL = photo.urls.large
        thumbImageURL = photo.urls.thumb
        isLiked = photo.likedByUser
    }
    
    init(id: String, size: CGSize, createdAt: Date?, welcomeDescription: String?, largeImageURL: String, thumbImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDiscription = welcomeDescription
        self.largeImageURL = largeImageURL
        self.thumbImageURL = thumbImageURL
        self.isLiked = isLiked
    }
}
