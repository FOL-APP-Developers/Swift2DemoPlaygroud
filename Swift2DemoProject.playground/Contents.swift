//: Playground - noun: a place where people can play

import UIKit
import XCPlayground


let tableviewController = PlaygroundTableViewController(style: .Plain)


let navigationController = UINavigationController(rootViewController: tableviewController)
navigationController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 640)

getOfflineJSON(tableviewController.setModelsWithJSON)

//XCPSetExecutionShouldContinueIndefinitely()
//NetworkRequestHandler.getJSON(tableviewController.setModelsWithJSON)

XCPShowView("TableView", view: navigationController.view)

