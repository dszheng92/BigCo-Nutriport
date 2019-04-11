/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit


class Shopping: UIViewController,
UITableViewDelegate,
UITableViewDataSource
{

    /* Views */
    @IBOutlet weak var shoppingTableView: UITableView!
    @IBOutlet weak var shoppingEmptyLabel: UILabel!
    
    
    
    /* Variables */
    var selectedCell = Bool()
    
    
    
    
override func viewDidAppear(_ animated: Bool) {

    UIApplication.shared.applicationIconBadgeNumber = 0

    // Reload data for shopping list
    shoppingTableView.reloadData()
    print("SHOPPING ARRAY in Shopping: \(shoppingArray)")
    
    // Hide/Show shopping TableView
    if shoppingArray.count == 0 { shoppingTableView.isHidden = true
    } else { shoppingTableView.isHidden = false }
}
    
override func viewDidLoad() {
        super.viewDidLoad()
    
}

 
// MARK: - TABLEVIEW DELEGATES
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shoppingArray.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCell", for: indexPath) as! ShoppingCell
        
    cell.itemLabel.text = "\(shoppingArray[indexPath.row])"
    //cell.itemLabel.text = "Under Construction"
    
return cell
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
}
    
    
// MARK: -  SELECT/DESELECT INGREDIENT WITH STRIKETHROUGH LINE
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! ShoppingCell
    cell.selectedCell = !cell.selectedCell
    
    if cell.selectedCell {
        let strikeThrough = [NSAttributedStringKey.strikethroughStyle: 1]
        cell.itemLabel.attributedText = NSAttributedString(string: "\(shoppingArray[indexPath.row])", attributes: strikeThrough)
    } else {
        cell.itemLabel.attributedText = NSAttributedString(string: "\(shoppingArray[indexPath.row])", attributes: nil)
    }
}

    
    
    
    
// MARK: - CLEAR LIST BUTTON
@IBAction func clearButt(_ sender: AnyObject) {
    let alert = UIAlertController(title: APP_NAME,
        message: "Are you sure you want to clear your Shopping List?",
        preferredStyle: UIAlertControllerStyle.alert)
    let ok = UIAlertAction(title: "Clear List", style: UIAlertActionStyle.default, handler: { (action) -> Void in
        // Clear List
        shoppingArray.removeAll()
        let tempArr = shoppingArray
        defaults.set(tempArr, forKey: "tempArr")
        
        shoppingArray = tempArr
        self.shoppingTableView.reloadData()
        self.shoppingTableView.isHidden = true
    })
    let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
    })
    alert.addAction(ok); alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
}
    
    
    
// MARK: - SHARE LIST BUTTON
@IBAction func shareListButt(_ sender: AnyObject) {
    var listStr = ""
    for i in 0..<shoppingArray.count { listStr += "\(shoppingArray[i])\n" }
    
    let messageStr  = "List of ingredients I need:\n\n \(listStr))"
    let shareItems = [messageStr]
    
    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
    
    if UIDevice.current.userInterfaceIdiom == .pad {
        // iPad
        let popOver = UIPopoverController(contentViewController: activityViewController)
        popOver.present(from: CGRect.zero, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
    } else {
        // iPhone
        present(activityViewController, animated: true, completion: nil)
    }
}

    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




// MARK: - CUSTOM SHOPPING CELL
class ShoppingCell: UITableViewCell {
    /* Views */
    @IBOutlet weak var itemLabel: UILabel!
    
    /* Variables */
    var selectedCell = Bool()
    
}
