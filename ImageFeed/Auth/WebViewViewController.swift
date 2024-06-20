//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Bakyt Temishov on 12.03.2024.
//

import UIKit
import WebKit


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    weak var delegate: WebViewViewControllerDelegate?
    
 // ПЕРЕНЕСТИ В АУФКОНФИГУРАТИОН
  /*)/  enum WebViewConstants {
     static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
     } */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //     loadAuthView()
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
 //       updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
//            updateProgress()
            presenter?.didUpdateProgressValue(webView.estimatedProgress)

        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    /*  private func updateProgress() {
     progressView.progress = Float(webView.estimatedProgress)
     progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
     } */
    
    /*   private func loadAuthView() {
     guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
     return
     }
     
     urlComponents.queryItems = [
     URLQueryItem(name: "client_id", value: Constants.accessKey),
     URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
     URLQueryItem(name: "response_type", value: "code"),
     URLQueryItem(name: "scope", value: Constants.accessScope)
     ]
     
     guard let url = urlComponents.url else {
     return
     }
     
     let request = URLRequest(url: url)
     webView.load(request)
     } */
    
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
 /*   private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    } */
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
    
    
}
