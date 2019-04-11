//
//  MealCollectionViewCell.swift
//  Recipes
//
//  Created by SunXinzhuo on 4/6/19.
//  Copyright © 2019 FV iMAGINATION. All rights reserved.
//

import UIKit
import Parse

import AudioToolbox

class MealCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var featuredImageView:UIImageView!
    @IBOutlet weak var mealTitleLabel:UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeOutlet: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    
    var meal : Meal! {
        didSet {
        self.updateUI()
        }
    }
    
    func updateUI() {
        if let meal = meal {
            featuredImageView.image = meal.featuredImage
            mealTitleLabel.text = meal.title
        } else {
            featuredImageView.image = nil
            mealTitleLabel.text = nil
        }
    }
    
}
