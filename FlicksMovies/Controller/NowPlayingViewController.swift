//
//  NowPlayingViewController.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 3/31/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit
import SVProgressHUD

class PaginatedMovie: NSObject {
    
    var lastPage: Int = 0 // 1-based
    var moviesByPage: [Int: [Movie]] = [:]
    
    public func insertMovies(movies: [Movie], page: Int) {
        moviesByPage[page] = movies // replacement
        lastPage = page
    }
    
    // MARK: total number of entries
    public func getPageCounts() -> Int {
        return moviesByPage.count
    }
    
    public func getMoviesFor(page: Int) -> [Movie]? {
        return moviesByPage[page] // cound be nil
    }
    
    public func deleteMoviesFor(page: Int) {
        if moviesByPage[page] != nil {
            moviesByPage.removeValue(forKey: page)
        }
    }
}

class NowPlayingViewController: UIViewController {

    let cellIdentifier = "MovieCell"    
    var curPage = 1
    var curMovies: [Movie] = [] // movies for current page
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData(page: curPage)
        
//        self.navigationController?.navigationBar.isHidden = true // hide nav bar
    }
    
    private func fetchData(page: Int) {
        
        APIService.shared.getMoviesFor(movieAPI: MovieAPI.nowPlaying, page: page) { (movies: [Movie], errorMsg: String?, statusCode: Int?) in
            
            print("received movies count: \(movies.count)")
            OperationQueue.main.addOperation({
                // TODO: save movies in memory cache
                self.curMovies = movies
                self.tableView.reloadData()
            })
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
//        tableView.contentSize = CGSize(self)
    }
}

extension NowPlayingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NowPlayingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curMovies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MovieTableViewCell
        let movie = curMovies[indexPath.row]
        cell.bind(movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}
