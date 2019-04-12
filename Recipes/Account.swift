/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse
import GoogleMobileAds
import AudioToolbox



// MARK: - CUSTOM MY RECIPES CELL
class MyRecipesCell: UITableViewCell {
    
    /* Views */
    @IBOutlet weak var coverThumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
}





class Account: UIViewController,
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
GADBannerViewDelegate
{

    
    /* Views */
    @IBOutlet weak var noUserView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var editProfileOutlet: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var aboutMeTxt: UITextView!
    
    @IBOutlet weak var recipesSegControl: UISegmentedControl!
    
    @IBOutlet weak var myRecipesTableView: UITableView!
    @IBOutlet weak var likedRecipesCollView: UICollectionView!
    
    @IBOutlet weak var activityOutlet: UIButton!
    
    //Ad banners properties
    var adMobBannerView = GADBannerView()
    
    
    
    
    /* Variables */
    var myRecipesArray = [PFObject]()
    var likedRecipesArray = [PFObject]()
    var userArray = [PFObject]()
    var likesArray = [PFObject]()
    var cellSize = CGSize()
    
    

    

override func viewDidAppear(_ animated: Bool) {
    
    UIApplication.shared.applicationIconBadgeNumber = 0
    
    if PFUser.current() == nil {
        noUserView.isHidden = false
        mainView.isHidden = true
        
    } else {
        noUserView.isHidden = true
        mainView.isHidden = false
        
        
        // Call query for My recipes
        queryMyRecipes()
        showUserDetails()
    }

}
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    // Round views coners
    noUserView.layer.cornerRadius = 10
    editProfileOutlet.layer.cornerRadius = 5
    activityOutlet.layer.cornerRadius = 5
    avatarImage.layer.cornerRadius = avatarImage.bounds.size.width/2
    avatarImage.layer.borderColor = UIColor.white.cgColor
    avatarImage.layer.borderWidth = 2
    
    
    // Fix size and origin of views
    myRecipesTableView.frame = CGRect(x: 0, y: 220, width: view.frame.size.width, height: view.frame.size.height - 264 - 130)
    myRecipesTableView.autoresizingMask = .flexibleBottomMargin
    myRecipesTableView.autoresizingMask = .flexibleHeight
    myRecipesTableView.autoresizingMask = .flexibleLeftMargin
    myRecipesTableView.autoresizingMask = .flexibleRightMargin
    myRecipesTableView.autoresizingMask = .flexibleTopMargin
    myRecipesTableView.autoresizingMask = .flexibleWidth
    
    likedRecipesCollView.frame = CGRect(x: 0, y: 220, width: view.frame.size.width, height: view.frame.size.height - 264 - 130)
    likedRecipesCollView.autoresizingMask = .flexibleBottomMargin
    likedRecipesCollView.autoresizingMask = .flexibleHeight
    likedRecipesCollView.autoresizingMask = .flexibleLeftMargin
    likedRecipesCollView.autoresizingMask = .flexibleRightMargin
    likedRecipesCollView.autoresizingMask = .flexibleTopMargin
    likedRecipesCollView.autoresizingMask = .flexibleWidth
    
    
    // Set cell size based on current device
    if UIDevice.current.userInterfaceIdiom == .phone {
        // iPhone
        cellSize = CGSize(width: view.frame.size.width/2 - 20, height: 280)
    } else  {
        // iPad
        cellSize = CGSize(width: view.frame.size.width/3 - 20, height: 280)
    }

    
    // Init ad banners
    // initAdMobBanner()
}



// MARK: - SHOW CURRENT USER DETAILS
func showUserDetails() {
    let aUser = PFUser.current()!
    
    // Get avatar image
    avatarImage.image = UIImage(named: "logo")
//    let imageFile = aUser[USER_AVATAR] as? PFFile
//    imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
//        if error == nil {
//            if let imageData = imageData {
//                self.avatarImage.image = UIImage(data:imageData)
//    } } })
    
    if aUser[USER_JOB] != nil { fullNameLabel.text = "\(aUser[USER_FULLNAME]!), \(aUser[USER_JOB]!)"
    } else { fullNameLabel.text = "\(aUser[USER_FULLNAME]!)" }
    
    if aUser[USER_ABOUTME] != nil { aboutMeTxt.text = "\(aUser[USER_ABOUTME]!)"
    } else { aboutMeTxt.text = "N/D" }
    
    
}
    
    
    
// MARK: - SWITCH BETWEEN MY RECIPES AND SAVED ONES
@IBAction func recipesSegControlChanged(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
        queryMyRecipes()
    } else {
        queryLikedRecipes()
    }
}

    
    
// MARK: - QUERY MY RECIPES
func queryMyRecipes() {
    likedRecipesCollView.isHidden = true
    myRecipesTableView.isHidden = false
    recipesSegControl.selectedSegmentIndex = 0
    
    showHUD()
    
    let query = PFQuery(className: RECIPES_CLASS_NAME)
    query.whereKey(RECIPES_USER_POINTER, equalTo: PFUser.current()!)
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            self.myRecipesArray = objects!
            // Reload TableView
            self.myRecipesTableView.reloadData()
            self.hideHUD()
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
    
    
// MARK: - MY RECIPES TABLEVIEW DELEGATES
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return myRecipesArray.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyRecipesCell", for: indexPath) as! MyRecipesCell
        
    var recipesClass = PFObject(className: RECIPES_CLASS_NAME)
    recipesClass = myRecipesArray[indexPath.row]
    
    cell.titleLabel.text = "\(recipesClass[RECIPES_TITLE]!)"
    
    // Get image
    let imageFile = recipesClass[RECIPES_COVER] as? PFFile
    imageFile?.getDataInBackground { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                cell.coverThumbnail.image = UIImage(data:imageData)
    } } }
    //cell.coverThumbnail.image = UIImage(named: recipesClass["pictrue"] as! String)
    cell.coverThumbnail.layer.cornerRadius = 5
    
return cell
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
}
    
// MARK: -  CELL HAS BEEN TAPPED -> EDIT RECIPE
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var recipesClass = PFObject(className: RECIPES_CLASS_NAME)
    recipesClass = myRecipesArray[indexPath.row]
    
    let aerVC = storyboard?.instantiateViewController(withIdentifier: "AddEditRecipe") as! AddEditRecipe
    aerVC.recipeObj = recipesClass
    navigationController?.pushViewController(aerVC, animated: true)
}
    
    
// MARK: - DELETE RECIPE SWIPING THE CELL LEFT
func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
}
func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            var recipesClass = PFObject(className: RECIPES_CLASS_NAME)
            recipesClass = myRecipesArray[indexPath.row]
            
            // DELETE ALL LIKES OF THIS RECIPE (if any)
            let query = PFQuery(className: LIKES_CLASS_NAME)
            query.whereKey(LIKES_RECIPE_LIKED, equalTo: recipesClass)
            query.findObjectsInBackground { (objects, error)-> Void in
                if error == nil {
                    self.likesArray = objects!

                    DispatchQueue.main.async(execute: {
                        if self.likesArray.count > 0 {
                            for i in 0..<self.likesArray.count {
                                var likesClass = PFObject(className: LIKES_CLASS_NAME)
                                likesClass = self.likesArray[i]
                                likesClass.deleteInBackground()
                            }
                        }
                    })
                    
                    
                // DELETE RECIPE
                recipesClass.deleteInBackground {(success, error) -> Void in
                    if error == nil {
                        self.myRecipesArray.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                            
                    } else {
                        self.simpleAlert("\(error!.localizedDescription)")
                    }}
            }}}
}

    
    
    
    

// MARK: - QUERY LIKED RECIPES
func queryLikedRecipes() {
    likedRecipesCollView.isHidden = false
    myRecipesTableView.isHidden = true

    likedRecipesArray.removeAll()
    showHUD()
        
    let query = PFQuery(className: LIKES_CLASS_NAME)
    query.whereKey(LIKES_LIKED_BY, equalTo: PFUser.current()!)
    query.includeKey(RECIPES_CLASS_NAME)
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            self.likedRecipesArray = objects!
            // Reload CollView
            self.likedRecipesCollView.reloadData()
            self.hideHUD()
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}

    
    
// MARK: - LIKED RECIPES COLLECTION VIEW DELEGATES
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return likedRecipesArray.count
}
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCell", for: indexPath) as! RecipesCell
        
    var likesClass = PFObject(className: LIKES_CLASS_NAME)
    likesClass = likedRecipesArray[indexPath.row]
    
    // Get Recipe Pointer
    let  recipePointer = likesClass[LIKES_RECIPE_LIKED] as! PFObject
    recipePointer.fetchIfNeededInBackground { (recipe, error) in
    
        
        // THIS RECIPE HAS NOT BEEN REPORTED
        if recipePointer[RECIPES_IS_REPORTED] as! Bool == false {
        
            // Get User Pointer
            let userPointer = recipePointer[RECIPES_USER_POINTER] as! PFUser
        	userPointer.fetchIfNeededInBackground { (user, error) in
                if error == nil {
                    
                    // Get Title & Category
                    cell.titleLabel.text = "\(recipePointer[RECIPES_TITLE]!)"
                    cell.categoryLabel.text = "\(recipePointer[RECIPES_CATEGORY]!)"
                
                    
                    // Get Likes
                    if recipePointer[RECIPES_LIKES] != nil {
                        let likes = recipePointer[RECIPES_LIKES] as! Int
                        cell.likesLabel.text = likes.abbreviated
                    } else { cell.likesLabel.text = "0" }

                    
                    // Get Cover image
//                    let imageFile = recipePointer[RECIPES_COVER] as? PFFile
//                    imageFile?.getDataInBackground(block: { (data, error) -> Void in
//                        if error == nil {
//                            if let imageData = data {
//                                cell.coverImage.image = UIImage(data: imageData)
//                    }}})
                    cell.coverImage.image = UIImage(named: recipePointer["pictrue"] as! String)

                    
                    // Assign tags
                    cell.likeOutlet.tag = indexPath.row
//                    cell.avatarOutlet.tag = indexPath.row
                
                    // Customize cell's layout
                    cell.layer.cornerRadius = 10
                    cell.layer.shadowColor = UIColor.black.cgColor
                    cell.layer.shadowOffset = CGSize(width: 10, height: 10)
                    cell.layer.shadowOpacity = 1

            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                    
        }} // end userPointer
        
            
            
        
        // THIS RECIPE HAS BEEN REPORTED!
        } else {
            cell.titleLabel.text = "REPORTED!"
            cell.categoryLabel.text = ""
     //       cell.fullNameLabel.text = ""
            cell.likesLabel.text = "N/A"
            cell.coverImage.image = nil
            cell.coverImage.backgroundColor = UIColor.darkGray
     //       cell.avatarOutlet.setBackgroundImage(nil, for: .normal)
      //      cell.avatarOutlet.isEnabled = false
            cell.likeOutlet.isEnabled = false
        }
        
        
    }// end recipePointer
    
        
    
return cell
}
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return cellSize
}
    
// MARK: - TAP A CELL -> SHOW RECIPE
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var likesClass = PFObject(className: LIKES_CLASS_NAME)
    likesClass = likedRecipesArray[indexPath.row]
    // Recipe Pointer
    let recipePointer = likesClass[LIKES_RECIPE_LIKED] as! PFObject
    recipePointer.fetchIfNeededInBackground { (recipe, error) in

        if recipePointer[RECIPES_IS_REPORTED] as! Bool == false {
            let rdVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetails") as! RecipeDetails
            rdVC.recipeObj = recipePointer
            self.navigationController?.pushViewController(rdVC, animated: true)
        } else {
            self.simpleAlert("This Recipe has been reported!")
        }
    }
}
    

    
// MARK: - UNLIKE RECIPE BUTTON
@IBAction func unlikeButt(_ sender: AnyObject) {
    let butt = sender as! UIButton
    let indexP = IndexPath(row: butt.tag, section: 0)
    let cell = likedRecipesCollView.cellForItem(at: indexP) as! RecipesCell
    
    var likesClass = PFObject(className: LIKES_CLASS_NAME)
    likesClass = likedRecipesArray[butt.tag]
    
    // Recipe Pointer
    let recipePointer = likesClass[LIKES_RECIPE_LIKED] as! PFObject
    recipePointer.fetchIfNeededInBackground { (recipe, error) in
    
        recipePointer.incrementKey(RECIPES_LIKES, byAmount: -1)
        recipePointer.saveInBackground()
        let likeInt = recipePointer[RECIPES_LIKES] as! Int
        cell.likesLabel.text = likeInt.abbreviated
    
        likesClass.deleteInBackground {(success, error) -> Void in
            if error == nil {
                self.simpleAlert("You've unliked this recipe")
                self.likedRecipesArray.remove(at: butt.tag)
                self.likedRecipesCollView.reloadData()
        }}
    }
}
    
    
    
// MARK: - USER AVATAR BUTTON -> SHOW ITS PROFILE
@IBAction func avatarButt(_ sender: AnyObject) {
    let butt = sender as! UIButton
        
    var likesClass = PFObject(className: LIKES_CLASS_NAME)
    likesClass = likedRecipesArray[butt.tag] 
    
    // Recipe Pointer
    let recipePointer = likesClass[LIKES_RECIPE_LIKED] as! PFObject
    recipePointer.fetchIfNeededInBackground { (recipe, error) in
      
        // User Pointer
        let userPointer = recipePointer[RECIPES_USER_POINTER] as! PFUser
        userPointer.fetchIfNeededInBackground { (user, error) in
            if error == nil {
                let oupVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfile") as! OtherUserProfile
                oupVC.otherUserObj = userPointer
                self.navigationController?.pushViewController(oupVC, animated: true)
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
        }}
    }
}
    
    
    
    
// MARK: - ADD RECIPE BUTTON
@IBAction func addRecipeButt(_ sender: AnyObject) {
    if PFUser.current() != nil {
        let aerVC = storyboard?.instantiateViewController(withIdentifier: "AddEditRecipe") as! AddEditRecipe
        navigationController?.pushViewController(aerVC, animated: true)
    } else {
        let alert = UIAlertView(title: "\(APP_NAME)",
            message: "You must login/sign up to add a recipe!",
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }
}

    
    
    
// SHOW ACTIVITIES BUTTON
@IBAction func activityButt(_ sender: AnyObject) {
    let aVC = storyboard?.instantiateViewController(withIdentifier: "ActivityVC") as! ActivityVC
    aVC.userObj = PFUser.current()!
    navigationController?.pushViewController(aVC, animated: true)
}
    
    
    
    
// MARK: - EDIT PROFILE BUTTON
@IBAction func editProfileButt(_ sender: AnyObject) {
    let epVC = storyboard?.instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
    epVC.userObj = PFUser.current()!
    navigationController?.pushViewController(epVC, animated: true)
}
    
    
    
   
// MARK: - LOGIN BUTTON
@IBAction func loginButt(_ sender: AnyObject) {
    let loginVC = storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
    present(loginVC, animated: true, completion: nil)
}
    
    
   
// MARK: - LOGOUT BUTTON
@IBAction func logoutButt(_ sender: AnyObject) {
    if PFUser.current() != nil {
    let alert = UIAlertController(title: APP_NAME,
        message: "Are you sure you want to logout?",
        preferredStyle: UIAlertControllerStyle.alert)
    let ok = UIAlertAction(title: "Logout", style: UIAlertActionStyle.default, handler: { (action) -> Void in
        self.showHUD()
        PFUser.logOutInBackground { (error) -> Void in
            if error == nil {
                self.noUserView.isHidden = false
                self.mainView.isHidden = true
            }
            self.hideHUD()
        }
    })
        
    let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in })
        alert.addAction(ok); alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}

    
 
    
    
// MARK: - IAD + ADMOB BANNER METHODS
    func initAdMobBanner() {
        adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
        adMobBannerView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: 320, height: 50)
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        
        banner.frame = CGRect(x: 0, y: self.view.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
        
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        var h: CGFloat = 0
        // iPhone X
        if UIScreen.main.bounds.size.height == 812 { h = 84
        } else { h = 48 }
        
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2,
                              y: view.frame.size.height - banner.frame.size.height - h,
                              width: banner.frame.size.width, height: banner.frame.size.height);
        UIView.commitAnimations()
        banner.isHidden = false
    }
    

    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        print("AdMob loaded!")
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("AdMob Can't load ads right now, they'll be available later \n\(error)")
        hideBanner(adMobBannerView)
    }
    
    
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


