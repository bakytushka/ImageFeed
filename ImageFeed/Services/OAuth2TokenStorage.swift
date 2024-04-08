//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 19.03.2024.
//

import Foundation
import UIKit

final class OAuth2TokenStorage {
    private let tokenKey = "OAuth2AccessToken"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    static let shared = OAuth2TokenStorage()
}
