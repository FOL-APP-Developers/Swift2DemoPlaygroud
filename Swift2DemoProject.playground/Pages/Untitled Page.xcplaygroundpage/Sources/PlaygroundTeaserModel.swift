import UIKit

protocol JSONInitilizable {
    init?(json : JSONDict)
}

protocol ImageModel: JSONInitilizable {
    var imageURL: NSURL { get set }
    var image: UIImage? { get set }
    var updateViewBlock: ((UIImage) -> Void)? { get set }
}

extension ImageModel {
    mutating func loadImageAsync () {
        print("Start Loading image with URL: \(self.imageURL)")
        NSURLSession.sharedSession().dataTaskWithURL(imageURL, completionHandler: { (data, response, eror) -> Void in
            if let data = data,
                let newImage = UIImage(data: data)
            {
                self.image = newImage
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateViewBlock?(newImage)
                })
            }
        }).resume()
    }
    
    mutating func setIntermediateImage(intermediateImage: UIImage) {
        self.image = intermediateImage
    }
}

protocol EscenicElement {
    var identifier: Int { get }
}

protocol TeaserModel : EscenicElement,JSONInitilizable {
    var headline: String { get }
    var overhead: String { get }
    var teaserImage: ImageModel { get }
}


struct TeaserImageModel : ImageModel
{
    var imageURL: NSURL
    var image: UIImage? = nil
    var updateViewBlock: ((UIImage) -> Void)? = nil
    
    init?(json: JSONDict) {
        guard let urlString = json["url"] as? String,
            let url = NSURL(string: urlString)
            else { return nil }
        imageURL = url
        
//        loadImageAsync()
    }
}

public struct PlaygroundTeaserModel : TeaserModel{
    let identifier: Int
    let headline: String
    let overhead: String
    var teaserImage: ImageModel
    let ressort: String
    
    public init?(json : JSONDict) {
        guard let headline = json["headline"] as? String,
            let overhead = json["overhead"] as? String,
            let ressort = json["ressort"] as? String,
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
        setIntermediateTeaser()
    }
    
    mutating func setIntermediateTeaser() {
        teaserImage.setIntermediateImage(UIImage(named: "ressort-auto_iPhone")!)
    }
}