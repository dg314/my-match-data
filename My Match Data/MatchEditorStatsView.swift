import UIKit

class MatchEditorStatsView: UIView, UITableViewDelegate, UITableViewDataSource {
    var matchEditorView: MatchEditorMainView
    
    var width: CGFloat!
    var height: CGFloat!
    
    var matchSectionSegmentedControl: UISegmentedControl!
    var playerOneNameLabel: UILabel!
    var playerTwoNameLabel: UILabel!
    var statsTableView: UITableView!
    
    var statLists: [StatList]!
    
    let id = "statIdentifier"
    
    init(frame: CGRect, matchEditorView: MatchEditorMainView) {
        self.matchEditorView = matchEditorView
        
        super.init(frame: frame)
        
        width = self.bounds.width
        height = self.bounds.height
        
        var matchSectionOptions = ["Match"]
        
        for n in 0..<matchEditorView.matchEditorViewController.match.scoringType!.setsToWinMatch * 2 - 1 {
            matchSectionOptions.append("Set \(n + 1)")
        }
        
        matchSectionSegmentedControl = UISegmentedControl(items: matchSectionOptions)
        
        for n in matchEditorView.matchEditorViewController.match.sets.count..<matchEditorView.matchEditorViewController.match.scoringType!.setsToWinMatch * 2 - 1 {
            matchSectionSegmentedControl.setEnabled(false, forSegmentAt: n + 1)
        }
        
        matchSectionSegmentedControl.frame = CGRect(x: 20, y: 20, width: width - 40, height: 30)
        
        if #available(iOS 13.0, *) {
            matchSectionSegmentedControl.selectedSegmentTintColor = .white
            matchSectionSegmentedControl.backgroundColor = .lightGray
            matchSectionSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
            matchSectionSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .disabled)
        }
        else {
            matchSectionSegmentedControl.tintColor = .white
        }
        
        matchSectionSegmentedControl.selectedSegmentIndex = 0
        matchSectionSegmentedControl.addTarget(self, action: #selector(update), for: .valueChanged)
        self.addSubview(matchSectionSegmentedControl)
        
        statsTableView = UITableView(frame: CGRect(x: 0, y: 70, width: width, height: height - 100), style: .grouped)
        statsTableView.backgroundColor = .black
        statsTableView.separatorColor = .white
        statsTableView.showsVerticalScrollIndicator = false
        self.addSubview(statsTableView)
        
        update()
        
        statsTableView.register(StatsTableViewCell.self, forCellReuseIdentifier: id)
        statsTableView.rowHeight = 30
        statsTableView.sectionHeaderHeight = 30
        
        statsTableView.separatorInset = .zero
        statsTableView.layoutMargins = .zero
        statsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        
        statsTableView.delegate = self
        statsTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return statLists.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statLists[section].stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatsTableViewCell! = StatsTableViewCell(style: .default, reuseIdentifier: id, stat: statLists[indexPath.section].stats[indexPath.row], width: width)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return statLists[section].title
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 10, y: 5, width: width - 20, height: 20)
        titleLabel.font = UIFont.regular(size: 18)
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        titleLabel.textColor = .white
        
        let headerView = UIView()
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    @objc func update() {
        for n in 0..<matchEditorView.matchEditorViewController.match.scoringType!.setsToWinMatch * 2 - 1 {
            matchSectionSegmentedControl.setEnabled(n < matchEditorView.matchEditorViewController.match.sets.count, forSegmentAt: n + 1)
        }
        
        statLists = matchEditorView.matchEditorViewController.match.getStatList(index: matchSectionSegmentedControl.selectedSegmentIndex - 1)
        
        statsTableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
