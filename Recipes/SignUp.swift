/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse


class SignUp: UIViewController,
UITextFieldDelegate
{
    
    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var fullnameTxt: UITextField!
    
    

    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    
    // Setup layout views
    containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 300)
}
    
    
    
// MARK: - TAP TO DISMISS KEYBOARD
@IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
   dismissKeyboard()
}
func dismissKeyboard() {
    usernameTxt.resignFirstResponder()
    passwordTxt.resignFirstResponder()
    fullnameTxt.resignFirstResponder()
}
    
// MARK: - SIGNUP BUTTON
@IBAction func signupButt(_ sender: AnyObject) {
    dismissKeyboard()
    showHUD()

    let userForSignUp = PFUser()
    userForSignUp.username = usernameTxt.text!.lowercased()
    userForSignUp.password = passwordTxt.text
    userForSignUp.email = usernameTxt.text
    userForSignUp[USER_FULLNAME] = fullnameTxt.text
    userForSignUp[USER_IS_REPORTED] = false
    
    // Save default avatar
    let imageData = UIImageJPEGRepresentation(UIImage(named:"logo")!, 1.0)
    let imageFile = PFFile(name:"image.jpg", data:imageData!)
    userForSignUp[USER_AVATAR] = imageFile
    
    if usernameTxt.text == "" || passwordTxt.text == "" || fullnameTxt.text == "" {
        simpleAlert("You must fill all fields to sign up on \(APP_NAME)")
        hideHUD()
        
    } else {
        userForSignUp.signUpInBackground { (succeeded, error) -> Void in
            if error == nil {
                self.dismiss(animated: false, completion: nil)
                self.hideHUD()
        
            // ERROR ON SIGN UP
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
        }}
    }
    
}
    
    
    
// MARK: -  TEXTFIELD DELEGATE
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTxt {  passwordTxt.becomeFirstResponder()  }
    if textField == passwordTxt {  fullnameTxt.becomeFirstResponder()     }
    if textField == fullnameTxt {  fullnameTxt.resignFirstResponder()     }
return true
}
    
    
    
// MARK: - BACK BUTTON
@IBAction func backButt(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
}
    
    

// MARK: - TERMS OF USE BUTTON
@IBAction func touButt(_ sender: AnyObject) {
    let touVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUse") as! TermsOfUse
    present(touVC, animated: true, completion: nil)
}
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
