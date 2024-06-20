//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 20.06.2024.
//

import Foundation

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
 //   var photos: [Photo] { get set }
//    func updateTable()
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
  //  var photos: [Photo] = []
  /*  private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }() */
    
    func viewDidLoad() {
        setImagesListServiceObserver()
        fetchPhotos()
    }
    
  /*  func updateTable() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    } */
    
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


