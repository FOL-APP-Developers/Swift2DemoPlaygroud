import UIKit

protocol FOLContent {
    var identifier: Int { get }
}

extension FOLContent {
    func getShortURL() -> NSURL?
    {
        return NSURL(string: "http://www.focus.de/\(identifier)")
    }
}

extension CollectionType where Generator.Element : FOLContent {
    func getAllShortURLs() -> [NSURL] {
        return self.flatMap({ (element) -> NSURL? in
            return element.getShortURL()
        })
    }
}

protocol JSONInitilizable {
    init?(json: JSONDict)
}

extension JSONInitilizable {
    static func createModelArray(jsonArray: JSONArray) -> [Self] {
        return jsonArray.flatMap(Self.init)
    }
}

protocol TeaserModel : FOLContent, JSONInitilizable {
    var headline: String { get }
    var overhead: String { get }
    var teaserImage: ImageModel { get }
}

protocol ImageModel: JSONInitilizable {
    var imageURL: NSURL { get }
    var image: UIImage? { get set }
    var placeHolderImage: UIImage? { get }
    init?(json: JSONDict, placeHolderImage: UIImage?)
}

extension ImageModel {
    mutating func loadImageAsync(completionBlock: ((UIImage) -> Void)) {
        if let placeHolderImage = placeHolderImage {
            completionBlock(placeHolderImage)
        }
        print("Start Loading image with URL: \(self.imageURL)")
        NSURLSession.sharedSession().dataTaskWithURL(imageURL, completionHandler: { (data, response, eror) -> Void in
            if let data = data,
                let newImage = UIImage(data: data)
            {
                self.image = newImage
                dispatch_async(dispatch_get_main_queue(), {
                    completionBlock(newImage)
                })
            }
        }).resume()
    }
    
    init?(json: JSONDict) {
        self.init(json: json, placeHolderImage: nil)
    }
}

struct TeaserImageModel : ImageModel
{
    var imageURL: NSURL
    var image: UIImage? = nil
    var placeHolderImage : UIImage?
    
    init?(json: JSONDict, placeHolderImage: UIImage? = nil) {
        guard let urlString = json["url"] as? String,
            let url = NSURL(string: urlString)
            else { return nil }
        self.imageURL = url
        self.placeHolderImage = placeHolderImage
    }
}

enum FOLRessort : String, JSONInitilizable{
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
    
    init?(json: JSONDict) {
        guard let ressortString = json["ressort"] as? String else {return nil}
        self.init(rawValue: ressortString)
    }
}

struct PlaygroundTeaserModel : TeaserModel{
    let identifier: Int
    let headline: String
    let overhead: String
    var teaserImage: ImageModel
    let ressort: FOLRessort
    
    init?(json : JSONDict) {
        guard let headline = json["headline"] as? String,
            let overhead = json["overhead"] as? String,
            let ressort = FOLRessort(json: json),
            let identifier = json["id"] as? Int,
            let imageJSON = json["image"] as? JSONDict,
            let imageModel = TeaserImageModel(json: imageJSON)
            else {
                return nil
        }
        
        self.headline = headline
        self.overhead = overhead
        self.ressort = ressort
        self.identifier = identifier
        self.teaserImage = imageModel
    }
}