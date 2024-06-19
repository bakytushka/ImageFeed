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
        resetToken()
        resetPhotos()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func resetPhotos() {
        ImagesListService.shared.clearPhotos()
    }
    
    private func resetToken() {
        guard OAuth2TokenStorage.shared.removeToken() else {
            assertionFailure("Cannot remove token")
            return
        }
    }
}

