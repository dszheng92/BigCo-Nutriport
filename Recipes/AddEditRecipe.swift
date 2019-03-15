/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse
import GoogleMobileAds
import AudioToolbox

class AddEditRecipe: UIViewController,
UIPickerViewDataSource,
UIPickerViewDelegate,
UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
GADBannerViewDelegate
{

    /* Views */
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var categoriesPickerView: UIPickerView!
    @IBOutlet weak var storyTxt: UITextView!
    @IBOutlet var difficultyButtons: [UIButton]!
    @IBOutlet weak var cookingTxt: UITextField!
    @IBOutlet weak var bakingTxt: UITextField!
    @IBOutlet weak var restingTxt: UITextField!
    @IBOutlet weak var youtubeTxt: UITextField!
    @IBOutlet weak var videoTitleTxt: UITextField!
    @IBOutlet weak var ingredientsTxt: UITextView!
    @IBOutlet weak var preparationTxt: UITextView!
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var submitOutlet: UIButton!
    
    //Ad banners properties
    var adMobBannerView = GADBannerView()
    
    
    
    /* Variables */
    var recipeObj = PFObject(className: RECIPES_CLASS_NAME)
    var likesArray = [PFObject]()
    var selectedCategory = ""
    var difficultyStr = ""
    
    
    
    

override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Check if your Adding or Editing a recipe
    if recipeObj[RECIPES_TITLE] == nil {
        self.title = "ADD RECIPE"
        submitOutlet.setTitle("Submit your Recipe!", for: .normal)
        selectedCategory = ""
        difficultyStr = ""

    } else {
        self.title = "EDIT RECIPE"
        submitOutlet.setTitle("Update your Recipe", for: .normal)
        
        // Initialize a DELETE BarButton Item
        let delButt = UIButton(type: .custom)
        delButt.adjustsImageWhenHighlighted = false
        delButt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        delButt.setBackgroundImage(UIImage(named: "deleteButt"), for: .normal)
        delButt.addTarget(self, action: #selector(deleteRecipe(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: delButt)
        
        showRecipeDetails()
    }
    

    
    
    // Initialize a BACK BarButton Item
    let butt = UIButton(type: UIButtonType.custom)
    butt.adjustsImageWhenHighlighted = false
    butt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    butt.setBackgroundImage(UIImage(named: "backButt"), for: .normal)
    butt.addTarget(self, action: #selector(backButt(_:)), for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: butt)

    
    // Round views corners
    categoriesPickerView.layer.cornerRadius = 10
    for butt in difficultyButtons { butt.layer.cornerRadius = 5 }
    coverImage.layer.cornerRadius = 10
    submitOutlet.layer.cornerRadius = 5

    
    // Set content Size of containerScrollView
    containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 1500)
    
    createKeyboardToolbar()
    
    // Init ad banners
    // initAdMobBanner()
}

    
    
// MARK: - TOOLBAR TO DISMISS THE KEYBOARD
func createKeyboardToolbar() {
    let keyboardToolbar = UIView()
    keyboardToolbar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
    keyboardToolbar.backgroundColor = UIColor.clear
    keyboardToolbar.autoresizingMask = UIViewAutoresizing.flexibleWidth
    titleTxt.inputAccessoryView = keyboardToolbar
    storyTxt.inputAccessoryView = keyboardToolbar
    cookingTxt.inputAccessoryView = keyboardToolbar
    bakingTxt.inputAccessoryView = keyboardToolbar
    restingTxt.inputAccessoryView = keyboardToolbar
    youtubeTxt.inputAccessoryView = keyboardToolbar
    videoTitleTxt.inputAccessoryView = keyboardToolbar
    ingredientsTxt.inputAccessoryView = keyboardToolbar
    preparationTxt.inputAccessoryView = keyboardToolbar

    // Dismiss keyboard button
    let dismissButt = UIButton(type: .custom)
    dismissButt.frame = CGRect(x: keyboardToolbar.frame.size.width-44, y: 0, width: 44, height: 44)
    dismissButt.setBackgroundImage(UIImage(named: "dismissButt"), for: .normal)
    dismissButt.addTarget(self, action: #selector(dismissKeyboard(_:)), for: .touchUpInside)
    keyboardToolbar.addSubview(dismissButt)

}
@objc func dismissKeyboard(_ sender:UIButton) {
    titleTxt.resignFirstResponder()
    storyTxt.resignFirstResponder()
    youtubeTxt.resignFirstResponder()
    videoTitleTxt.resignFirstResponder()
    cookingTxt.resignFirstResponder()
    bakingTxt.resignFirstResponder()
    restingTxt.resignFirstResponder()
    ingredientsTxt.resignFirstResponder()
    preparationTxt.resignFirstResponder()
}
    
    
    
    
    
// MARK: - SHOW RECIPE DETAILS
func showRecipeDetails() {
    titleTxt.text = "\(recipeObj[RECIPES_TITLE]!)"
    storyTxt.text = "\(recipeObj[RECIPES_ABOUT]!)"
    if recipeObj[RECIPES_YOUTUBE] != nil { youtubeTxt.text = "\(recipeObj[RECIPES_YOUTUBE]!)"
    } else { youtubeTxt.text = "" }
    if recipeObj[RECIPES_VIDEO_TITLE] != nil { videoTitleTxt.text = "\(recipeObj[RECIPES_VIDEO_TITLE]!)"
    } else { videoTitleTxt.text = ""  }
    cookingTxt.text = "\(recipeObj[RECIPES_COOKING]!)"
    bakingTxt.text = "\(recipeObj[RECIPES_BAKING]!)"
    restingTxt.text = "\(recipeObj[RECIPES_RESTING]!)"
    ingredientsTxt.text = "\(recipeObj[RECIPES_INGREDIENTS]!)"
    preparationTxt.text = "\(recipeObj[RECIPES_PREPARATION]!)"
    
    // Auto select a row in the PickerView based on Recipe's Category
    selectedCategory = "\(recipeObj[RECIPES_CATEGORY]!)"
    let selectCateg: Int = categoriesArray.index(of: selectedCategory)!
    categoriesPickerView.reloadAllComponents()
    categoriesPickerView.selectRow(selectCateg, inComponent: 0, animated: true)
    
    // Set difficulty button
    difficultyStr = "\(recipeObj[RECIPES_DIFFICULTY]!)"
    for butt in difficultyButtons {
        if butt.titleLabel?.text == difficultyStr {
            butt.setTitleColor(UIColor.white, for: .normal)
            butt.backgroundColor = UIColor.black
        }
    }
    
    // Get image
    let imageFile = recipeObj[RECIPES_COVER] as? PFFile
    imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.coverImage.image = UIImage(data:imageData)
    } } })
}
    

    
    
// MARK: - PICKERVIEW DELEGATES
func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}
func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return categoriesArray.count
}
func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return categoriesArray[row]
}
func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedCategory = "\(categoriesArray[row])"
    print("SEL. CATEGORY BY PICKERVIEW: \(selectedCategory)")
}

// CUSTOMIZE FONT AND COLOR OF PICKERVIEW (*optional*)
func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    var label = view as! UILabel?
    if view == nil { label = UILabel() }
    label?.textAlignment = .center
    let rowText = categoriesArray[row]
    
    let attributedRowText = NSMutableAttributedString(string: rowText)
    let attributedRowTextLength = attributedRowText.length
    attributedRowText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedRowTextLength))
    attributedRowText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Light", size: 20)!, range: NSRange(location: 0 ,length:attributedRowTextLength))
   
    label!.attributedText = attributedRowText
return label!
}


    
// MARK: - DIFFICULTY BUTTONS
@IBAction func difficultyButt(_ sender: AnyObject) {
    let butt = sender as! UIButton
    for butt in difficultyButtons {
        butt.setTitleColor(UIColor.black, for: .normal)
        butt.backgroundColor = yellow
    }
    
    difficultyStr = butt.titleLabel!.text!
    print("SEL. DIFFICULTY: \(difficultyStr)")
    
    butt.setTitleColor(UIColor.white, for: .normal)
    butt.backgroundColor = UIColor.black
}
  
    
    
    
// MARK: - UPLOAD COVER IMAGE BUTTON
@IBAction func uploadPicButt(_ sender: AnyObject) {
    let alert = UIAlertController(title: APP_NAME,
        message: "Select source",
        preferredStyle: .alert)
    
    let camera = UIAlertAction(title: "Take a picture", style: .default, handler: { (action) -> Void in
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    })
    
    let library = UIAlertAction(title: "Pick from Library", style: .default, handler: { (action) -> Void in
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    })
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
    
    alert.addAction(camera);
    alert.addAction(library);
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
}

    
// ImagePicker delegate
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        coverImage.image = scaleImageToMaxWidth(image: pickedImage, newWidth: 700)
    }
    dismiss(animated: true, completion: nil)
}
    
    
    

    

// MARK: - SUBMIT/DELETE YOUR RECIPE
@IBAction func submitButt(_ sender: AnyObject) {
    
    // Check if all required fields have been filled
    if titleTxt.text == "" || selectedCategory == "" || storyTxt.text == "" ||
        difficultyStr == "" || cookingTxt.text == "" || bakingTxt.text == "" ||
        restingTxt.text == "" || ingredientsTxt.text == "" || preparationTxt.text == "" ||
        coverImage.image == nil
    {
   
        self.simpleAlert("You must fill all the required fields!")

        
    } else {
        showHUD()
        
        let currentUser = PFUser.current()
        recipeObj[RECIPES_USER_POINTER] = currentUser
        recipeObj[RECIPES_TITLE] = titleTxt.text
        recipeObj[RECIPES_TITLE_LOWERCASE] = titleTxt.text!.lowercased()
        
        // Save keywords
        let keywords = titleTxt.text!.lowercased().components(separatedBy: " ")
        recipeObj[RECIPES_KEYWORDS] = keywords
        
        recipeObj[RECIPES_CATEGORY] = selectedCategory
        recipeObj[RECIPES_ABOUT] = storyTxt.text
        recipeObj[RECIPES_DIFFICULTY] = difficultyStr
        recipeObj[RECIPES_COOKING] = cookingTxt.text
        recipeObj[RECIPES_BAKING] = bakingTxt.text
        recipeObj[RECIPES_RESTING] = restingTxt.text
        if youtubeTxt.text != "" { recipeObj[RECIPES_YOUTUBE] = youtubeTxt.text
        } else { recipeObj[RECIPES_YOUTUBE] = "" }
        if videoTitleTxt.text != "" { recipeObj[RECIPES_VIDEO_TITLE] = videoTitleTxt.text
        } else { recipeObj[RECIPES_VIDEO_TITLE] = "" }
        recipeObj[RECIPES_INGREDIENTS] = ingredientsTxt.text
        recipeObj[RECIPES_PREPARATION] = preparationTxt.text
        recipeObj[RECIPES_IS_REPORTED] = false
        recipeObj[RECIPES_COMMENTS] = 0
        recipeObj[RECIPES_LIKES] = 0

        // Save Image (if exists)
        if coverImage.image != nil {
            let imageData = UIImageJPEGRepresentation(coverImage.image!, 0.8)
            let imageFile = PFFile(name:"cover.jpg", data:imageData!)
            recipeObj[RECIPES_COVER] = imageFile
        }
        
    
        // Saving block
        recipeObj.saveInBackground { (success, error) -> Void in
            if error == nil {
                self.simpleAlert("You've successfully submitted your recipe!")
                self.hideHUD()
            _ = self.navigationController?.popViewController(animated: true)
        
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
        }}
    
        
    }// end IF
}
    
  
 
// MARK: - DELETE RECIPE BUTTON
@objc func deleteRecipe(_ sender: UIButton) {
    likesArray.removeAll()
    
    // DELETE ALL LIKES
    let query = PFQuery(className: LIKES_CLASS_NAME)
    query.whereKey(LIKES_RECIPE_LIKED, equalTo: recipeObj)
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
        self.recipeObj.deleteInBackground {(success, error) -> Void in
            if error == nil {
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
        }}
        
    }}
   
}
    
    
    
    
// MARK: - BACK BUTTON
@objc func backButt(_ sender:UIButton) {
    _ = navigationController?.popViewController(animated: true)
}
    

// MARK: - TEXT FIELD DELEGATE
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == titleTxt { titleTxt.resignFirstResponder() }
    if textField == cookingTxt { bakingTxt.becomeFirstResponder() }
    if textField == bakingTxt { restingTxt.becomeFirstResponder() }
    if textField == restingTxt { youtubeTxt.becomeFirstResponder() }
    if textField == youtubeTxt { videoTitleTxt.becomeFirstResponder() }
    if textField == videoTitleTxt { videoTitleTxt.resignFirstResponder() }
    
return true
}


    
    
    
    
    
    
    
// MARK: - ADMOB BANNER METHODS
func initAdMobBanner() {
    adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
    adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 320, height: 50)
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
