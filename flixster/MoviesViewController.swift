//
//  MoviesViewController.swift
//  flixster
//
//  Created by Azael Zamora on 9/1/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // connects to the tableView from main.storyboard
    @IBOutlet weak var movieTable: UITableView!
    
    // movieList is an array of dictionaries
    var movieList = [[String:Any]]()
    
    // basically asks for the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count  // returns the size of movieList
    }
    
    // for a particular row, return its cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // basically uses an recycled cells that are available, and cell is casted as MovieCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        //cell.backgroundColor = UIColor.black
        let movie = movieList[indexPath.row]
        
        // movieTitle casts movie["title"] as a string value, gets the title of a Movie
        let movieTitle = movie["title"] as! String
        
        // movieSynopsis casts movie["overview"' as a string value, gets the synopsis of a Movie
        let movieSynopsis = movie["overview"] as! String

        cell.movieTitleLabel.text = movieTitle  // sets the movieLabel to movieTitle
        cell.synopsisLabel.text = movieSynopsis // sets the synopsisLabel to movieSynopsis
        
        let baseURL = "https://image.tmdb.org/t/p/w185"     // the base URL for accessing the poster images for the movies
        let posterPath = movie["poster_path"] as! String    // posterPath has the "poster_path" value from movie as String
        let posterURL = URL(string: baseURL + posterPath)   // posterURL is the concatenation of baseURL+posterPath for the overall poster image of the movie cell
        
        cell.posterImage.af.setImage(withURL: posterURL!)   // posterImage is set with the poster URL using AlamofireImage
        
        // cell.backgroundColor = UIColor(hex: 0x1F2124, alpha: 1.0)
        return cell                                         // movieTitle, movieSynopsis, and posterImage are set for the according movie
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view.backgroundColor = UIColor(hex: 0x1F2124, alpha: 1.0)
        
        movieTable.dataSource = self
        movieTable.delegate = self
        
        // Do any additional setup after loading the view.
        // prints Hello, this is just to make sure its working
        // print("Hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // this will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            }else if let data = data {
                // dataDictionary has the data that is needed for movieList
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // print(dataDictionary)
                // movieList now has the "results" from dataDictionary as an array of dictionaries of type String
                self.movieList = dataDictionary["results"] as! [[String: Any]]
                
                //movieTable is updated each time as it calls the two tableView functions
                self.movieTable.reloadData()
            }
        }
        task.resume()
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0){
        let r = CGFloat( (hex >> 16) & 0x000000ff) / 255
        let g = CGFloat( (hex >> 8) & 0x000000ff) / 255
        let b = CGFloat(hex & 0x000000ff) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
