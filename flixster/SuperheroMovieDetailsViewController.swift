//
//  SuperheroMovieDetailsViewController.swift
//  flixster
//
//  Created by Azael Zamora on 9/10/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import AlamofireImage

class SuperheroMovieDetailsViewController: UIViewController {

    @IBOutlet weak var backPosterView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var superheroMovie: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = superheroMovie["title"] as? String
        synopsisLabel.text = superheroMovie["overview"] as? String
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = superheroMovie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        posterView.af.setImage(withURL: posterURL!)
        
        let backPosterPath = superheroMovie["backdrop_path"] as! String
        let backPosterURL = URL(string: "https://image.tmdb.org/t/p/w780" + backPosterPath)
        
        backPosterView.af.setImage(withURL: backPosterURL!)
        
    }
    
    @IBAction func posterIsTapped(_ sender: Any) {
        performSegue(withIdentifier: "SuperHeroTrailer", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "SuperHeroTrailer" {
            let movieTrailer = segue.destination as! SuperheroMovieTrailerViewController
            movieTrailer.movieID = superheroMovie["id"] as! Int
        }
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
