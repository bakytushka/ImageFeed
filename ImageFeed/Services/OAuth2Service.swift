//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 18.03.2024.
//

import Foundation
import UIKit


enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private let urlSession = URLSession.shared              // 1
        
    private var task: URLSessionTask?                       // 2
    private var lastCode: String?
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let urlString = "https://unsplash.com/oauth/token" +
        "?client_id=\(Constants.accessKey)" +
        "&client_secret=\(Constants.secretKey)" +
        "&redirect_uri=\(Constants.redirectURI)" +
        "&code=\(code)" +
        "&grant_type=\(Constants.grandType)"
        
        guard let url = URL(string: urlString) else {
            assertionFailure("Failed to create URL")
           // print("Failed to create URL with baseURL and parameters.")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String,Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {                               // 1
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()                                      // 2
        lastCode = code
        
        guard
            let urlRequest = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "Data", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                OAuth2TokenStorage.shared.token = response.accessToken
                DispatchQueue.main.async {
                    completion(.success(response.accessToken))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL? = Constants.defaultBaseURL
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

