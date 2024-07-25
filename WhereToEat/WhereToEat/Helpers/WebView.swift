//
//  WebView.swift
//  WhereToEat
//
//  Created by Zeynep on 25/07/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let url: URL?
    let activityIndicator = UIActivityIndicatorView(frame: .zero)
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self, with: activityIndicator)
    }
    
    func makeUIView(context: Context) -> UIViewType {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let url else { return }
        uiView.load(URLRequest(url: url))
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: uiView.centerYAnchor)
         ])
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    var webView: WebView
    var activityIndicator: UIActivityIndicatorView
    
    init(_ webView: WebView, with activityIndicator: UIActivityIndicatorView) {
        self.webView = webView
        self.activityIndicator = activityIndicator
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        activityIndicator.stopAnimating()
    }
}
