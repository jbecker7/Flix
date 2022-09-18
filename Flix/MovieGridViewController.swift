//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Jonathan Cole Becker on 9/17/22.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                layout.minimumInteritemSpacing = 5
                layout.minimumLineSpacing = 5
                let cellsPerLine: CGFloat = 2
                let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
                let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
                layout.itemSize = CGSize(width: width, height: width * 3/2)
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 2
//
//        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2) / 2
//        layout.itemSize = CGSize(width: width, height: width*3/2)
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movies = dataDictionary["results"] as! [[String:Any]]
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
        
        let movie = movies[indexPath.item]
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let imageUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: imageUrl!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        
    }
}
