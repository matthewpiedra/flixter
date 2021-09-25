//
//  MovieGridViewController.swift
//  flixter
//
//  Created by Matthew Piedra on 9/9/21.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        let height = width * 3 / 2
        layout.itemSize = CGSize(width: width, height: height)
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/209112/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                    // TODO: Get the array of movies
                    self.movies = dataDictionary["results"] as! [[String: Any]]
                    
                    self.collectionView.reloadData()
             }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let currMovie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = currMovie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)!
        
        cell.posterView.af.setImage(withURL: posterUrl)
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected movie
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        let movie = movies[indexPath!.row]
        
        // Pass the selected movie to the details view controller
        let detailViewController = segue.destination as! MovieDetailsViewController
        
        detailViewController.movie = movie
        
        // deselect the tapped on movie after the transition
        collectionView.deselectItem(at: indexPath!, animated: true)
    }
}
