import Foundation

public typealias JSONDict = [NSObject : AnyObject]
public typealias JSONArray = [JSONDict]

public class NetworkRequestHandler {
    static let sharedInstance = NetworkRequestHandler()
    
    public class func getJSON(completionBlock: (JSONDict) -> Void)
    {
        let jsonURLString = "http://json.focus.de/home/?cst=7"
        guard let jsonURL = NSURL(string: jsonURLString) else {return}
        
        sharedInstance.getJSONForURL(jsonURL, withCompletionBlock: completionBlock)
    }
    
    func getJSONForURL(jsonURL : NSURL, withCompletionBlock completionBlock: (JSONDict) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(jsonURL, completionHandler: handleSessionResponseWithCompletionBlock(completionBlock))
        task.resume()
    }
    
    func handleSessionResponseWithCompletionBlock(competionBlock : (JSONDict) -> Void) -> (data :NSData?, response : NSURLResponse?, error : NSError?) -> Void
    {
        return { (data, response, error) in
            guard let data = data else { print("Request failed: ", error); return}
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? JSONDict {
                    competionBlock(json)
                }
            } catch let error{
                print("NSJSONSerialization.JSONObjectWithData failed with error: \(error)")
            }
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



