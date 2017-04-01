//
//  CommonSettings.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 3/31/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit

public let SCREEN_WIDTH = UIScreen.main.bounds.size.width

public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

public let TABBAR_HEIGHT: CGFloat = 49.0

public let NAVBAR_HEIGHT: CGFloat = 64

public let NAVIGATIONBAR_COLOR = UIColor.green

public let CELL_SEPARATOR_COLOR = UIColor.green

public let HIGHLIGHTED_FONT_COLOR = UIColor.blue

public func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: alpha)
}
