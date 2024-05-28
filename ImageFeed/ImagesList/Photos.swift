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
}
