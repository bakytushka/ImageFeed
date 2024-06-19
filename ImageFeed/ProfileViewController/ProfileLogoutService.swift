//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 30.05.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        clearToken()
        clearProfileData()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    private func clearToken() {
        OAuth2TokenStorage.shared.token = nil
    }
    
    private func clearProfileData() {
        ProfileService.shared.profile = nil
    }
    
    private func clearAvatarData() {
        ProfileImageService.shared.clearAvatarURL()
    }
}

