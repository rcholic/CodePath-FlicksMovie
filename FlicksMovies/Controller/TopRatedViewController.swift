//
//  TopRatedViewController.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 3/31/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit
import SVProgressHUD

class TopRatedViewController: UIViewController {

    let paginatedTopMovies = Pagination()
    let cellIdentifier = "MovieCell"
    let refreshControl = UIRefreshControl()
    
    var curPage = 1
    var curMovies: [Movie] = [] // movies for current page
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupTableView()
        fetchData(page: curPage)
        refreshControl.addTarget(self, action: #selector(self.loadNextPage(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    private func setupNavbar() {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: NAVBAR_HEIGHT))
        self.view.addSubview(navBar)
        
        navBar.barTintColor = NAVIGATIONBAR_COLOR
        let textColor = NAVIGATIONBAR_TEXT_COLOR
        navBar.tintColor = textColor
        
        let textShadow = NSShadow()
        textShadow.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        textShadow.shadowOffset = CGSize(width: 0, height: 1.0)
        let fontAttr = UIFont(name: "HelveticaNeue-CondensedBlack", size: 23)
        
        navBar.titleTextAttributes = NSDictionary(objects: [textColor, textShadow, fontAttr!], forKeys: [NSForegroundColorAttributeName as NSCopying, NSShadowAttributeName as NSCopying, NSFontAttributeName as NSCopying]) as? [String : AnyObject]
        
        
        let navItem = UINavigationItem(title: "Top Rated")
        // TODO: add buttons for switching between tableview and collection
        //        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: "selector")
        //        navItem.rightBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: false)
    }
    
    private func fetchData(page: Int) {
        
        SVProgressHUD.showInfo(withStatus: "Fetching Movies...")
        APIService.shared.getMoviesFor(movieAPI: MovieAPI.topRated, page: page) { (movies: [Movie], errorMsg: String?, statusCode: Int?) in

            OperationQueue.main.addOperation({
                
                // save movies in memory cache
                guard var error = errorMsg else {
                    // prepend
                    self.curMovies.insert(contentsOf: movies, at: 0)
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    
                    // cache the movies for this page
                    self.paginatedTopMovies.insertMovies(movies: movies, page: page)
                    self.refreshControl.endRefreshing()
//                    self.tableView.insertSubview(self.refreshControl, at: 0)
                    return
                }
                
                if statusCode != nil {
                    error = "\(error), error code: \(statusCode!)"
                }
                
                AlertUtil.shared.show(message: error, viewcontroller: self, autoClose: true, delay: 5.0)
                self.refreshControl.endRefreshing()
//                self.tableView.insertSubview(self.refreshControl, at: 0)
            })
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = nil
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        //        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        //        tableView.contentSize = CGSize(self)
    }
    
    @objc private func loadNextPage(_ refresher: UIRefreshControl) {
        curPage += 1
//        refreshControl.removeFromSuperview() // disable it
        fetchData(page: curPage)
    }
}

extension TopRatedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let targetVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailBoard") as? MovieDetailViewController {
            let movie = curMovies[indexPath.row]
            targetVC.movie = movie
            self.present(targetVC, animated: true, completion: nil)
            //            self.navigationController?.pushViewControllerWithTabbarHidden(targetVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TopRatedViewController: UITableViewDataSource {
    
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



