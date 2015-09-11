import Foundation



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

