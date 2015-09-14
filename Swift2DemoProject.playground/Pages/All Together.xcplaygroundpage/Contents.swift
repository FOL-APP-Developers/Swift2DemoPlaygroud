import XCPlayground
import UIKit

XCPSetExecutionShouldContinueIndefinitely(true)

let tableViewController = PlaygroundTableViewController(style: .Plain)

let naviController = UINavigationController(rootViewController: tableViewController)
naviController.view.frame = CGRect(origin: CGPointZero, size: CGSize(width: 320, height: 640))

getOfflineJSON { (json) -> Void in
    if let itemJSONArray = json["items"] as? JSONArray {
        tableViewController.modelArray = PlaygroundTeaserModel.createModelArray(itemJSONArray)
    }
}

XCPShowView("NaviController", view: naviController.view)



