//
//  Constants.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 11.03.2024.
//

import Foundation

enum Constants {
    static let accessKey: String = "EfWr9EDp6FnQ8vXv8iXAGP-CB2E2r-1Qr-mBbNyd9lg"
    static let secretKey: String = "Trxuh5ZIBTM23HK2D7rRvO8VO1YWm_jDVtGqEDTbAPM"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let grandType: String = "authorization_code"
}
