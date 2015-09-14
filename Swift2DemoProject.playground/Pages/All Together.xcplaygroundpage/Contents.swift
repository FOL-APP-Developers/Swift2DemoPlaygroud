import XCPlayground
import UIKit

let tableViewController = PlaygroundTableViewController(style: .Plain)

let naviController = UINavigationController(rootViewController: tableViewController)
naviController.view.frame = CGRect(origin: CGPointZero, size: CGSize(width: 320, height: 640))

getOfflineJSON { (json) -> Void in
    if let itemArray = json["items"] as? JSONArray {
        tableViewController.modelArray = PlaygroundTeaserModel.createModelArray(itemArray)
    }
}

XCPShowView("NaviController", view: naviController.view)



