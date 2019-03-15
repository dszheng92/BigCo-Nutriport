/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse
import ParseFacebookUtilsV4


class Login: UIViewController,
UITextFieldDelegate
{
    
    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    
    
   
    
    
override func viewWillAppear(_ animated: Bool) {
    if PFUser.current() != nil {  dismiss(animated: false, completion: nil) }
}
override func viewDidLoad() {
        super.viewDidLoad()
    
    
    // Setup layouts
    containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 550)
    
}
    
    
   
// MARK: - LOGIN BUTTON
@IBAction func loginButt(_ sender: AnyObject) {
    dismissKeyboard()
    showHUD()
        
    PFUser.logInWithUsername(inBackground: usernameTxt.text!, password:passwordTxt.text!) { (user, error) -> Void in
        // Login successfull
        if user != nil {
            self.dismiss(animated: true, completion: nil)
            self.hideHUD()
                
        // Login failed
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}

    
    
    
    
// MARK: - FACEBOOK LOGIN BUTTON
@IBAction func facebookButt(_ sender: Any) {
    // Set permissions required from the Facebook user account
    let permissions = ["public_profile", "email"];
    showHUD()
    
    // Login PFUser using Facebook
    PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
        if user == nil {
            self.simpleAlert("Facebook login cancelled")
            self.hideHUD()
            
        } else if (user!.isNew) {
            print("NEW USER signed up and logged in through Facebook!");
            self.getFBUserData()
            
        } else {
            print("RETURNING User logged in through Facebook!");
            
            self.dismiss(animated: true, completion: nil)
            self.hideHUD()
    }}
}
    
    
func getFBUserData() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, picture.type(large)"])
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest) { (connection, result, error) in
            if error == nil {
                let userData:[String:AnyObject] = result as! [String : AnyObject]
                
                // Get data
                let facebookID = userData["id"] as! String
                let name = userData["name"] as! String
                var email = ""
                if userData["email"] != nil { email = userData["email"] as! String
                } else { email = "noemail@facebook.com" }


                // Get avatar
                let currUser = PFUser.current()!
                
                let pictureURL = URL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large")
                let urlRequest = URLRequest(url: pictureURL!)
                let session = URLSession.shared
                let dataTask = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                    if error == nil && data != nil {
                        let image = UIImage(data: data!)
                        let imageData = UIImageJPEGRepresentation(image!, 0.8)
                        let imageFile = PFFile(name:"avatar.jpg", data:imageData!)
                        currUser[USER_AVATAR] = imageFile
                        currUser.saveInBackground(block: { (succ, error) in
                            print("...AVATAR SAVED!")
                            self.hideHUD()
                            self.dismiss(animated: true, completion: nil)
                        })
                    } else {
                        self.simpleAlert("\(error!.localizedDescription)")
                        self.hideHUD()
                }})
                dataTask.resume()
                
                
                // Update user data
                let nameArr = name.components(separatedBy: " ")
                var username = String()
                for word in nameArr {
                    username.append(word.lowercased())
                }
                currUser.username = username
                currUser.email = email
                currUser[USER_FULLNAME] = name
                currUser[USER_IS_REPORTED] = false
                currUser.saveInBackground(block: { (succ, error) in
                    if error == nil {
                        print("USER'S DATA UPDATED...")
                }})
            
                
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
    }}
    connection.start()
}

    
    
    
    
    
    
    
    
// MARK: - SIGNUP BUTTON
@IBAction func signupButt(_ sender: AnyObject) {
    let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUp
    present(signupVC, animated: true, completion: nil)
}
    
    
    
// MARK: - TEXTFIELD DELEGATES
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTxt  {  passwordTxt.becomeFirstResponder() }
    if textField == passwordTxt  {  passwordTxt.resignFirstResponder() }
return true
}
    
    
// MARK: - TAP TO DISMISS KEYBOARD
@IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
    dismissKeyboard()
}
func dismissKeyboard() {
    usernameTxt.resignFirstResponder()
    passwordTxt.resignFirstResponder()
}

    
    
    
// MARK: - CLOSE BUTTON
@IBAction func closeButt(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
}
    
    
    
    
// MARK: - FORGOT PASSWORD BUTTON
@IBAction func forgotPasswButt(_ sender: AnyObject) {
    let alert = UIAlertController(title: APP_NAME,
        message: "Type your email address you used to register.",
        preferredStyle: .alert)
    
    let ok = UIAlertAction(title: "Reset Password", style: .default, handler: { (action) -> Void in
        let textField = alert.textFields!.first!
        let txtStr = textField.text!
        
        PFUser.requestPasswordResetForEmail(inBackground: txtStr, block: { (succ, error) in
            self.simpleAlert("You will receive an email shortly with a link to reset your password")
        })
    })
    
    // Cancel button
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
    
    // Add textField
    alert.addTextField(configurationHandler: { (textField: UITextField) in
        textField.keyboardAppearance = .dark
        textField.keyboardType = .emailAddress
    })
    
    alert.addAction(ok)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
}
    


    

    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
