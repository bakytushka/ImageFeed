//
//  UserResult.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 25.04.2024.
//

import Foundation

struct UserResult: Codable {
    var profileImage: ImageURL?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
