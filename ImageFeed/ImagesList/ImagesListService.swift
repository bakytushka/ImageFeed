//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 27.05.2024.
//

import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var oauth2TokenStorage = OAuth2TokenStorage()
    
    static let shared = ImagesListService()
  //  private let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else {
            print("Loading in progress")
            return
        }
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = createURLRequest(page: nextPage) else {
            print("Error forming request")
            return
        }
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let photoResults):
                    let newPhotos = photoResults.map({Photo(photo: $0)})
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["Photos": self.photos]
                        )}
                case .failure(let error):
                    print("Failed to fetch photos \(error)")
                }
                self.task = nil
            }
        }
        task?.resume()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void) {
            assert(Thread.isMainThread)
            
            guard let request = createLikeURLRequest(id: photoId, isLike: isLike) else {
                assertionFailure("Invalid request")
                return
            }
            task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                            let photo = self.photos[index]
                            let newPhoto = Photo(
                                id: photo.id,
                                size: photo.size,
                                createdAt: photo.createdAt,
                                welcomeDescription: photo.welcomeDiscription,
                                largeImageURL: photo.largeImageURL,
                                thumbImageURL: photo.thumbImageURL,
                                isLiked: !photo.isLiked
                            )
                            self.photos[index] = newPhoto
                        }
                        completion(.success(()))
                    case .failure(let error):
                        print("Failed to change like status: \(error)")
                    }
                    self.task = nil
                }
            }
            task?.resume()
        }
    
    func clearPhotos() {
        photos = []
    }
    
    private func createLikeURLRequest(id: String, isLike: Bool) -> URLRequest? {
        guard let token = oauth2TokenStorage.token else {
            return nil
        }
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(id)/like",
            httpMethod: isLike ? "POST" : "DELETE",
            baseURL: Constants.defaultBaseURL
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func createURLRequest(page: Int) -> URLRequest? {
        guard let token = oauth2TokenStorage.token else {
            return nil
        }
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)",
            httpMethod: "GET",
            baseURL: Constants.defaultBaseURL
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
