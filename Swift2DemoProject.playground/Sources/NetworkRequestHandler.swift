import Foundation

public typealias JSONDict = [NSObject : AnyObject]
public typealias JSONArray = [JSONDict]

public class NetworkRequestHandler {
    static let sharedInstance = NetworkRequestHandler()
    
    public class func getOverviewJSON(completionBlock: (JSONDict) -> Void)
    {
        guard let jsonURL = NSURL(string: "http://json.focus.de/home/?cst=7") else {return}
        
        sharedInstance.getJSONForURL(jsonURL, withCompletionBlock: completionBlock)
    }
    
    func getJSONForURL(jsonURL : NSURL, withCompletionBlock completionBlock: (JSONDict) -> Void) {
        NSURLSession.sharedSession().dataTaskWithURL(jsonURL, completionHandler: handleSessionResponseWithCompletionBlock(completionBlock)).resume()
    }
    
    func handleSessionResponseWithCompletionBlock(competionBlock : (JSONDict) -> Void) (data :NSData?, response : NSURLResponse?, error : NSError?) -> Void
    {
        guard let data = data else { print("Request failed: ", error); return}
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? JSONDict {
                dispatch_async(dispatch_get_main_queue(), {
                    competionBlock(json)
                })
            }
        } catch let error{
            print("NSJSONSerialization.JSONObjectWithData failed with error: \(error)")
        }
    }
}

public func getOfflineJSON(completionBlock: (JSONDict) -> Void)
{
    if  let path = NSBundle.mainBundle().pathForResource("home", ofType: "json"),
        let jsonData = NSData(contentsOfFile: path),
        let deserializedJSON = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments),
        let json = deserializedJSON as? JSONDict
    {
        completionBlock(json)
    }
}



