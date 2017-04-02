//
//  Pagination.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 4/1/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import Foundation

class Pagination: NSObject {
    
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
