import Foundation
import UIKit
import CoreLocation

//: Dann bilden wir mal unsere Ressorts als Enums ab
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
    
    func standardImage() -> UIImage
    {
        return UIImage(named: "ressort-\(self.rawValue.lowercaseString)_iPhone")!
    }
}
//: Jetzt nutzen wir es in unserem Teaser Model
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
        self.ressort = FOLRessort(rawValue: ressort.capitalizedString)
        self.identifier = identifier
    }
}
//: Noch schnell zwei Methode um die Teaser aus dem JSON zu holen, wie bevor
func createPlaygroundTeaserModels(jsonArray: JSONArray) -> [PlaygroundTeaserModel]
{
    return jsonArray.flatMap(PlaygroundTeaserModel.init)
}

var models : [PlaygroundTeaserModel] = []
getOfflineJSON { (json) -> Void in
    if let itemArray = json["items"] as? JSONArray {
        models = createPlaygroundTeaserModels(itemArray)
    }
}
//: Jetzt können das Enum nutzen
models.forEach { (model) -> () in
    guard let ressort = model.ressort else {return}
    print(model.overhead)
    switch ressort {
    case .Auto, .Digital:
        print("Technik!")
    case .Finanzen:
        print("Nur Börsen Crashs")
    case .Gesundheit:
        print("Die zehn besten Methoden seinen Körper kaputt zu machen")
    case .Immobilien:
        print("Jetzt Mieten oder Kaufen?")
    case .Kultur:
        print("Inzwischen fast das selbe")
    case .Reisen:
        print("Nur schöne Fotos und ekel Stories")
    case .Politik:
        print("Rechts oder Links, mitte gibt es nicht")
        fallthrough
    case .Sport, .Panorama:
        print("Eins der Stärksten Ressorts")
    case .Wissen:
        print("Ein Hauch von Wissenschaft")
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

//: Andere Beispiele Für Enums

enum NotLocatedReason : ErrorType{
    case NotFound
    case UserRefused
    case Undefined
}

enum UserLocation {
    case Located(CLLocation)
    case NotLocated(NotLocatedReason)
}

enum FOLRessort2 {
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
    case Regional(String)
    
    func displayString() -> String {
        switch self {
        case Auto:
            return "Auto"
        case Digital:
            return "Digital"
        case Finanzen:
            return "Finanzen"
        case Gesundheit:
            return "Gesundheit"
        case Immobilien:
            return "Immobilien"
        case Kultur:
            return "Kultur"
        case Panorama:
            return "Panorama"
        case Politik:
            return "Politik"
        case Reisen:
            return "Reisen"
        case Sport:
            return "Sport"
        case Wissen:
            return "Wissen"
        case let Regional(city):
            return "Reginal(\(city))"
        }
    }
    
    static func ressortForString(ressortString : String) -> FOLRessort2? {
        switch ressortString {
        case "Auto", "auto":
            return Auto
        case "Digital", "digital":
            return Digital
        case "Finanzen", "finanzen":
            return Finanzen
        case "Gesundheit", "gesundheit":
            return Gesundheit
        case "Immobilien", "immobilien":
            return Immobilien
        case "Kultur", "kultur":
            return Kultur
        case "Panorama", "panorama":
            return Panorama
        case "Politik", "politik":
            return Politik
        case "Reisen", "reisen":
            return Reisen
        case "Sport", "sport":
            return Sport
        case "Wissen", "wissen":
            return Wissen
        default:
            let regexString = "(?<=Regional\\().+(?=\\))"
            if let cityRange = ressortString.rangeOfString(regexString, options: .RegularExpressionSearch) {
                return Regional(ressortString.substringWithRange(cityRange))
            } else {
                return nil
            }
            
        }
    }
}

let ressortString = "Regional(Kölle)"

let ressort = FOLRessort2.ressortForString(ressortString)

print(ressort)
