import Foundation
import UIKit

public protocol FOCUSTeaser {
    var model : PlaygroundTeaserModel? { get set }
}

extension UILabel {
    class func standardLabelWithSize(size : CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(size)
        return label
    }
}

public class PlaygroundTableViewCell : UITableViewCell, FOCUSTeaser
{
    static let identifier = "PlaygroundCell"
    
    let headlineLabel = UILabel.standardLabelWithSize(16)
    
    let overheadLabel = UILabel.standardLabelWithSize(12)
    
    let teaserImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        }()
    
    
    public var model : PlaygroundTeaserModel? {
        didSet{
            headlineLabel.text = model?.headline
            overheadLabel.text = model?.overhead
            model?.teaserImage.loadImageAsync({ [weak self](image) -> Void in
                self?.teaserImageView.image = image
            })
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(headlineLabel)
        self.contentView.addSubview(overheadLabel)
        self.contentView.addSubview(teaserImageView)
        setLayoutContraints()
    }

    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayoutContraints()
    {
        let views = ["headlineLabel" : headlineLabel, "overheadLabel" : overheadLabel, "teaserImageView" : teaserImageView]
        
        teaserImageView.setContentHuggingPriority(249, forAxis: .Vertical)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[teaserImageView(50)]-[headlineLabel]-|", options: NSLayoutFormatOptions(), metrics: [:], views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[teaserImageView]-[overheadLabel]-|", options: [], metrics: [:], views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[overheadLabel]-[headlineLabel]-|", options: [], metrics: [:], views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[teaserImageView(50)]-(>=20)-|", options: [], metrics: [:], views: views))
    }
}