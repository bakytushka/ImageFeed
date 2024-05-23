//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 25.04.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private init () { }
    
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = createURLRequest(username: username, token: token) else { return }
        
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        task = URLSession.shared.objectTask(for: request) { [weak self] (response: Result<UserResult, Error>)  in
            
            self?.task = nil
            switch response {
            case .success(let body):
                if let smallURL = body.profileImage?.small {
                    self?.avatarURL = smallURL
                    completion(.success(smallURL))
                    
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": smallURL])
                } else {
                    print("Profile image URL is nil")
                }
                
            case .failure(let error):
                print("[ProfileImageService]: \(error.localizedDescription) \(request)")
                completion(.failure(error))
            }
        }
        task?.resume()
    }
    
    private func createURLRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
