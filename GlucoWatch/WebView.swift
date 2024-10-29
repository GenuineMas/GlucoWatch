//
//  WebView.swift
//  CalcXE
//
//  Created by Genuine on 13.02.2024.
//


import SwiftUI
import WebKit
import Foundation


struct WebView: UIViewRepresentable {
    
    let url: URL
    
   // var recognizedBarCode = recognizedItems.first
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var webView: WKWebView?
        
        // receive message from wkwebview
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            print(message.body)
            let date = Date()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // self.messageToWebview(msg: "hello, I got your messsage: \(message.body) at \(date)")
            }
        }
        //  msg: String
        func messageToWebview() {
            //   self.webView?.evaluateJavaScript("webkit.messageHandlers.bridge.onMessage('\(msg)')")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let coordinator = makeCoordinator()
        let userContentController = WKUserContentController()
        userContentController.add(coordinator, name: "bridge")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let _wkwebview = WKWebView(frame: .zero, configuration: configuration)
        _wkwebview.navigationDelegate = coordinator
        
        
        return _wkwebview
    }
    
    func updateUIView(_ webView: WKWebView, context: Context){
        let request = URLRequest(url: url)
        webView.load(request)
        
        //TODO calculate delay time exactly !
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML")
            { (result, error) in
                if error == nil {
                    print("RESULT\(result)")
                } else {print ("FUCK")}
            }
            
            webView.evaluateJavaScript("document.getElementById('search_by_gtin_searchType_0').removeAttribute('checked')")
            { (result, error) in
                if error == nil {
                    print("RESULT1\(result)")
                } else {print ("FUCK")}
            }
            
            webView.evaluateJavaScript("document.getElementById('search_by_gtin_searchType_1').setAttribute('checked','checked')")
            { (result, error) in
                if error == nil {
                    print("RESULT2\(result)")
                } else {print ("FUCK")}
            }
            
            webView.evaluateJavaScript("document.getElementById('search_by_gtin_interpretationResult').setAttribute('value','4820247142754')")
            { (result, error) in
                if error == nil {
                    print("RESULT3\(result)")
                } else {print ("FUCK")}
            }
            
            webView.evaluateJavaScript("document.getElementById('search-by-number-form').submit();")
            { (result, error) in
                if error == nil {
                    print("RESULT4\(result)")
                } else {print ("FUCK")}
            }
        }
    }
}

class ShowWebView:ObservableObject{
    @Published var isPresentWebView = false
}

struct WebViewHidden: View {
    
    @State var isPresentWebView = false
    
    var body: some View {
        Button("Open WebView") {
            // 2
            isPresentWebView = true
            
        }
        .sheet(isPresented: $isPresentWebView) {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    // 3
                    WebView(url: URL(string: "https://gepir.gs1ua.org/search/gtin")!)
                        .ignoresSafeArea()
                        .navigationTitle("GS1")
                        .navigationBarTitleDisplayMode(.inline)
                        .hidden()
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

#Preview {
    WebViewHidden()
}



