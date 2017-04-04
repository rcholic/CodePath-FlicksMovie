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
    
    fileprivate let movieAPI: MovieAPI
    
    internal let navbarTitle: String
    
    fileprivate let navTitleItem = UINavigationItem()
    
    fileprivate let paginatedMovies = Pagination()
    
    fileprivate let tableviewCellIdentifier = "MovieCell"
    
    fileprivate let collectionCellId = "MovieCollectionCell"
    
    fileprivate let searchBar = UISearchBar()
    
    fileprivate let searchIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    fileprivate let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    fileprivate var curMovies: [Movie] = [] // movies for current page
    
    fileprivate let refreshControl = UIRefreshControl()
    
    fileprivate let tableView = UITableView()
    
    fileprivate var curPage = 1
    
    // MARK: toggle UITableView and UICollectionView
    private (set) var activeViewTag: Int = TABLEVIEW_TAG {
        didSet {
            if activeViewTag == TABLEVIEW_TAG {
                navTitleItem.rightBarButtonItem = collectionIconItem
                
            } else {
                navTitleItem.rightBarButtonItem = tableIconItem
            }
        }
    }
    
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
        setupSearchBar()
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
        
        navTitleItem.title = self.navbarTitle
        activeViewTag = TABLEVIEW_TAG
        navBar.setItems([navTitleItem], animated: false)
    }
    
    private func setupSearchBar() {
        self.view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(NAVBAR_HEIGHT)
            make.height.equalTo(SEARCHBAR_HEIGHT)
        }
        
        searchBar.insertSubview(searchIndicator, at: 0)
        searchIndicator.isHidden = true
        searchIndicator.hidesWhenStopped = true

        searchIndicator.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-25)
        }
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = nil
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: tableviewCellIdentifier)
        tableView.tableFooterView = UIView() // don't show empty cells
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.searchBar.snp.bottom)
        }
    }
    
    @objc private func loadNextPage(_ refresher: UIRefreshControl) {
        curPage += 1
        fetchData(page: curPage)
    }
    
    @objc private func switchListView(_ sender: UIBarButtonItem) {
        handleSwitchView(to: sender.tag)
    }
    
    private func fetchData(page: Int) {
        
        SVProgressHUD.showInfo(withStatus: "Fetching Movies...")
        APIService.shared.getMoviesFor(movieAPI: self.movieAPI, page: page) { (movies: [Movie], errorMsg: String?, statusCode: Int?) in
            
            OperationQueue.main.addOperation({
                
                // save movies in memory cache
                guard var error = errorMsg else {
                    // prepend
                    self.curMovies.insert(contentsOf: movies, at: 0)
                    self.refreshCurView(viewTag: self.activeViewTag)
                    SVProgressHUD.dismiss()
                    
                    // cache the movies for this page
                    self.paginatedMovies.insertMovies(movies: movies, page: page)
                    self.refreshControl.endRefreshing()
                    return
                }
                
                if statusCode != nil {
                    error = "\(error), error code: \(statusCode!)"
                }
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    // MARK: switch to the view with the given viewTag
    private func handleSwitchView(to tag: Int) {

        activeViewTag = tag // update the active tag
        if (tag == TABLEVIEW_TAG) {
            self.collectionView.removeFromSuperview()
            // mount tableView
            self.view.addSubview(tableView)
            tableView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(self.searchBar.snp.bottom)
            }
            
        } else {
            self.tableView.removeFromSuperview()
            // mount collectionView
            collectionView.dataSource = self
            collectionView.delegate = self
            self.view.addSubview(collectionView)
            collectionView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(self.searchBar.snp.bottom)
            }
        }
        refreshCurView(viewTag: activeViewTag)
    }
    
    fileprivate func refreshCurView(viewTag: Int) {
        if (viewTag == TABLEVIEW_TAG) {
            self.tableView.reloadData()
        } else {
            self.collectionView.reloadData()
        }
    }

    private lazy var tableIconItem: UIBarButtonItem = {
        let iconItem = UIBarButtonItem(image: UIImage(named: "table_icon"), style: .plain, target: self, action: #selector(self.switchListView(_:)))
        iconItem.tag = TABLEVIEW_TAG
        return iconItem
    }()
    
    private lazy var collectionIconItem: UIBarButtonItem = {
        let iconItem = UIBarButtonItem(image: UIImage(named: "collection_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.switchListView(_:)))
        iconItem.tag = COLLECTIONVIEW_TAG
        
        return iconItem
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2.0
        layout.minimumLineSpacing = 2.0
        let gridView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gridView.backgroundColor = UIColor.white
        gridView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.collectionCellId)
        gridView.insertSubview(self.refreshControl, at: 0) // pull to refresh
        
        return gridView
    }()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: tableviewCellIdentifier) as! MovieTableViewCell
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

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.bringSubview(toFront: searchIndicator)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchIndicator.stopAnimating()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.characters.count == 0 {
            
            searchIndicator.stopAnimating()
            if let savedMovies = paginatedMovies.getMoviesFor(page: curPage) {
                curMovies = savedMovies
            }
        } else {
            searchIndicator.isHidden = false
            if !searchIndicator.isAnimating {
                searchIndicator.startAnimating()
            }
            
            if let savedMovies = paginatedMovies.getMoviesFor(page: curPage) {
                curMovies = savedMovies.filter {
                    String(describing: $0.title).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
            }
        }

        self.refreshCurView(viewTag: self.activeViewTag)
        
        
        // delay stopping searchIndicator for half second for showing search-related delay effect
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.searchIndicator.stopAnimating()
        }
    }
}

extension MovieListViewController: UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let targetVC = mainStoryboard.instantiateViewController(withIdentifier: "MovieDetailBoard") as? MovieDetailViewController {
            let movie = curMovies[indexPath.row]
            targetVC.movie = movie
            self.present(targetVC, animated: true, completion: nil)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 135, height: 135)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellId, for: indexPath) as! MovieCollectionViewCell
        let movie = curMovies[indexPath.row]
        cell.bind(movie)
        
        return cell
    }
}
