/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import Foundation
import UIKit
import Parse



// IMPORTANT: Replace the red string below accordingly to the new name you'll give to this app
//let APP_NAME = "Recipes"
let APP_NAME = "Nutriport"


// PARSE KEYS -> Replace these red keys with your own ones from your Parse app on back4app.com
let PARSE_APP_KEY = "FH5tG5ceS6VNYphhG2bCygq4jG984qIv4wsCWlbV"
let PARSE_CLIENT_KEY = "GcIndXBrHmseaKc2b5s1nlrWuuRFWccXJcCIgw2W"

//let PARSE_APP_KEY = "5KZjExpjct9eOWsAIh9aoLDCp3LpEiVqDb2BuyOK"
//let PARSE_CLIENT_KEY = "dVuvhmlctBZpulAY8mrAziFniq9AxBvKkjVs9Bv9"

// IMPORTANT: REPLACE THE RED STRING BELOW WITH THE UNIT ID YOU'VE GOT BY REGISTERING YOUR APP IN http://www.apps.admob.com
let ADMOB_BANNER_UNIT_ID = "ca-app-pub-3940256099942544/6300978111"



// FOOD CATEGORIES ARRAY (editable)
let categoriesArray =  [
    "Appetizer",
    "Breakfast",
    "Healthy",
    "Holidays & Events",
    "Main Dish",
    "Seafood",
    "Vegetarian",
    "Salad",
    "Desserts",
    "Beverage",
    
    // You can add categories here...
    // IMPORTANT: Also remember to add the proper images into the FOOD CATEGORIES folder in Assets.xcassets, naming them exactly like the red strings above!
    
]


// Custom yellow color
let yellow = UIColor(red: 155/255.0, green: 187/255.0, blue: 86/255.0, alpha: 1.0)



// HUD VIEW
var hudView = UIView()
var animImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
extension UIViewController {
    func showHUD() {
        hudView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        hudView.center = view.center
        hudView.backgroundColor = UIColor.yellow
        hudView.alpha = 0.9
        hudView.clipsToBounds = true
        hudView.layer.cornerRadius = hudView.bounds.size.width/2
        
       // let imagesArr = ["h0", "h1", "h2", "h3", "h4", "h5", "h6", "h7", "h8", "h9", "h10"]
        let imagesArr = ["h0", "h1", "h2", "h3"]
        var images:[UIImage] = []
        for i in 0..<imagesArr.count {
            images.append(UIImage(named: imagesArr[i])!)
        }
        animImage.animationImages = images
        animImage.animationDuration = 0.7
        hudView.addSubview(animImage)
        animImage.startAnimating()
        view.addSubview(hudView)
    }
    
    func hideHUD() {  hudView.removeFromSuperview()  }
    
    func simpleAlert(_ mess:String) {
        let alert = UIAlertController(title: APP_NAME, message: mess, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}












/****** DO NOT EDIT THE CODE BELOW *****/
let USER_CLASS_NAME = "_User"
let USER_FULLNAME = "fullName"
let USER_USERNAME = "username"
let USER_AVATAR = "avatar"
let USER_EMAIL = "email"
let USER_JOB = "job"
let USER_ABOUTME = "aboutMe"
let USER_IS_REPORTED = "isReported"
let USER_REPORT_MESSAGE = "reportMessage"


let LIKES_CLASS_NAME = "Likes"
let LIKES_LIKED_BY = "likedBy"
let LIKES_RECIPE_LIKED = "recipeLiked"


let RECIPES_CLASS_NAME = "Recipes"
let RECIPES_COVER = "cover"
let RECIPES_TITLE = "title"
let RECIPES_TITLE_LOWERCASE = "titleLowercase"
let RECIPES_CATEGORY = "category"
let RECIPES_LIKES = "likes"
let RECIPES_ABOUT = "aboutRecipe"
let RECIPES_DIFFICULTY = "difficulty"
let RECIPES_COOKING = "cooking"
let RECIPES_BAKING = "baking"
let RECIPES_RESTING = "resting"
let RECIPES_YOUTUBE = "youtube"
let RECIPES_VIDEO_TITLE = "videoTitle"
let RECIPES_INGREDIENTS = "ingredients"
let RECIPES_PREPARATION = "preparation"
let RECIPES_USER_POINTER = "userPointer"
let RECIPES_IS_REPORTED = "isReported"
let RECIPES_REPORT_MESSAGE = "reportMessage"
let RECIPES_COMMENTS = "comments"
let RECIPES_KEYWORDS = "keywords"

let ACTIVITY_CLASS_NAME = "Activity"
let ACTIVITY_CURRENT_USER = "currentUser"
let ACTIVITY_OTHER_USER = "otherUser"
let ACTIVITY_TEXT = "text"

let COMMENTS_CLASS_NAME = "Comments"
let COMMENTS_RECIPE_POINTER = "recipePointer"
let COMMENTS_USER_POINTER = "userPointer"
let COMMENTS_COMMENT = "comment"


let defaults = UserDefaults.standard
var currentUser = PFUser.current()
var justSignedUp = false




// MARK: - EXTENSION TO RESIZE A UIIMAGE
extension UIViewController {
    func scaleImageToMaxWidth(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}



// EXTENSION TO FORMAT LARGE NUMBERS INTO K OR M (like 1.1M, 2.5K)
extension Int {
    var abbreviated: String {
        let abbrev = "KMBTPE"
        return abbrev.enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
            } ?? String(self)
    }
}


