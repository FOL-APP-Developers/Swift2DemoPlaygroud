import UIKit
import CoreSpotlight

//: Fangen wir mit einem Essentiellen Protocol an
protocol FOLContent {
    var identifier: Int { get }
}
//: Allein mit der Info eines Identifiers können wir schon die Short URL zusammen basteln
extension FOLContent {
    func getShortURL() -> NSURL?
    {
        return NSURL(string: "http://www.focus.de/\(identifier)")
    }
}
//: Und allein weil wirs Können wollen wir das auch für alle CollectionsType's machen
extension CollectionType where Generator.Element : FOLContent {
    func getAllShortURLs() -> [NSURL] {
        return self.flatMap({ (element) -> NSURL? in
            return element.getShortURL()
        })
    }
}

//: Außerdem bauen wir alle Elemente aus einem JSON
protocol JSONInitilizable {
    init?(json: JSONDict)
}
//: Und meist haben wir davon ein ganzes JSONArray das Initializirt werden will
extension JSONInitilizable {
    static func createModelArray(jsonArray: JSONArray) -> [Self] {
        return jsonArray.flatMap(Self.init)
    }
}

//:Unsere Basic Teaser würden dann ungefähr so aussehen
protocol TeaserModel : FOLContent, JSONInitilizable {
    var headline: String { get }
    var overhead: String { get }
    var teaserImage: ImageModel { get }
}
//:Und ein ImageModel so
protocol ImageModel: JSONInitilizable {
    var imageURL: NSURL { get }
    var image: UIImage? { get set }
    var placeHolderImage: UIImage? { get }
    init?(json: JSONDict, placeHolderImage: UIImage?)
}
//:Ein Bild laden ist auch bei jede, ImageModel gleich
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
//: Bis jetzt haben wir noch kein struct oder Classe definiert
//:
//: Fangen wir mit dem Bild an, nicht viel zu tun hier
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
//: Auch unser enum von vorher können wir jetzt mit einem Protocol versehen
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
//: der Entgültige Teaser sieht dann so aus
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
            let imageModel = TeaserImageModel(json: imageJSON, placeHolderImage: ressort.standardImage())
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


//: Wir können auch Protokolle nutzen um Funktionalität im nachhinein hinzuzufügen.
protocol IndexableArticleModel : TeaserModel
{
    var ressortName : String? {get}
}

extension IndexableArticleModel {
//: Swift 2.0 bietet auch eine einfache methode gegen Versionen zu checken
    @available(iOS 9.0, *)
    func contentAttributeSet() -> CSSearchableItemAttributeSet
    {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: "kUTTypeContent") //der String kUTTypeContent ist nur bedingt richtig an dieser Stelle
        attributeSet.contentDescription = headline
        attributeSet.title = overhead
        attributeSet.subject = ressortName
        if let image = self.teaserImage.image {
            attributeSet.thumbnailData = UIImagePNGRepresentation(image)
        }
        
        return attributeSet
    }
    
    @available(iOS 9.0, *)
    func registerInCoreSpotlight()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let attributeSet = self.contentAttributeSet()
            let item = CSSearchableItem(uniqueIdentifier: "\(self.identifier)", domainIdentifier: "article", attributeSet: attributeSet)
            CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { error in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    else {
                        print("Item: \(self.overhead) indexed")
                    }
            }
        }
    }
    
    //        if #available(iOS 9.0, *) {
    //            registerInCoreSpotlight()
    //        }
}

//: Jetzt machen wir noch unser PlaygroundTeaserModel Indexable
extension PlaygroundTeaserModel : IndexableArticleModel {
    var ressortName : String? {
        get{
            return self.ressort.rawValue
        }
    }
}
