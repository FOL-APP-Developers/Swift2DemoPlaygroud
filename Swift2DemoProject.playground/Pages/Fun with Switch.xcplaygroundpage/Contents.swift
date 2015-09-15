import UIKit

//: Just a little mor fun with Switch
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Some identifier") ?? UITableViewCell()
    
    switch (indexPath.section, indexPath.row) {
    case (0,0), (5,5):
        cell.backgroundColor = UIColor.blueColor()
    case (_,3):
        cell.backgroundColor = UIColor.brownColor()
    case (let section, _) where section % 3 == 0:
        cell.backgroundColor = UIColor.redColor()
    default:
        break
    }
    return cell
}
