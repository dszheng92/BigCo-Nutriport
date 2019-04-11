/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse

import GoogleMobileAds
import AudioToolbox

// GLOBAL VARIABLES (DO NOT EDIT THEM)
var categoryStr = String()
var shoppingArray:[String] = []



class Recipes: UIViewController,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UISearchBarDelegate,
GADBannerViewDelegate
{

    /* Views */
    @IBOutlet weak var recipesCollView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nothingFoundLabel: UILabel!
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    
    //Ad banners properties
    var adMobBannerView = GADBannerView()
    
    

    /* Variables */
    var recipesArray = [PFObject]()
    var likesArray = [PFObject]()
    var cellSize = CGSize()
    
    
    
    
override func viewDidAppear(_ animated: Bool) {
    
    UIApplication.shared.applicationIconBadgeNumber = 0
    
    if categoryStr != "" {
        searchBar.text = ""
        queryRecipes(categoryStr)
    }
    print("CATEGORY: \(categoryStr)")
    
    // Associate the device with a user for Push Notifications
    if PFUser.current() != nil {
        let installation = PFInstallation.current()
        installation?["username"] = PFUser.current()!.username
        installation?["userID"] = PFUser.current()!.objectId!
        installation?.saveInBackground(block: { (succ, error) in
            if error == nil {
                print("PUSH REGISTERED FOR: \(PFUser.current()!.username!)")
        }})
    }
}
    
override func viewDidLoad() {
        super.viewDidLoad()

    // Reset search text
    searchBar.frame.origin.y = -60
    searchBar.text = ""
    
    
    // Load Shopping Array
    let tempArr: AnyObject? = defaults.object(forKey: "tempArr") as AnyObject?
    if tempArr != nil {
        shoppingArray = tempArr as! [String]
    }
    print("SHOPPING LIST in Recipes screen: \(shoppingArray)")
    
    
    // Set cell size based on current device
    if UIDevice.current.userInterfaceIdiom == .phone {
        // iPhone
        cellSize = CGSize(width: view.frame.size.width - 20, height: 160)
    } else  {
        // iPad
        cellSize = CGSize(width: view.frame.size.width - 20, height: 160)
    }
    
    // Init ad banners
    // initAdMobBanner()
    
    
    // Call query for ALL recipes
    queryRecipes("")
}

    
    
// MARK: - QUERY RECIPES
func queryRecipes(_ searchText:String) {
    showHUD()
    
    let query = PFQuery(className: RECIPES_CLASS_NAME)
    
    // Search by kkeywords
    if searchBar.text != "" {
        let keywords = searchBar.text!.lowercased().components(separatedBy: " ")
        query.whereKey(RECIPES_KEYWORDS, containedIn: keywords)
    }
    
    // Search by Category
    if categoryStr != "" { query.whereKey(RECIPES_CATEGORY, contains: searchText) }
    
    print("SEARCH TEXT: \(searchText)\nCATEGORY: \(categoryStr)")
    
    query.whereKey(RECIPES_IS_REPORTED, equalTo: false)
    query.order(byDescending: "createdAt")
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            self.recipesArray = objects!
            while (self.recipesArray.count > 4) {
                self.recipesArray.removeLast()
            }
            
            self.recipesArray[0][RECIPES_TITLE] = "Stuffed Cucumber"
            self.recipesArray[0]["pictrue"] = "cucumber.jpg"
            self.recipesArray[0][RECIPES_CATEGORY] = "Snack"
            
            self.recipesArray[1][RECIPES_TITLE] = "Black Bean Breakfast Burrito "
            self.recipesArray[1]["pictrue"] = "burrito.jpg"
            self.recipesArray[1][RECIPES_CATEGORY] = "Breakfast"

            
            self.recipesArray[2][RECIPES_TITLE] = "Vegan Buddha Bowl"
            self.recipesArray[2]["pictrue"] = "Veggie.jpg"
            self.recipesArray[2][RECIPES_CATEGORY] = "Lunch"

                
            self.recipesArray[3][RECIPES_TITLE] = "Baked Salmon with Chimichurri Sauce"
            self.recipesArray[3]["pictrue"] = "salmon.jpg"
            self.recipesArray[3][RECIPES_CATEGORY] = "Dinner"
            
            
            // Reload CollView
            self.recipesCollView.reloadData()
            self.hideHUD()
                        
            // Hide/show the nothing found Label
            if self.recipesArray.count == 0 { self.nothingFoundLabel.isHidden = false
            } else { self.nothingFoundLabel.isHidden = true }
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
 


    
    
// MARK: - COLLECTION VIEW DELEGATES
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recipesArray.count
}
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCell", for: indexPath) as! RecipesCell
    
    var recipesClass = PFObject(className: RECIPES_CLASS_NAME)
    recipesClass = recipesArray[indexPath.row]
    
    // Get userPointer
    let userPointer = recipesClass[RECIPES_USER_POINTER] as! PFUser
    userPointer.fetchIfNeededInBackground { (object, error) in
        
        // Get Title & Category
        cell.titleLabel.text = "\(recipesClass[RECIPES_TITLE]!)"
        cell.categoryLabel.text = "\(recipesClass[RECIPES_CATEGORY]!)"
    
        // Get Likes
        if recipesClass[RECIPES_LIKES] != nil {
            let likes = recipesClass[RECIPES_LIKES] as! Int
            cell.likesLabel.text = likes.abbreviated
        } else { cell.likesLabel.text = "0" }
    
        // Get Comments
        if recipesClass[RECIPES_COMMENTS] != nil {
            let comments = recipesClass[RECIPES_COMMENTS] as! Int
            cell.commentsLabel.text = comments.abbreviated
        } else { cell.commentsLabel.text = "0" }
        
       // let meals = UICollectionView(frame:self.bounds)
        cell.coverImage.image = UIImage(named: recipesClass["pictrue"] as! String)
        
        // Assign a tag to buttons
        cell.likeOutlet.tag = indexPath.row
 //       cell.avatarOutlet.tag = indexPath.row
    
    
        // Customize cell's layout
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell.layer.shadowOpacity = 1
    }
    
    
return cell
}
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return cellSize
}
    
// MARK: - TAP A CELL -> SHOW RECIPE
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    categoryStr = ""
    var recipesClass = PFObject(className: RECIPES_CLASS_NAME)
    recipesClass = recipesArray[indexPath.row]
    
    let rdVC = storyboard?.instantiateViewController(withIdentifier: "RecipeDetails") as! RecipeDetails
    rdVC.recipeObj = recipesClass
    navigationController?.pushViewController(rdVC, animated: true)
    
}
    

    
    
// MARK: - USER AVATAR BUTTON -> SHOW ITS PROFILE
@IBAction func avatarButt(_ sender: AnyObject) {
    let butt = sender as! UIButton
    
    var recipesClass = PFObject(className: RECIPES_CLASS_NAME)
    recipesClass = recipesArray[butt.tag]
    
    // Get User Pointer
    let userPointer = recipesClass[RECIPES_USER_POINTER] as! PFUser
    userPointer.fetchIfNeededInBackground { (user, error) in
        if userPointer[USER_IS_REPORTED] as! Bool == false {
            let oupVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfile") as! OtherUserProfile
            oupVC.otherUserObj = userPointer
            self.navigationController?.pushViewController(oupVC, animated: true)
        } else {
            self.simpleAlert("This User has been reported!")
        }
    }
}
    
    
    
   
// MARK: - LIKE BUTTON
@IBAction func likeButt(_ sender: AnyObject) {
    // USER IS LOGGED IN
    if PFUser.current() != nil {
        
        let butt = sender as! UIButton
        let indexP = IndexPath(row: butt.tag, section: 0)
        let cell = recipesCollView.cellForItem(at: indexP) as! RecipesCell
        var recipesClass = PFObject(className: RECIPES_CLASS_NAME)
        recipesClass = recipesArray[butt.tag] 
        
        
        // Query Likes
        likesArray.removeAll()
        let query = PFQuery(className: LIKES_CLASS_NAME)
        query.whereKey(LIKES_LIKED_BY, equalTo: PFUser.current()!)
        query.whereKey(LIKES_RECIPE_LIKED, equalTo: recipesClass)
        query.findObjectsInBackground { (objects, error)-> Void in
            if error == nil {
                self.likesArray = objects!
                print("LIKES ARRAY: \(self.likesArray)")
                
                var likesClass = PFObject(className: LIKES_CLASS_NAME)
                
                if self.likesArray.count == 0 {
                    
                    
                // LIKE RECIPE
                recipesClass.incrementKey(RECIPES_LIKES, byAmount: 1)
                recipesClass.saveInBackground()
                let likeInt = recipesClass[RECIPES_LIKES] as! Int
                cell.likesLabel.text = likeInt.abbreviated
                    
                likesClass[LIKES_LIKED_BY] = PFUser.current()
                likesClass[LIKES_RECIPE_LIKED] = recipesClass
                likesClass.saveInBackground(block: { (success, error) -> Void in
                    if error == nil {
                        self.simpleAlert("You've liked this recipe and saved into your Account!")
                        
                        
                        // Get User Pointer
                        let userPointer = recipesClass[RECIPES_USER_POINTER] as! PFUser
                        userPointer.fetchIfNeededInBackground(block: { (user, error) in
                            
                            // Send Push Notification
                            let pushStr = "\(PFUser.current()![USER_FULLNAME]!) liked your \(recipesClass[RECIPES_TITLE]!) recipe!"
                            
                            let data = [ "badge" : "Increment",
                                         "alert" : pushStr,
                                         "sound" : "bingbong.aiff"
                            ]
                            let request = [
                                "someKey" : userPointer.objectId!,
                                "data" : data
                                ] as [String : Any]
                            PFCloud.callFunction(inBackground: "push", withParameters: request as [String : Any], block: { (results, error) in
                                if error == nil {
                                    print ("\nPUSH SENT TO: \(userPointer[USER_USERNAME]!)\nMESSAGE: \(pushStr)\n")
                                } else {
                                    print ("\(error!.localizedDescription)")
                            }})
                            
                            
                            
                            // Save activity
                            let activityClass = PFObject(className: ACTIVITY_CLASS_NAME)
                            activityClass[ACTIVITY_CURRENT_USER] = userPointer
                            activityClass[ACTIVITY_OTHER_USER] = PFUser.current()!
                            activityClass[ACTIVITY_TEXT] = "\(PFUser.current()![USER_FULLNAME]!) liked your \(recipesClass[RECIPES_TITLE]!) recipe"
                            activityClass.saveInBackground()
                        })
                        
                }})
                    
                
                    
                // UNLIKE RECIPE
                } else if self.likesArray.count > 0 {
                    recipesClass.incrementKey(RECIPES_LIKES, byAmount: -1)
                    recipesClass.saveInBackground()
                    let likeInt = recipesClass[RECIPES_LIKES] as! Int
                    cell.likesLabel.text = likeInt.abbreviated
                    
                    likesClass = self.likesArray[0] 
                    likesClass.deleteInBackground {(success, error) -> Void in
                        if error == nil {
                            self.simpleAlert("You've unliked this recipe")
                    }}
                }
            
            
                
            // Error in query Likes
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
        }}
        
        
        
        
    // USER IS NOT LOGGED IN/REGISTERED
    } else {
        let alert = UIAlertController(title: APP_NAME,
            message: "You must login/sign up to like a recipe!",
            preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
            self.present(loginVC, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in })
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}
    
    

    
    
    
    
// MARK: - SEARCH BUTTON
@IBAction func searchButt(_ sender: AnyObject) {
    showSearchBar()
}
    
    
// MARK: - SHOW/HIDE SEARCH BAR
func showSearchBar() {
    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        if UIScreen.main.bounds.size.height == 812 {
            // iPhone X
            self.searchBar.frame.origin.y = 84
        } else { self.searchBar.frame.origin.y = 64 }
        
    }, completion: { (finished: Bool) in
        self.searchBar.becomeFirstResponder()
    })
}
    
func hideSearchBar() {
    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.searchBar.frame.origin.y = -60
    }, completion: { (finished: Bool) in
        self.searchBar.resignFirstResponder()
    })
}
    
 
// MARK: - SEARCH BAR DELEGATES
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    categoryStr = ""
    queryRecipes(searchBar.text!)
    hideSearchBar()
}
func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    hideSearchBar()
}
    
 
    
    
// MARK: - FILTER BY CATEGORIES
@IBAction func filterByCategoriesButt(_ sender: AnyObject) {
    searchBar.text = ""
    let catVC = storyboard?.instantiateViewController(withIdentifier: "Categories") as! Categories
    present(catVC, animated: true, completion: nil)
}
    
    
// MARK: - REFRESH BUTTON
@IBAction func refreshButt(_ sender: AnyObject) {
    searchBar.text = ""
    categoryStr = ""
    queryRecipes("")
}
    

  
    
   
// MARK: - IAD + ADMOB BANNER METHODS
func initAdMobBanner() {
        adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
        adMobBannerView.frame = bannerView.frame
            //CGRect(x: 0, y: self.view.frame.size.height, width: 320, height: 50)
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
        banner.frame = bannerView.frame
//            CGRect(x: 0, y: self.view.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        bannerHeightConstraint.constant = 0
        UIView.commitAnimations()
        banner.isHidden = true
        
        view.layoutIfNeeded()
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
