//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 19.03.2024.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func objectTask<T: Decodable>(
            for request: URLRequest,
            completion: @escaping (Result<T, Error>) -> Void
        ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
     /*   let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(success)
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task */
            let task = dataTask(with: request, completionHandler: { data, response, error in
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode
                {
                    if 200 ..< 300 ~= statusCode {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(T.self, from: data)
                            fulfillCompletionOnTheMainThread(.success(result))
                        }
                        catch {
                            print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                            fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                        }
                    } else {
                        print("[objectTask(for:)]: \(String(describing: error?.localizedDescription))")
                        fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else if let error = error {
                    print("[objectTask]: \(error)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                } else {
                    print("[objectTask(for:)]: \(String(describing: error?.localizedDescription))")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                }
            })
            task.resume()
            return task
    }
}
