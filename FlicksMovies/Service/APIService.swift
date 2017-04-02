//
//  APIService.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 4/1/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import AFNetworking
import SwiftyJSON
import ObjectMapper

public enum MovieAPI: String {
    
    case nowPlaying
    
    case topRated
    
    func retrieveURL() -> String {
        switch self {
        case .nowPlaying:
            return NOW_PLAYING_URL // can be appended with &page=1
        default:
            return TOP_RATED_URL // can be appended with &page=1
        }
    }
}

typealias CompletionHandler = (_: [Movie], _ errorStr: String?, _ statusCode: Int?) -> Void
struct APIService {
    
    public static let shared = APIService()
    
    private let manager = AFHTTPSessionManager()
    
    fileprivate init() {}
    
    // completion handler? error handler?
    func getMoviesFor(movieAPI: MovieAPI, page: Int = 1, completionHandler: @escaping CompletionHandler) {
        
        var movies: [Movie] = []
        
        var apiURL = movieAPI.retrieveURL()
        apiURL = "\(apiURL)&page=\(page)"
        
        manager.get(apiURL, parameters: nil, progress: { (percentage) in
            print("percentage done: \(percentage)")
        }, success: { (task: URLSessionDataTask, responseObj) in
            
            // TODO: get status code and throw error if any

            if let response = responseObj as? [String : Any] {
                let json = JSON(response)
                let results = json["results"].arrayObject
                if let data = Mapper<Movie>().mapArray(JSONObject: results) {
                    movies = data
                    completionHandler(movies, nil, nil)
                }
            }

            // MARK: this also works without using SwiftyJSON
//            if let response = responseObj as? [String : Any], let results = response["results"] as? [[String : Any]] {
//                movies = Mapper<Movie>().mapArray(JSONArray: results)!
//                print("movies.count: \(movies.count)")
//            }

        }) { (task: URLSessionDataTask?, error: Error) in
            
            var statusCode: Int? = nil
            // MARK: get the status code for the error
            if let response = task?.response as? HTTPURLResponse {
                statusCode = response.statusCode
            }
            
            completionHandler(movies, error.localizedDescription, statusCode)
        }
    }
}
