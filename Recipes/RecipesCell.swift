/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit

class RecipesCell: UICollectionViewCell {
    
    /* Views */
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeOutlet: UIButton!
    
    @IBOutlet weak var commentsLabel: UILabel!

 //   @IBOutlet weak var avatarOutlet: UIButton!
 //   @IBOutlet weak var fullNameLabel: UILabel!
    var meal : Meal! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let meal = meal {
            coverImage.image = meal.featuredImage
            titleLabel.text = meal.title
        } else {
            coverImage.image = nil
            titleLabel.text = nil
        }
    }
}
