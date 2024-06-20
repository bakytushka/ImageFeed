//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Bakyt Temishov on 21.06.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerTest: XCTestCase {
    
    func testUpdateTableViewAnimated() {
        // Given
        let tableView = UITableView()
        let spy = ImagesListViewControllerSpy(tableView: tableView)
        let presenterSpy = ImagesListViewPresenterSpy()
        spy.presenter = presenterSpy
        
        // When
        spy.updateTableViewAnimated()
        
        // Then
        XCTAssertTrue(spy.updateTableViewAnimatedCalled)
    }
}

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
        
    var fetchPhotosCalled: Bool = false
    var view: ImagesListViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var setImagesListServiceObserverCalled = false
    
    func fetchPhotos() {
        fetchPhotosCalled = true
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func setImagesListServiceObserver() {
        setImagesListServiceObserverCalled = true
    }
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    
    var tableView: UITableView

    var updateTableViewAnimatedCalled = false
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
}
