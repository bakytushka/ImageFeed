//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Bakyt Temishov on 20.06.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    func testShowAlert() {
        // Given
        let spy = ProfileViewControllerSpy()
        let alertController = UIAlertController(title: "Test Alert", message: "This is a test alert", preferredStyle: .alert)
        
        // When
        spy.showAlert(alert: alertController)
        
        // Then
        XCTAssertTrue(spy.showAlertCalled)
    }
    
    /* func testViewControllerCallsUpdateProfileDetailes() {
     let viewController = ProfileViewController()
     let presenter = ProfilePresenterSpy()
     viewController.presenter = presenter
     presenter.view = viewController
     
     _ = viewController.view
     
     XCTAssertTrue(presenter.viewDidloadCalled)
     }
     } */
 /*   func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    } */
  /*  func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
        
        func testViewControllerCallsViewDidLoadllll() {
            let viewController = ProfileViewController()
            let presenter = ProfilePresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController
            _ = viewController.view
            XCTAssertTrue(presenter.viewDidLoadCalled)
        } */
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    var setProfileImageServiceObserverCalled = false
    var showLogoutConfirmationAlertCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func setProfileImageServiceObserver() {
        setProfileImageServiceObserverCalled = true
    }
    
    func showLogoutConfirmationAlert() {
        showLogoutConfirmationAlertCalled = true
    }
}


final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateProfileDetailsCalled = false
    var updateProfile: Profile?
    var showAlertCalled: Bool = false
    var updateAvatarCalled: Bool = false
    
    
    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsCalled = true
        updateProfile = profile
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func showAlert(alert: UIAlertController) {
        showAlertCalled = true
    }
}

