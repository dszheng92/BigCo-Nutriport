/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse


class ActivityVC: UIViewController,
UITableViewDataSource,
UITableViewDelegate
{

    /* Views */
    @IBOutlet weak var activityTableView: UITableView!
    

    
    /* Variables */
    var activityArray = [PFObject]()
    var userObj = PFUser()
    
    
    
    
override func viewWillAppear(_ animated: Bool) {
    queryActivity()
}
override func viewDidLoad() {
        super.viewDidLoad()

    
    self.title = "ACTIVITY"
    
    
    // Initialize a BACK BarButton Item
    let backButt = UIButton(type: .custom)
    backButt.adjustsImageWhenHighlighted = false
    backButt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    backButt.setBackgroundImage(UIImage(named: "backButt"), for: .normal)
    backButt.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButt)
    
}

@objc func backButton(_ sender:UIButton) {
    _ = navigationController?.popViewController(animated: true)
}


    
// MARK: - QUERY ACTIVITY
func queryActivity() {
    showHUD()
    
    let query = PFQuery(className: ACTIVITY_CLASS_NAME)
    query.whereKey(ACTIVITY_CURRENT_USER, equalTo: PFUser.current()!)
    query.order(byDescending: "createdAt")
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            self.activityArray = objects!
            
            // Reload TableView
            self.activityTableView.reloadData()
            self.hideHUD()
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
    
    

// MARK: - TABLEVIEW DELEGATES
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return activityArray.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        
    var activityClass = PFObject(className: ACTIVITY_CLASS_NAME)
    activityClass = activityArray[indexPath.row] 
    
    // Get User Pointer
    let userPointer = activityClass[ACTIVITY_OTHER_USER] as! PFUser
    userPointer.fetchIfNeededInBackground { (user, error) in
        if error == nil {
            // Get text
            cell.txtLabel.text = "\(activityClass[ACTIVITY_TEXT]!)"
    
            // Get Date
            let date = activityClass.createdAt
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MMM dd yyyy"
            cell.dateLabel.text = dateFormat.string(from: date!)
    
    
            // Get image
            cell.avatarImage.image = UIImage(named: "logo")
            let imageFile = userPointer[USER_AVATAR] as? PFFile
            imageFile?.getDataInBackground { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.avatarImage.image = UIImage(data:imageData)
            }}}
            cell.avatarImage.layer.cornerRadius = cell.avatarImage.bounds.size.width/2
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
        }
    }
    
return cell
}
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 52
}
    
    
// MARK: -  CELL TAPPED -> SHOW USER'S PROFILE
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var activityClass = PFObject(className: ACTIVITY_CLASS_NAME)
    activityClass = activityArray[indexPath.row] 
    
    // Get User Pointer
    let userPointer = activityClass[ACTIVITY_OTHER_USER] as! PFUser
    userPointer.fetchIfNeededInBackground { (user, error) in
        if error == nil {
            
            if userPointer[USER_IS_REPORTED] as! Bool == false {
                let oupVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfile") as! OtherUserProfile
                oupVC.otherUserObj = userPointer
                self.navigationController?.pushViewController(oupVC, animated: true)
            } else {
                self.simpleAlert("This User has been reported!")
            }
            
        // error
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
    }}
}


    
    
    

override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}




// MARK: - ACTIVITY CELL
class ActivityCell: UITableViewCell {
    
    /* Views */
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
}


