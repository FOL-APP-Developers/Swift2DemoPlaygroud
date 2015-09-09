import Foundation
//: Machen wir unser JSON zu Teaser Modelen

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

//: The Old Way
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

//: A swiftier way

func createTeaserModels2(jsonArray: JSONArray) -> [PlaygroundTeaserModel]
{
    return jsonArray.map({ (teaserJSON) in
        return PlaygroundTeaserModel(json: teaserJSON)!
    })
}

//: get rid of that pesky "!"
func createTeaserModels3(jsonArray: JSONArray) -> [PlaygroundTeaserModel]
{
    return jsonArray.flatMap({ (teaserJSON) in
        return PlaygroundTeaserModel(json: teaserJSON)
    })
}

//: An even swiftier way
func createTeaserModels4(jsonArray: JSONArray) -> [PlaygroundTeaserModel]
{
    return jsonArray.flatMap(PlaygroundTeaserModel.init)
}

//: Lets Test it
getOfflineJSON { (json) -> Void in
    if let itemArray = json["items"] as? JSONArray {
        let items = createTeaserModels4(itemArray)
        print(items)
    }
}
