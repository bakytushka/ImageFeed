//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 20.06.2024.
//

import Foundation

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func setImagesListServiceObserver()
    func fetchPhotos()
}

final class ImageListViewPresenter: ImagesListViewPresenterProtocol {
    
    private var imageListService = ImagesListService.shared
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        setImagesListServiceObserver()
        fetchPhotos()
    }
    
    func fetchPhotos() {
        imageListService.fetchPhotosNextPage()
    }
    
    func setImagesListServiceObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.view?.updateTableViewAnimated()
        }
    }
    
}


