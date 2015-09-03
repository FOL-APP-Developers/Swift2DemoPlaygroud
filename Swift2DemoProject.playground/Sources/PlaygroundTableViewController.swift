import UIKit

public class PlaygroundTableViewController : UITableViewController {
    public var modelArray : [PlaygroundTeaserModel] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    public func setModelsWithJSON(json : JSONDict)
    {
        guard let items = json["items"] as? JSONArray else {return}
        var modelArray : [PlaygroundTeaserModel] = []
        for teaserJSON in items {
            if let model = PlaygroundTeaserModel(json: teaserJSON) {
                modelArray.append(model)
            }
        }
        self.modelArray = modelArray
    }
    
    override public init(style: UITableViewStyle) {
        super.init(style: style)
        self.title = "TestViewController"
        tableView.registerClass(PlaygroundTableViewCell.self, forCellReuseIdentifier: PlaygroundTableViewCell.identifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PlaygroundTableViewCell.identifier) as? PlaygroundTableViewCell ?? PlaygroundTableViewCell()
        cell.model = modelArray[indexPath.row]
        return cell
    }
}
