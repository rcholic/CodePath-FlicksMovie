//
//  CommonSettings.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 3/31/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit

public enum ImageSize: String {
    case small = "w185"
    case medium = "w300"
    case large = "w780"
}

public let SCREEN_WIDTH = UIScreen.main.bounds.size.width

public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

public let TABBAR_HEIGHT: CGFloat = 49.0

public let NAVBAR_HEIGHT: CGFloat = 64

public let NAVIGATIONBAR_COLOR = UIColor.green

public let CELL_SEPARATOR_COLOR = UIColor.green

public let HIGHLIGHTED_FONT_COLOR = UIColor.blue // TODO: change to default tint color

public let API_KEY = "a07e22bc18f5cb106bfe4cc1f83ad8ed"

public let SERVER_URL = "https://api.themoviedb.org/3/movie"

public let SMALL_POSTER_IMAGE_BASE_URL = "http://image.tmdb.org/t/p/\(ImageSize.small.rawValue)"

public let LARGE_POSTER_IMAGE_BASE_URL = "http://image.tmdb.org/t/p/\(ImageSize.large.rawValue)"

public let NOW_PLAYING_URL: String = "\(SERVER_URL)/now_playing?api_key=\(API_KEY)" // TODO: change page number

public let TOP_RATED_URL: String = "\(SERVER_URL)/top_rated?api_key=\(API_KEY)" // TODO:  change page number



public func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: alpha)
}
