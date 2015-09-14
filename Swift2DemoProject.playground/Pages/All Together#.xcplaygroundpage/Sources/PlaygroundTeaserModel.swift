import UIKit

public protocol FOLContent {
    var identifier: Int { get }
}

public extension FOLContent {
    func getShortURL() -> NSURL?
    {
        return NSURL(string: "http://www.focus.de/\(identifier)")
    }
}

public extension CollectionType where Generator.Element : FOLContent {
    func getAllShortURLs() -> [NSURL] {
        return self.flatMap({ (element) -> NSURL? in
            return element.getShortURL()
        })
    }
}

public protocol JSONInitilizable {
    init?(json: JSONDict)
}

public extension JSONInitilizable {
    public static func createModelArray(jsonArray: JSONArray) -> [Self] {
        return jsonArray.flatMap(Self.init)
    }
}

public protocol TeaserModel : FOLContent, JSONInitilizable {
    var headline: String { get }
    var overhead: String { get }
    var teaserImage: ImageModel { get }
}

public protocol ImageModel: JSONInitilizable {
    var imageURL: NSURL { get }
    var image: UIImage? { get set }
    var placeHolderImage: UIImage? { get }
    init?(json: JSONDict, placeHolderImage: UIImage?)
}

public extension ImageModel {
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

public struct TeaserImageModel : ImageModel
{
    public var imageURL: NSURL
    public var image: UIImage? = nil
    public var placeHolderImage : UIImage?
    
    public init?(json: JSONDict, placeHolderImage: UIImage? = nil) {
        guard let urlString = json["url"] as? String,
            let url = NSURL(string: urlString)
            else { return nil }
        self.imageURL = url
        self.placeHolderImage = placeHolderImage
    }
}

public enum FOLRessort : String, JSONInitilizable{
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
    
    public func standardImage() -> UIImage
    {
        return UIImage(named: "ressort-\(self.rawValue.lowercaseString)_iPhone")!
    }
    
    public init?(json: JSONDict) {
        guard let ressortString = json["ressort"] as? String else {return nil}
        self.init(rawValue: ressortString)
    }
}

public struct PlaygroundTeaserModel : TeaserModel{
    public let identifier: Int
    public let headline: String
    public let overhead: String
    public var teaserImage: ImageModel
    public let ressort: FOLRessort
    
    public init?(json : JSONDict) {
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