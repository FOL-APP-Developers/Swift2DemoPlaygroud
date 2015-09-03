import Foundation
import UIKit

public protocol FOCUSTeaser {
    var model : PlaygroundTeaserModel? { get set }
}

public class PlaygroundTableViewCell : UITableViewCell, FOCUSTeaser
{
    static let identifier = "PlaygroundCell"
    
    let headlineLabel :UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(16)
        return label
    }()

    let overheadLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(12)
        return label
        }()
    
    public var model : PlaygroundTeaserModel? {
        didSet{
            headlineLabel.text = model?.headline
            overheadLabel.text = model?.overhead
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(headlineLabel)
        self.contentView.addSubview(overheadLabel)
        setLayoutContraints()
    }

    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayoutContraints()
    {
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        overheadLabel.translatesAutoresizingMaskIntoConstraints = false
        let views = ["headlineLabel" : headlineLabel, "overheadLabel" : overheadLabel]
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[headlineLabel]-|", options: NSLayoutFormatOptions(), metrics: [:], views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[overheadLabel]-|", options: [], metrics: [:], views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[overheadLabel]-[headlineLabel]-|", options: [], metrics: [:], views: views))
    }
}