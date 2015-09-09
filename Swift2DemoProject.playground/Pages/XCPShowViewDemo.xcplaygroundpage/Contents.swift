import UIKit

//: Import XCPlayground eine Toolbox für anspruchvolleres Umgehen mit dem Playground
import XCPlayground

//: Zum Testen Erstellen wir uns einen TableViewController
let tableviewController = UITableViewController(style: .Plain)

//: Und packen den in einen NavigationController, just for the Looks.
//: Da wir kein Gerät haben geben wir der View am besten noch einen festen Frame
let navigationController = UINavigationController(rootViewController: tableviewController)
navigationController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 640)
//: Und zuletzt benutzen wir noch eine Funktion von XCPlayground um uns da Ergebnis anzugucken
XCPShowView("NavigationController", view: navigationController.view)

