/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit

class Categories: UIViewController,
UITableViewDelegate,
UITableViewDataSource
{
    
    /* Views */
    let selectedView = UIImageView()
    
    
    /* Variables */
    

    
    
override func viewDidLoad() {
        super.viewDidLoad()

    selectedView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
    selectedView.image = UIImage(named: "selectedImage")
    
    
}

   
   
// MARK: - TABLEVIEW DELEGATES
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoriesArray.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
    cell.textLabel?.text = "\(categoriesArray[indexPath.row])"
    cell.imageView?.image = UIImage(named: "\(categoriesArray[indexPath.row])")
    
    
return cell
}
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
}
    
// MARK: -  SELECT CELL
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCell = tableView.cellForRow(at: indexPath)!
    selectedCell.accessoryView = selectedView
    categoryStr = selectedCell.textLabel!.text!
}
// DESELECT CELL
func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let selectedCell = tableView.cellForRow(at: indexPath)!
    selectedCell.backgroundColor = UIColor.white
    selectedCell.accessoryView = nil
}
    
    
    
    
// MARK: - OK BUTTON
@IBAction func okButt(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
}
    

    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
