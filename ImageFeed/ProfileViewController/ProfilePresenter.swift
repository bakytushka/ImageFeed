//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 20.06.2024.
//

import Foundation
import Kingfisher
import UIKit

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func setProfileImageServiceObserver()
    func showLogoutConfirmationAlert()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver : NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        setProfileImageServiceObserver()
    }
    
    func setProfileImageServiceObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar()
            }
    }
    
    func showLogoutConfirmationAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.performLogout()
        }))
        view?.showAlert(alert: alert)
    }
    
    private func performLogout() {
        profileLogoutService.logout()
        guard let window = UIApplication.shared.windows.first else { return }
        let splashVC = SplashViewController()
        window.rootViewController = splashVC
    }
}

