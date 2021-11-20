//
//  ViewController.swift
//  GB2
//
//  Created by Александр Арсенюк on 19.11.2021.
//

import UIKit
import Alamofire
import WebKit

//"8005353"



class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "8005353"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
        
//        let paramters: Parameters = [
//            "title": "foo",
//            "body": "bar",
//            "userId": 1
//        ]
//
//
//        SessionManager.custom.request("http://jsonplaceholder.typicode.com/posts", method: .post, parameters: paramters).responseJSON { data in
//            print(data.value)
//        }
        
//        let url = URL(string: "http://samples.openweathermap.org/data/2.5/forecast?q=Munchen,DE&appid=b1b15e88fa797225412429c1c50c122a1")
        
//        var urlConstructor = URLComponents()
//        urlConstructor.scheme = "http"
//        urlConstructor.host = "jsonplaceholder.typicode.com"
//        urlConstructor.path = "/posts"
//        urlConstructor.queryItems = [
//            URLQueryItem(name: "title", value: "foo"),
//            URLQueryItem(name: "body", value: "bar"),
//            URLQueryItem(name: "userId", value: "1")
//        ]
//
//        let configuration =  URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
//
//        guard urlConstructor.url != nil else {
//            print("URL not valid")
//            return
//        }
//        print(urlConstructor.url!)
//
//        var request = URLRequest(url: urlConstructor.url!)
//        request.httpMethod = "POST"
//
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil {
//                print(error)
//            } else if data != nil {
//                let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.fragmentsAllowed)
//                print(json)
//            }
//        }
//        task.resume()
    }


}

extension SessionManager {
    
    static let custom: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let sessionManager = SessionManager(configuration: configuration)
        return sessionManager
    }()
    
}

extension ViewController: WKNavigationDelegate {
        
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
                   decisionHandler(.allow)
                   return
               }

               
               let params = fragment
                   .components(separatedBy: "&")
                   .map { $0.components(separatedBy: "=") }
                   .reduce([String: String]()) { result, param in
                       var dict = result
                       let key = param[0]
                       let value = param[1]
                       dict[key] = value
                       return dict
               }
               
               let token = params["access_token"]
               
               print(token)
               
               
               decisionHandler(.cancel)

    }

}
