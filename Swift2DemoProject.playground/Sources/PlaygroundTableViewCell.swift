import Foundation
import UIKit

public protocol FOCUSTeaser {
    var model : PlaygroundTeaserModel? { get set }
}

public class PlaygroundTableViewCell : UITableViewCell, FOCUSTeaser
{
    static let identifier = "PlaygroundCell"
    
    public var model : PlaygroundTeaserModel? {
        didSet{
            self.textLabel?.text = model?.headline
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.redColor()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}