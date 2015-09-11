import UIKit

//: First Try on a cell
class FirstCell : UITableViewCell {
    let headlineLabel : UILabel
    let overheadLabel : UILabel
    let teaserImageView :UIImageView
    var model : PlaygroundTeaserModel?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//: All Properties have to be initialized befor super.init
        headlineLabel = UILabel()
        overheadLabel = UILabel()
        teaserImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//: Only After you can Use self
        self.contentView.addSubview(headlineLabel)
        self.contentView.addSubview(overheadLabel)
        self.contentView.addSubview(teaserImageView)
    }
//: If one designated Initalizer is overridden all must be 
//: "All for one, and one for all"
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//: Second Try
class SecondCell : UITableViewCell {
//: We can initilize the Properties when we declare them
    let headlineLabel = UILabel()
//: We can also initilize them with a closure
    let overheadLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    let teaserImageView = UIImageView()
//: Listeners can also be defined
    var model : PlaygroundTeaserModel? {
        didSet{
            headlineLabel.text = model?.headline
            overheadLabel.text = model?.overhead
            teaserImageView.image = UIImage(named: "ressort-auto_iPhone")
        }
    }
}

//: Lets make a nice one

extension UILabel {
    class func standardLabelWithSize(size : CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(size)
        return label
    }
}

class PlaygroundTableViewCell : UITableViewCell
{
    static let identifier = "PlaygroundCell"
    
    let headlineLabel = UILabel.standardLabelWithSize(16)
    
    let overheadLabel = UILabel.standardLabelWithSize(12)
    
    let teaserImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        }()
    
    
    var model : PlaygroundTeaserModel? {
        didSet{
            headlineLabel.text = model?.headline
            overheadLabel.text = model?.overhead
            teaserImageView.image = UIImage(named: "ressort-auto_iPhone")
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
    
    required init?(coder aDecoder: NSCoder)
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

//: Lets Look at it

//import XCPlayground
//
//let cell = PlaygroundTableViewCell()
//
//getOfflineJSON { (json) -> Void in
//    if let itemArray = json["items"] as? JSONArray {
//        let models = createPlaygroundTeaserModels(itemArray)
//        cell.model = models.first
//    }
//}
//
//cell.frame = CGRect(origin: CGPointZero, size: cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize))
//
//XCPShowView("PlaygroundTableViewCell", view: cell)

