//
//  ViewController.swift
//  WebViewDownloadFromDataURLTest
//
//  Created by Li, Yan on 11/8/19.
//  Copyright © 2019 MicroStrategy, Inc. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {
    let webView = WebView(frame: NSRect(x: 0, y: 0, width: 500, height: 400))

    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.policyDelegate = self
        webView.downloadDelegate = self

        if let path = Bundle.main.path(forResource: "DataURL", ofType: "html") {
            let mainPage = URL(fileURLWithPath: path)
            let request = URLRequest(url: mainPage)
            webView.mainFrame.load(request)
        }
    }

    func chooseSavePath() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["xml"]
        savePanel.nameFieldStringValue = "WebView Download File from Data URL Test"

        let result = savePanel.runModal()
        if result == .OK  {
            return savePanel.url
        }

        return nil
    }
}

extension ViewController: WebPolicyDelegate {

    func webView(_ webView: WebView, decidePolicyForMIMEType type: String, request: URLRequest, frame: WebFrame, decisionListener listener: WebPolicyDecisionListener) {
        if let url = request.url?.absoluteString, url.starts(with: "data:application/xml;") {
            listener.download()
            return
        }

        listener.use()
    }

}

extension ViewController: WebDownloadDelegate {

    func download(_ download: NSURLDownload, decideDestinationWithSuggestedFilename filename: String) {
        NSLog("decideDestinationWithSuggestedFilename: \(filename)")

        if let saveUrl = chooseSavePath() {
            download.setDestination(saveUrl.path, allowOverwrite: true)
            NSLog("decideDestinationWithSuggestedFilename, download.setDestination(\(saveUrl.path))")
        } else {
            download.cancel()
            NSLog("decideDestinationWithSuggestedFilename, download.cancel()")
        }
    }

    func downloadDidBegin(_ download: NSURLDownload) {
        NSLog("downloadDidBegin")
    }

    func download(_ download: NSURLDownload, didCreateDestination filename: String) {
        NSLog("didCreateDestination: \(filename)")
    }

    func download(_ download: NSURLDownload, didReceive response: URLResponse) {
        NSLog("didReceive: URLResponse")
    }

    func download(_ download: NSURLDownload, didReceiveDataOfLength length: Int) {
        NSLog("didReceiveDataOfLength: \(length)")
    }

    func download(_ download: NSURLDownload, shouldDecodeSourceDataOfMIMEType mimeType: String) -> Bool {
        NSLog("shouldDecodeSourceDataOfMIMEType: \(mimeType) -> true")
        return true
    }

    func download(_ download: NSURLDownload, willResumeWith response: URLResponse, fromByte firstByte: Int64) {
        NSLog("willResumeWith: URLResponse, fromByte: \(firstByte)")
    }

    func download(_ download: NSURLDownload, willSend request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
        NSLog("willSend: URLRequest, redirectResponse:URLResponse")
        return request
    }

    func download(_ download: NSURLDownload, didFailWithError error: Error) {
        NSLog("didFailWithError: \(error.localizedDescription)")
    }

    func downloadDidFinish(_ download: NSURLDownload) {
        NSLog("downloadDidFinish")
    }

}
