//
//  WebView.swift
//  NewsApp
//
//  Created by BMIIT on 18/08/25.
//
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView { WKWebView() }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
