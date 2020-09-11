//
//  MovieGridViewController.swift
//  flixster
//
//  Created by Azael Zamora on 9/7/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var movieCollection: UICollectionView!
    var movieList = [[String:Any]]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movieList[indexPath.item]
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        gridCell.posterGridView.af.setImage(withURL: posterURL!)
        return gridCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollection.delegate = self
        movieCollection.dataSource = self
        
        /*let itemSize = UIScreen.main.bounds.width/2 - 3

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3

        movieCollection.collectionViewLayout = layout
        */
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                self.movieCollection.reloadData()
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let superheroMovie = sender as! UICollectionViewCell
        
        let indexPath = movieCollection.indexPath(for: superheroMovie)!
        
        let selectedMovie = movieList[indexPath.row]
        
        let detailsViewController = segue.destination as! SuperheroMovieDetailsViewController
        detailsViewController.superheroMovie = selectedMovie
        
        movieCollection.deselectItem(at: indexPath, animated: true)
        
    }

}
