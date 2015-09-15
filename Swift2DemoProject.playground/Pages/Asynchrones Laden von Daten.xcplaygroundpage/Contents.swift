import Foundation
import XCPlayground

//: Laden wir uns mal das Focus HomePage JSON

XCPSetExecutionShouldContinueIndefinitely(true)

let jsonURL = NSURL(string: "http://json.focus.de/home/?cst=7")

let task = NSURLSession.sharedSession().dataTaskWithURL(jsonURL!) { [jsonURL] (data :NSData?, response : NSURLResponse?, error : NSError?) -> Void in
    print("The URL: \(jsonURL) \nResponded with : \(data)")
}

//task.resume()

//: Jetzt müssen wir natürlich noch die Daten Deserialisieren

typealias NSURLDataTaskCompletionHandler = (NSData?, NSURLResponse?, NSError?) -> Void

let deserializeBlock : NSURLDataTaskCompletionHandler = {(data, _, _) in
    guard let data = data else {return}
    let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
    print(json)
}

let taskWithBlock = NSURLSession.sharedSession().dataTaskWithURL(jsonURL!, completionHandler: deserializeBlock)

//taskWithBlock.resume()

//: Das Wollen wir jetzt aber schon in einer schönen Klasse haben. Am besten noch ein Singelton damit alle Request von einer Instance geManaged werden können

public class NetworkRequestHandler {
    static let sharedInstance = NetworkRequestHandler()
    
    class func getOverviewJSON()
    {
        guard let jsonURL = NSURL(string: "http://json.focus.de/home/?cst=7") else {return}
        
        sharedInstance.getJSONForURL(jsonURL)
    }
    
    func getJSONForURL(jsonURL: NSURL)
    {
        NSURLSession.sharedSession().dataTaskWithURL(jsonURL, completionHandler: handleSessionResponseWithCompletionBlock).resume()
    }
    
    func handleSessionResponseWithCompletionBlock(data :NSData?, response : NSURLResponse?, error : NSError?) -> Void
    {
        guard let data = data else {
            print("Request failed: ", error)
            return
        }
        
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? JSONDict {
                print(json)
            }
        } catch let error{
            print("NSJSONSerialization.JSONObjectWithData failed with error: \(error)")
        }
    }
}

//NetworkRequestHandler.getOverviewJSON()
//: Da drücken wir jetzt noch einen completion block rein

//Do it, Just Do it

//: Damit wir jetzt nict immer so lang warten Müssen laden wir das JSON aus einer Datei

func getOfflineJSON(completionBlock: (JSONDict) -> Void)
{
    if  let path = NSBundle.mainBundle().pathForResource("home", ofType: "json"),
        let jsonData = NSData(contentsOfFile: path),
        let deserializedJSON = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments),
        let json = deserializedJSON as? JSONDict
    {
        completionBlock(json)
    }
}

//getOfflineJSON { (json) -> Void in
//    print(json)
//}

