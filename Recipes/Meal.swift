//
//  Meal.swift
//  Recipes
//
//  Created by SunXinzhuo on 4/11/19.
//  Copyright © 2019 FV iMAGINATION. All rights reserved.
//

import Foundation
import UIKit

class Meal {
    var title = ""
    var featuredImage: UIImage
    
    init(title: String, featuredImage: UIImage) {
        self.title = title
        self.featuredImage = featuredImage
    }
}
