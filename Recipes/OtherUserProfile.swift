/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/


import UIKit
import Parse

class OtherUserProfile: UIViewController,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
{

    
    /* Views */
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var aboutUserLabel: UITextView!
    @IBOutlet weak var userRecipesLabel: UILabel!
    
    @IBOutlet weak var userRecipesCollView: UICollectionView!
    
    
    
    /* Variables */
    var otherUserObj = PFUser()
    var otherUserRecipesArray = [PFObject]()
    var likesArray = [PFObject]()
    var cellSize = CGSize()
    
    
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    self.edgesForExtendedLayout = UIRectEdge()
    
    
    // Initialize a BACK BarButton Item
    let butt = UIButton(type: UIButtonType.custom)
    butt.adjustsImageWhenHighlighted = false
    butt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    butt.setBackgroundImage(UIImage(named: "backButt"), for: .normal)
    butt.addTarget(self, action: #selector(backButt(_:)), for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: butt)

    // Initialize a REPORT USER  BarButton Item
    let reportButt = UIButton(type: UIButtonType.custom)
    reportButt.adjustsImageWhenHighlighted = false
    reportButt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    reportButt.setBackgroundImage(UIImage(named: "reportButt"), for: .normal)
    reportButt.addTarget(self, action: #selector(reportButton(_:)), for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reportButt)

    
    
    // Round views corners
    avatarImage.layer.cornerRadius = avatarImage.bounds.size.width/2
    avatarImage.layer.borderColor = UIColor.white.cgColor
    avatarImage.layer.borderWidth = 2

    // Set cell size based on current device
    if UIDevice.current.userInterfaceIdiom == .phone {
        // iPhone
        cellSize = CGSize(width: view.frame.size.width/2 - 20, height: 280)
    } else  {
        // iPad
        cellSize = CGSize(width: view.frame.size.width/3 - 20, height: 280)
    }

    
    // Call query
    showUserDetails()
}

    
    
// MARK: - SHOW OTHER USER DETAILS
func showUserDetails() {
    self.title = "\(otherUserObj[USER_FULLNAME]!)"
    
    // Get avatar image
    avatarImage.image = UIImage(named: "logo")
    let imageFile = otherUserObj[USER_AVATAR] as? PFFile
    imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.avatarImage.image = UIImage(data:imageData)
    }}})
        
    if otherUserObj[USER_JOB] != nil { fullnameLabel.text = "\(otherUserObj[USER_FULLNAME]!), \(otherUserObj[USER_JOB]!)"
    } else { fullnameLabel.text = "\(otherUserObj[USER_FULLNAME]!)" }
    
    if otherUserObj[USER_ABOUTME] != nil { aboutUserLabel.text = "\(otherUserObj[USER_ABOUTME]!)"
    } else { aboutUserLabel.text = "N/D" }
    
    userRecipesLabel.text = "\(otherUserObj[USER_FULLNAME]!) recipes"
    
    // call query
    queryUserRecipes()
}
    
// MARK: - QUERY OTHER USER'S RECIPES
func queryUserRecipes() {
    let query = PFQuery(className: RECIPES_CLASS_NAME)
    query.whereKey(RECIPES_USER_POINTER, equalTo: otherUserObj)
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            self.otherUserRecipesArray = objects!
            // Reload CollView
            self.userRecipesCollView.reloadData()
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
    }}
}
    
    
// MARK: - COLLECTION VIEW DELEGATES
func numberOfSections(in collectionView: UICollectionView) -> Int {
   return 1
}
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return otherUserRecipesArray.count
}
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCell", for: indexPath) as! RecipesCell
        
        var recipeObj = PFObject(className: RECIPES_CLASS_NAME)
        recipeObj = otherUserRecipesArray[indexPath.row]
    
        // Get Title & Category
        cell.titleLabel.text = "\(recipeObj[RECIPES_TITLE]!)"
        cell.categoryLabel.text = "\(recipeObj[RECIPES_CATEGORY]!)"
    
    
        // Get Likes
        if recipeObj[RECIPES_LIKES] != nil {
            let likes = recipeObj[RECIPES_LIKES] as! Int
            cell.likesLabel.text = likes.abbreviated
        } else { cell.likesLabel.text = "0" }
    
    
        // Get Comments
        if recipeObj[RECIPES_COMMENTS] != nil {
            let comments = recipeObj[RECIPES_COMMENTS] as! Int
            cell.commentsLabel.text = comments.abbreviated
        } else { cell.commentsLabel.text = "0" }
    
    
        // Get Cover image
        let imageFile = recipeObj[RECIPES_COVER] as? PFFile
        imageFile?.getDataInBackground(block: { (data, error) -> Void in
            if error == nil {
                if let imageData = data {
                    cell.coverImage.image = UIImage(data: imageData)
        } } })
        
        
//        // Get User's Avatar image
//        cell.avatarOutlet.setBackgroundImage(UIImage(named: "logo"), for: .normal)
//        let avatarImage = otherUserObj[USER_AVATAR] as? PFFile
//        avatarImage?.getDataInBackground(block: { (data, error) -> Void in
//            if error == nil {
//                if let imageData = data {
//                    cell.avatarOutlet.setBackgroundImage(UIImage(data: imageData), for: .normal)
//        }}})
//        cell.avatarOutlet.layer.cornerRadius = cell.avatarOutlet.bounds.size.width/2
//
//
//        cell.fullNameLabel.text = "\(otherUserObj[USER_FULLNAME]!)"
//
        cell.likeOutlet.tag = indexPath.row
        
        // Customize cell's layout
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell.layer.shadowOpacity = 1
        
return cell
}
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return cellSize
}
    
// MARK: - TAP A CELL -> SHOW RECIPE
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var recipeObj = PFObject(className: RECIPES_CLASS_NAME)
    recipeObj = otherUserRecipesArray[indexPath.row] 
    
    let rdVC = storyboard?.instantiateViewController(withIdentifier: "RecipeDetails") as! RecipeDetails
    rdVC.recipeObj = recipeObj
    navigationController?.pushViewController(rdVC, animated: true)
}

    
    
   
// MARK: - LIKE BUTTON
@IBAction func likeButt(_ sender: AnyObject) {
        // USER IS LOGGED IN
        if PFUser.current() != nil {
            
            let butt = sender as! UIButton
            let indexP = IndexPath(row: butt.tag, section: 0)
            let cell = userRecipesCollView.cellForItem(at: indexP) as! RecipesCell
            var recipeObj = PFObject(className: RECIPES_CLASS_NAME)
            recipeObj = otherUserRecipesArray[butt.tag]
            
            // Query Likes
            likesArray.removeAll()
            let query = PFQuery(className: LIKES_CLASS_NAME)
            query.whereKey(LIKES_LIKED_BY, equalTo: PFUser.current()!)
            query.whereKey(LIKES_RECIPE_LIKED, equalTo: recipeObj)
            query.findObjectsInBackground { (objects, error)-> Void in
                if error == nil {
                    self.likesArray = objects!
                    print("LIKES ARRAY: \(self.likesArray)")
                    
                    // Get Parse object
                    var likesClass = PFObject(className: LIKES_CLASS_NAME)
                    
                    if self.likesArray.count == 0 {
                        
                        // LIKE RECIPE
                        recipeObj.incrementKey(RECIPES_LIKES, byAmount: 1)
                        recipeObj.saveInBackground()
                        let likeInt = recipeObj[RECIPES_LIKES] as! Int
                        cell.likesLabel.text = likeInt.abbreviated
                        
                        likesClass[LIKES_LIKED_BY] = PFUser.current()
                        likesClass[LIKES_RECIPE_LIKED] = recipeObj
                        likesClass.saveInBackground(block: { (success, error) -> Void in
                            if error == nil {
                                self.simpleAlert("You've liked this recipe and saved into your Account!")
                    
                            
                                // Get User Pointer
                                let userPointer = recipeObj[RECIPES_USER_POINTER] as! PFUser
                                userPointer.fetchIfNeededInBackground(block: { (user, error) in
                            
                                    // Send Push Notification
                                    let pushStr = "\(PFUser.current()![USER_FULLNAME]!) liked your \(recipeObj[RECIPES_TITLE]!) recipe!"
                            
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
                                    activityClass[ACTIVITY_TEXT] = "\(PFUser.current()![USER_FULLNAME]!) liked your \(recipeObj[RECIPES_TITLE]!) recipe"
                                    activityClass.saveInBackground()
                                    
                                })// end userPointer
                            
                    }})
                        
                        
                    // UNLIKE RECIPE
                    } else if self.likesArray.count > 0 {
                        recipeObj.incrementKey(RECIPES_LIKES, byAmount: -1)
                        recipeObj.saveInBackground()
                        let likeInt = recipeObj[RECIPES_LIKES] as! Int
                        cell.likesLabel.text = likeInt.abbreviated
                        
                        likesClass = self.likesArray[0] 
                        likesClass.deleteInBackground {(success, error) -> Void in
                            if error == nil {
                                self.simpleAlert("You've unliked this recipe")
                        }}
                    }
                    
                    
                    
                // Error in query Likes
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }}
            
            
            
            
            
        // USER IS NOT LOGGED IN/REGISTERED
        } else {
            let alert = UIAlertController(title: APP_NAME,
                message: "You must login/sign up to like a recipe!",
                preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                self.present(loginVC, animated: true, completion: nil)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            })
            alert.addAction(ok); alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        
}
    
    
    

    
// MARK: - REPORT USER BUTTON
@objc func reportButton(_ sender:UIButton) {

    let alert = UIAlertController(title: APP_NAME,
        message: "Tell us briefly why you're reporting this User",
        preferredStyle: .alert)
    
    // REPORT button
    let report = UIAlertAction(title: "Report", style: .default, handler: { (action) -> Void in
        // TextField
        let textField = alert.textFields!.first!
        let txtStr = textField.text!
        
        
        let request = [
            "userId" : self.otherUserObj.objectId!,
            "reportMessage" : txtStr
            ] as [String : Any]
        
        PFCloud.callFunction(inBackground: "reportUser", withParameters: request as [String : Any], block: { (results, error) in
            if error == nil {

                
                // Automatically report all recipes by this User
                let query = PFQuery(className: RECIPES_CLASS_NAME)
                query.whereKey(RECIPES_USER_POINTER, equalTo: self.otherUserObj)
                query.findObjectsInBackground(block: { (objects, error) in
                    if error == nil {
                        
                        for i in 0..<objects!.count {
                            var rObj = PFObject(className: RECIPES_CLASS_NAME)
                            rObj = objects![i]
                            rObj[RECIPES_IS_REPORTED] = true
                            rObj.saveInBackground()
                        }
                }})
                
                
                self.simpleAlert("Thanks for reporting this User, we'll check it out withint 24 hours!")
                self.hideHUD()
                _ = self.navigationController?.popViewController(animated: true)
                
            // error in Cloud Code
            } else {
                print ("\(error!.localizedDescription)")
                self.hideHUD()
        }})
        
    })
    
    
    // Cancel button
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
    
    // Add textField
    alert.addTextField { (textField: UITextField) in
        textField.keyboardAppearance = .dark
        textField.keyboardType = .default
    }
    
    alert.addAction(report)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
    

}
    



    
    
    
// MARK: - BACK BUTTON
@objc func backButt(_ sender:UIButton) {
    _ = navigationController?.popViewController(animated: true)
}

    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
