import Foundation
import UIKit

struct PlaygroundTeaserModel{
    let identifier: Int
    let headline: String
    let overhead: String
    let ressort: FOLRessort?
    
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
        self.ressort = FOLRessort(rawValue: ressort)
        self.identifier = identifier
    }
}

func createPlaygroundTeaserModels(jsonArray: JSONArray) -> [PlaygroundTeaserModel]
{
    return jsonArray.flatMap(PlaygroundTeaserModel.init)
}

enum FOLRessort : String{
    case Auto
    case Digital
    case Finanzen
    case Gesundheit
    case Immobilien
    case Kultur
    case Panorama
    case Politik
    case Reisen
    case Sport
    case Wissen
    
    func standardImage() -> UIImage?
    {
        return UIImage(named: "ressort-\(self.rawValue.lowercaseString)_iPhone")
    }
}

var models : [PlaygroundTeaserModel] = []
getOfflineJSON { (json) -> Void in
    if let itemArray = json["items"] as? JSONArray {
        models = createPlaygroundTeaserModels(itemArray)
    }
}

var tableViewData: [FOLRessort : [PlaygroundTeaserModel]] = [:]


for teaser in models {
    if let ressort = teaser.ressort {
        var ressortTeasers = tableViewData[ressort] ?? []
        ressortTeasers.append(teaser)
        tableViewData[ressort] = ressortTeasers
    }
}

print(tableViewData)







