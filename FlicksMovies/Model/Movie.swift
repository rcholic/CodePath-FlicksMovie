//
//  Movie.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 4/1/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import ObjectMapper

// MARK: Movie model class
class Movie: BaseJsonModel {
    
    var posterPath: String? // lower resolution
    
    var backdropPath: String? // higher resolution
    
    var adult: Bool = false
    
    var title: String?
    
    var originalTitle: String? // could be in foreign language
    
    var originalLanguage: String? // e.g. en
    
    var overview: String?
    
    var id: Int?
    
    var voteCount: Int?
    
    var voteAverage: Float?
    
    var video: Bool = false
    
    var releaseDate: Date? // e.g. converted from string form 2016-08-26
    
    override func mapping(map: Map) {
        posterPath <- map["poster_path"]
        backdropPath <- map["backdrop_path"]
        adult <- map["adult"]
        title <- map["title"]
        originalTitle <- map["original_title"]
        originalLanguage <- map["original_language"]
        overview <- map["overview"]
        voteCount <- map["vote_count"]
        voteAverage <- map["vote_average"]
        video <- map["video"]
        releaseDate <- (map["release_date"], DateTransform())
        id <- map["id"]
    }
}
