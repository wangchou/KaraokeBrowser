//
//  ViewController.swift
//  KaraokeBrowser
//
//  Created by Wangchou Lu on R 2/05/06.
//  Copyright © Reiwa 2 com.wcl. All rights reserved.
//

import UIKit
import WebKit

let sakiURL = "https://www.youtube.com/watch?v=GsJA-60fxHk&list=RDGsJA-60fxHk&start_radio=1"

class ViewController: UIViewController {

    // https://stackoverflow.com/a/53141055/2797799
    lazy var webView: WKWebView = {
        guard let cssPath = Bundle.main.path(forResource: "karaoke", ofType: "css"),
              let jsPath = Bundle.main.path(forResource: "karaoke", ofType: "js") else {
            return WKWebView()
        }


        let cssString = try! String(contentsOfFile: cssPath).components(separatedBy: .newlines).joined()
        let jsString = try! String(contentsOfFile: jsPath)
        let source = """
          var style = document.createElement('style');
          style.innerHTML = '\(cssString)';
          document.head.appendChild(style);
          \(jsString)
        """

        let userScript = WKUserScript(source: source,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)

        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        let webView = WKWebView(frame: .zero,
                                configuration: configuration)
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        webView.load(sakiURL)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    override func loadView() {
        self.view = webView
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(Float(webView.estimatedProgress))
        }
    }

}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url {
            print("loaded: \(url.absoluteString)")
        }


        webView.evaluateJavaScript("addKaraokeButton();",
                                   completionHandler: self.jsHandler)
    }

    func jsHandler(result: Any?, error: Error?) {
        if let result = result {
            print(result)
        }
        if let error = error {
            print(error)
        }
    }
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
