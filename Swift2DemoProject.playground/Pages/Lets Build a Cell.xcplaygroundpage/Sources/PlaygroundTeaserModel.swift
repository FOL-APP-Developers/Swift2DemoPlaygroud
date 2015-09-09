import Foundation

public struct PlaygroundTeaserModel{
    public let identifier: Int
    public let headline: String
    public let overhead: String
    public let ressort: String
    
    init?(json : JSONDict) {
        guard let headline = json["headline"] as? String,
            let overhead = json["overhead"] as? String,
            let ressort = json["ressort"] as? String,
            let identifier = json["id"] as? Int
            else {
                return nil
        }
        
        self.headline = headline
        self.overhead = overhead
        self.ressort = ressort
        self.identifier = identifier
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

public func createPlaygroundTeaserModels(jsonArray: JSONArray) -> [PlaygroundTeaserModel]
{
    return jsonArray.flatMap(PlaygroundTeaserModel.init)
}