//
//  SuperheroMovieTrailerViewController.swift
//  flixster
//
//  Created by Azael Zamora on 9/10/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import WebKit

class SuperheroMovieTrailerViewController: UIViewController, WKUIDelegate {
    
    var movieID = 0
    var webView: WKWebView!
    var youtubeList: [[String: Any]] = []
    var movieKey = ""
    
    override func loadView() {
        let configure = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configure)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // this will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            }else if let data = data {
                // dataDictionary has the data that is needed for movieList
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
               
                self.youtubeList = dataDictionary["results"] as! [[String: Any]]
                
                for trailer in self.youtubeList {
                    let trailer_site = trailer["site"] as! String
                    if trailer_site == "YouTube" {
                        self.movieKey = trailer["key"] as! String
                        break
                    }
                }
                
                let trailer_url = URL(string: "https://www.youtube.com/watch?v=\(self.movieKey)")
                let trailer_request = URLRequest(url: trailer_url!)
                
                self.webView.load(trailer_request)
            }
        }
        task.resume()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
