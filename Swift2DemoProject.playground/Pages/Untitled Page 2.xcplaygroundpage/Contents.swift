import Foundation
//: Machen wir unser JSON zu Teaser Modelen

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


struct PlaygroundTeaserModel{
    let identifier: Int
    let headline: String
    let overhead: String
    let ressort: String
    
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

func createTeaserModels(jsonArray: JSONArray) -> [PlaygroundTeaserModel]
{
    var models: [PlaygroundTeaserModel] = []
    for teaserItem in jsonArray {
        if let model = PlaygroundTeaserModel(json: teaserItem) {
            models.append(model)
        }
    }
    return models
}

func createTeaserModels3(jsonArray: JSONArray) -> [PlaygroundTeaserModel]
{
    return jsonArray.flatMap({ (teaserJSON) in
        return PlaygroundTeaserModel(json: teaserJSON)
    })
}

func createTeaserModels2(jsonArray: JSONArray) -> [PlaygroundTeaserModel]
{
    return jsonArray.flatMap(PlaygroundTeaserModel.init)
}

getOfflineJSON { (json) -> Void in
    if let itemArray = json["items"] as? JSONArray {
        let items = createTeaserModels2(itemArray)
        print(items)
    }
}