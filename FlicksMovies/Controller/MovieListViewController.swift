//
//  MovieListViewController.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 4/2/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class MovieListViewController: UIViewController {
    
    var movieAPI: MovieAPI
    
    var navbarTitle: String
    
    let paginatedMovies = Pagination()
    
    let cellIdentifier = "MovieCell"
    
    let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    var curMovies: [Movie] = [] // movies for current page
    
    let refreshControl = UIRefreshControl()
    
    let tableView = UITableView()
    
    var curPage = 1
    
    init(navbarTitle: String, movieAPI: MovieAPI) {
        self.navbarTitle = navbarTitle
        self.movieAPI = movieAPI
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupTableView()
        fetchData(page: curPage)
        refreshControl.addTarget(self, action: #selector(self.loadNextPage(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    private func setupNavbar() {
        
        let navBar: UINavigationBar = UINavigationBar()
        self.view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(NAVBAR_HEIGHT)
        }
        
        navBar.barTintColor = NAVIGATIONBAR_COLOR
        let textColor = NAVIGATIONBAR_TEXT_COLOR
        navBar.tintColor = textColor
        
        let textShadow = NSShadow()
        textShadow.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        textShadow.shadowOffset = CGSize(width: 0, height: 1.0)
        let fontAttr = UIFont(name: "HelveticaNeue-CondensedBlack", size: 23)
        
        navBar.titleTextAttributes = NSDictionary(objects: [textColor, textShadow, fontAttr!], forKeys: [NSForegroundColorAttributeName as NSCopying, NSShadowAttributeName as NSCopying, NSFontAttributeName as NSCopying]) as? [String : AnyObject]
        
        
        let navItem = UINavigationItem(title: self.navbarTitle)
        // TODO: add buttons for switching between tableview and collection
        //        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: "selector")
        //        navItem.rightBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: false)
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = nil
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(NAVBAR_HEIGHT)
        }
    }
    
    @objc private func loadNextPage(_ refresher: UIRefreshControl) {
        curPage += 1
        fetchData(page: curPage)
    }
    
    private func fetchData(page: Int) {
        
        SVProgressHUD.showInfo(withStatus: "Fetching Movies...")
        APIService.shared.getMoviesFor(movieAPI: self.movieAPI, page: page) { (movies: [Movie], errorMsg: String?, statusCode: Int?) in
            
            OperationQueue.main.addOperation({
                
                // save movies in memory cache
                guard var error = errorMsg else {
                    // prepend
                    self.curMovies.insert(contentsOf: movies, at: 0)
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    
                    // cache the movies for this page
                    self.paginatedMovies.insertMovies(movies: movies, page: page)
                    self.refreshControl.endRefreshing()
                    return
                }
                
                if statusCode != nil {
                    error = "\(error), error code: \(statusCode!)"
                }
                
                AlertUtil.shared.show(message: "Network Error! Try Refresh", viewcontroller: self, autoClose: true, delay: 5.0)
                self.refreshControl.endRefreshing()
            })
        }
    }
}

extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let targetVC = mainStoryboard.instantiateViewController(withIdentifier: "MovieDetailBoard") as? MovieDetailViewController {
            let movie = curMovies[indexPath.row]
            targetVC.movie = movie
            self.present(targetVC, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curMovies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MovieTableViewCell
        let movie = curMovies[indexPath.row]

        let backgroundView = UIView()
        backgroundView.frame = cell.bounds
        backgroundView.backgroundColor = CELL_SEPARATOR_COLOR.withAlphaComponent(0.5)
        cell.selectedBackgroundView = backgroundView
        
        cell.bind(movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}
