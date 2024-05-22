//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 17.04.2024.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    var profile: Profile?
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionDataTask?
    
    private func createURLRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else { return nil }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        
        guard let request = createURLRequest(token: token) else {
            let error = NetworkError.urlSessionError
            print("[fetchProfile]: \(error) - token: \(token)")
            completion(.failure(error))
            return
        }
        
        task = URLSession.shared.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>)  in
            guard let self = self else { return }
            
            switch response {
            case .success(let profileResult):
                let profile = Profile(
                    username: profileResult.username,
                    firstName: profileResult.firstName,
                    lastName: profileResult.lastName,
                    bio: profileResult.bio
                )
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("[fetchProfile]: \(error)")
                completion(.failure(error))
            }
            
            self.task = nil
        } as? URLSessionDataTask
        
        task?.resume()
    }
}
