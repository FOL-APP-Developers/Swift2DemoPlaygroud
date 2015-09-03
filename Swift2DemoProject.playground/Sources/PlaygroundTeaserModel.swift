import Foundation

public struct PlaygroundTeaserModel {
    let headline : String
    let overhead : String
    let ressort : String
    
    public init?(json : JSONDict) {
        guard let headline = json["headline"] as? String,
            let overhead = json["overhead"] as? String,
            let ressort = json["ressort"] as? String
        else {
            return nil
        }
        
        self.headline = headline
        self.overhead = overhead
        self.ressort = ressort
    }
}