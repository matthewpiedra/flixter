//
//  MovieDetailsViewController.swift
//  flixter
//
//  Created by Matthew Piedra on 9/9/21.

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        
        titleLabel.sizeToFit()
        synopsisLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)!
        
        posterImageView.af.setImage(withURL: posterUrl)
        
        let baseUrl2 = "https://image.tmdb.org/t/p/w780"
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: baseUrl2 + backdropPath)!
        
        backdropImageView.af.setImage(withURL: backdropUrl)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "movieTrailerSegue", sender: nil)
    }
    
    @IBAction func tapGesture2(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "movieTrailerSegue2", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let movie_id = movie["id"] as! Int
        
        let webViewController = segue.destination as! MovieTrailerViewController
        webViewController.movieId = movie_id
    }

}
