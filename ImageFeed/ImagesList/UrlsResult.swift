//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 27.05.2024.
//

import Foundation

struct UrlsResult: Decodable {
    let large: String
    let thumb: String
    
    enum CodingKeys: String, CodingKey {
        case large = "full"
        case thumb
    }
}



