//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 12.03.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backwardIcon")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backwardIcon")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
    }
}
